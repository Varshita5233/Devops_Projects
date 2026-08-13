# EKS CI/CD Demo Project

A containerized web app deployed to AWS EKS with an automated CI/CD pipeline.

## What this demonstrates

| Area | What's shown |
|------|--------------|
| **AWS** | EKS cluster, ECR registry, IAM auth, LoadBalancer (ELB) |
| **Kubernetes** | Deployment, Service, HPA, probes, self-healing, load balancing |
| **Helm** | Templated chart, environment-specific values (dev/prod) |
| **CI/CD** | GitHub Actions: build → push to ECR → deploy to EKS |
| **Linux/Docker** | Multi-stage container, non-root user, CLI tooling |

## Architecture / Traffic flow

```
Developer pushes code
        │
        ▼
GitHub Actions pipeline
   ├─ builds Docker image (tagged with commit SHA)
   ├─ pushes image to ECR
   └─ runs `helm upgrade --install` against EKS
        │
        ▼
   EKS cluster
        │
   Client → LoadBalancer (ELB) → Service → Pods
        │
   (pods spread across 2 nodes, self-healing, autoscaling in prod)
```

## Project structure

```
eks-demo/
├── app/
│   ├── server.js           # tiny Node app, shows pod name
│   └── Dockerfile          # non-root container
├── helm/myapp/
│   ├── Chart.yaml          # chart metadata
│   ├── values.yaml         # default values
│   ├── values-dev.yaml     # dev overrides (1 replica)
│   ├── values-prod.yaml    # prod overrides (3 replicas + HPA)
│   └── templates/
│       ├── deployment.yaml # with probes, resources, env injection
│       ├── service.yaml    # LoadBalancer
│       └── hpa.yaml        # conditional autoscaler
└── .github/workflows/
    └── deploy.yml          # CI/CD pipeline

```

## Key design decisions

- **Immutable image tags** (commit SHA, not `latest`) — precise versioning and rollback
- **One chart, per-environment values** — no duplicated YAML, no config drift
- **`helm upgrade --install`** — idempotent deploys, safe to run every time
- **`--atomic`** — automatic rollback on failed deploy
- **Non-root container** — security best practice
- **Readiness + liveness probes** — safe rollouts and self-healing

See `RUNBOOK.md` for step-by-step setup and the demo script.
