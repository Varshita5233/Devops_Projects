# EKS Microservices Platform

A two-tier microservices application on AWS EKS with automated CI/CD, ingress via
the AWS Load Balancer Controller, horizontal autoscaling, and full observability
with Prometheus and Grafana.

## What this demonstrates

| Area | What's shown |
|------|--------------|
| AWS | EKS, ECR, ALB, IAM (IRSA), VPC networking |
| Kubernetes | Deployments, Services, Ingress, HPA, probes, self-healing, RBAC |
| Microservices | Two tiers, pod-to-pod (east-west) communication, service discovery |
| Helm | Templated charts, per-environment values, conditional resources |
| CI/CD | GitHub Actions: build both images, push to ECR, deploy with Helm |
| Observability | Prometheus (infra + custom app metrics), Grafana dashboards, alerting |

## Architecture

```
                        Developer
                            |
                         git push
                            |
                            v
                     GitHub Actions (CI/CD)
                     - build frontend + backend images (commit SHA tag)
                     - push to ECR
                     - helm upgrade (backend first, then frontend)
                            |
                            v
 =============================================== EKS cluster (prod namespace) ===
 |                                                                             |
 |   User browser                                                             |
 |       |                                                                    |
 |     DNS                                                                    |
 |       v                                                                    |
 |   +-------+     north-south (IP target mode)                              |
 |   |  ALB  | ---------------------------------+                            |
 |   +-------+                                   |                            |
 |   (created by AWS LB Controller via IRSA)     v                           |
 |                                        +----------------+                  |
 |                                        | Frontend pods  |  Ingress + HPA   |
 |                                        +----------------+                  |
 |                                                |                           |
 |                                    calls http://backend-service           |
 |                                    (east-west, pod-to-pod)                 |
 |                                                v                           |
 |                                        +----------------+                  |
 |                                        | backend-service|  ClusterIP       |
 |                                        | CoreDNS+kube-proxy                |
 |                                        +----------------+                  |
 |                                                |                           |
 |                                                v                           |
 |                                        +----------------+                  |
 |                                        | Backend pods   |  internal + HPA  |
 |                                        +----------------+                  |
 |                                                                             |
 |   Prometheus  <--- scrapes /metrics (ServiceMonitor) --- frontend         |
 |       |                                                                     |
 |       v                                                                     |
 |   Grafana (dashboards + alerting)                                          |
 ===============================================================================
```

## Two kinds of traffic

North-south (internet to frontend):
```
Browser -> DNS -> ALB -> frontend pod (directly, IP target mode)
```
The ALB routes straight to pod IPs because the VPC CNI gives each pod a real VPC IP.

East-west (frontend to backend, pod-to-pod):
```
Frontend pod -> http://backend-service -> CoreDNS -> ClusterIP -> kube-proxy -> backend pod
```
Service discovery by name. Never touches the ALB. This is the internal microservices call.

## Components

### Frontend (helm/myapp)
- Deployment (3 replicas in prod), Service (ClusterIP), Ingress (ALB), HPA
- Exposed to the internet via the ALB
- Calls the backend internally and displays which backend pod responded
- Exposes /metrics for Prometheus (request count, backend calls, errors)
- Per-environment values: values-dev.yaml (1 replica), values-prod.yaml (3 + HPA)

### Backend (helm/backend)
- Deployment (2 replicas), Service (backend-service, ClusterIP), HPA
- Internal only - no Ingress, not reachable from the internet
- Returns which backend pod handled the request

### AWS Load Balancer Controller
- Runs in the cluster with IRSA (IAM Role for Service Accounts)
- Watches Ingress resources and creates/manages the ALB
- Registers pod IPs as ALB targets (IP target mode)

### CI/CD (.github/workflows/deploy.yml)
- Triggered on push to main
- Builds frontend and backend images, tagged with the commit SHA (immutable)
- Pushes both to ECR
- Deploys with Helm: backend first, then frontend

### Monitoring (kube-prometheus-stack)
- Prometheus scrapes infrastructure metrics AND the app's custom /metrics endpoint
  (via a ServiceMonitor, every 15s - pull-based)
- Grafana: pre-built Kubernetes dashboards + a custom app dashboard
- Alerting: fires when backend error rate crosses a threshold

## Key design decisions

- Immutable image tags (commit SHA, never "latest") - precise versioning and rollback
- One Helm chart per service - independent packaging, versioning, deployment
- Per-environment values files - no duplicated YAML, no config drift
- helm upgrade --install - idempotent deploys
- Backend is ClusterIP only - internal, not exposed (security)
- Independent HPA per tier - frontend and backend scale on their own load
- Readiness + liveness probes - safe rollouts and self-healing
- IRSA over static keys - the controller uses temporary credentials, no secrets

## Autoscaling - each tier independently

Both the frontend and backend have their own HPA. This is deliberate: each tier
scales on its own load. The frontend scales on user traffic; the backend scales on
its own processing load. They can have completely different profiles - which is one
of the main reasons for separating services into tiers. The HPA measures usage
against the pod's CPU request (not the limit), and never exceeds maxReplicas.

## Project structure

```
eks-demo/
├── app/                          # frontend (Node), calls backend, exposes /metrics
│   ├── server.js
│   └── Dockerfile
├── backend/                      # backend (Node), returns its pod name
│   ├── server.js
│   └── Dockerfile
├── helm/
│   ├── myapp/                    # frontend chart
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   ├── values-dev.yaml
│   │   ├── values-prod.yaml
│   │   └── templates/
│   │       ├── deployment.yaml
│   │       ├── service.yaml      # named port "http" for scraping
│   │       ├── ingress.yaml      # ALB ingress
│   │       ├── hpa.yaml
│   │       └── servicemonitor.yaml
│   └── backend/                  # backend chart
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           └── hpa.yaml
└── .github/workflows/
    └── deploy.yml                # builds + deploys both services
```

## Demos this supports

1. Live dashboard - frontend + backend pod names, auto-refreshing
2. Self-healing - delete a pod, watch Kubernetes recreate it (reconciliation loop)
3. Autoscaling - generate load, watch HPA add pods (both tiers, independently)
4. CI/CD - push code, watch the pipeline build both images and deploy
5. Pod-to-pod - the frontend calling the backend, visible in the browser
6. Monitoring - Grafana dashboards, custom app metrics, and a firing alert

## Region / cluster

- Region: ap-south-1 (Mumbai)
- Cluster: demo-cluster
- Namespaces: prod (app), monitoring (Prometheus/Grafana)

## Cleanup (avoid charges)

```
helm uninstall monitoring -n monitoring
kubectl delete namespace monitoring
helm uninstall myapp -n prod
helm uninstall backend -n prod
eksctl delete cluster --name demo-cluster --region ap-south-1
```
Then check the AWS console for any leftover ALB or EBS volumes and delete them.