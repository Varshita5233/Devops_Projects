# EKS CI/CD Pipeline with Terraform & Jenkins

![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

A production-grade CI/CD pipeline that automatically builds, pushes, and deploys a Node.js application to Amazon EKS using Jenkins, Docker, ECR, and Terraform-provisioned infrastructure.

---

## Architecture Overview

```
Developer pushes code to GitHub
            ↓
    Jenkins Pipeline triggers
            ↓
  Docker build → ECR push (ap-south-1)
            ↓
  kubectl apply → Amazon EKS
            ↓
  AWS Load Balancer Controller (IRSA)
            ↓
  Public endpoint via AWS ALB/ELB
```

---

## Project Structure

```
Devops_Projects/eks-terraform-project/
├── app/                        # Node.js application
│   ├── server.js
│   ├── package.json
│   └── Dockerfile
├── cicd/
│   └── Jenkinsfile             # CI/CD pipeline definition
├── infra/                      # Terraform IaC
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   └── modules/
│       ├── vpc/                # VPC, subnets, IGW, NAT
│       ├── eks/                # EKS cluster
│       └── node-groups/        # EKS managed node groups
└── k8s/
    └── base/                   # Kubernetes manifests
        ├── namespace.yaml
        ├── deployment.yaml
        ├── service.yaml
        ├── configmap.yaml
        └── hpa.yaml
```

---

## Tech Stack

| Category | Tools |
|---|---|
| Infrastructure | Terraform, AWS EKS, VPC, ECR, ALB |
| CI/CD | Jenkins (on EC2 via SSM) |
| Containerization | Docker, Amazon ECR |
| Orchestration | Kubernetes (EKS), kubectl |
| Security | IRSA, IAM Roles, SSM Session Manager |
| Monitoring | HPA (Horizontal Pod Autoscaler) |
| App | Node.js 18 (Alpine) |

---

## Infrastructure (Terraform)

Provisioned using modular Terraform with remote state backend:

- **VPC** — Custom VPC with public/private subnets across 2 AZs
- **EKS Cluster** — `eks-terraform-project-demo-dev` in `ap-south-1`
- **Node Groups** — Managed node groups with auto-scaling
- **Remote State** — S3 backend with DynamoDB locking

```hcl
# Remote state config
terraform {
  backend "s3" {
    bucket         = "<your-state-bucket>"
    key            = "eks-terraform-project/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "<your-lock-table>"
  }
}
```

---

## CI/CD Pipeline

The Jenkins pipeline runs on every code change and executes these stages:

```
Checkout → Build Docker Image → Login to ECR → Tag & Push to ECR
        → Update Deployment Image → Deploy to Kubernetes
```

### Pipeline Stages

| Stage | Description | Time |
|---|---|---|
| Checkout | Pull latest code from GitHub | ~1s |
| Build Docker Image | Multi-stage Docker build | ~3s (cached) |
| Login to ECR | Authenticate with AWS ECR | ~2s |
| Tag & Push to ECR | Push image with build number tag | ~2s |
| Update Deployment Image | Inject image tag into manifest | <1s |
| Deploy to Kubernetes | kubectl apply to EKS | ~5s |

### Image Tagging Strategy
Images are tagged with build number: `v1.${BUILD_NUMBER}`
```
911319296463.dkr.ecr.ap-south-1.amazonaws.com/varshita5233/ecr-eks-repo:v1.8
```

---

## AWS Load Balancer Controller Setup

The LBC was configured with **IRSA (IAM Roles for Service Accounts)** for secure, credential-free AWS API access:

1. **OIDC Provider** registered for the EKS cluster
2. **IAM Role** with trust policy scoped to the LBC service account
3. **Kubernetes SA** annotated with the IAM role ARN
4. **LBC installed via Helm** with `serviceAccount.create=false`

```bash
# IRSA annotation on ServiceAccount
eks.amazonaws.com/role-arn: arn:aws:iam::911319296463:role/AmazonEKSLoadBalancerControllerRole
```

---

## Kubernetes Resources

### Deployment
- **Replicas:** 2
- **Image:** Pulled from ECR, updated on every pipeline run
- **Health Checks:** Liveness and readiness probes on `/`
- **Config:** Environment variables injected via ConfigMap

### Service
- **Type:** LoadBalancer
- **Port:** 80 → Container 3000
- **Scheme:** internet-facing (via LBC annotation)

### HPA (Horizontal Pod Autoscaler)
- Automatically scales pods based on CPU utilization
- Min replicas: 2, Max replicas: configurable

---

## Prerequisites

- AWS CLI configured with appropriate permissions
- `kubectl` installed
- `terraform` >= 1.5
- `helm` >= 3.x
- `docker` installed
- Jenkins with required plugins:
  - Kubernetes CLI
  - Git
  - Pipeline

---

## Deployment Guide

### 1. Provision Infrastructure
```bash
cd infra/
terraform init
terraform plan
terraform apply
```

### 2. Configure kubectl
```bash
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name eks-terraform-project-demo-dev
```

### 3. Install AWS Load Balancer Controller
```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=eks-terraform-project-demo-dev \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=ap-south-1 \
  --set vpcId=<YOUR_VPC_ID>
```

### 4. Configure Jenkins Pipeline
- Add repo URL: `https://github.com/Varshita5233/Devops_Projects.git`
- Branch: `*/main`
- Script Path: `eks-terraform-project/cicd/Jenkinsfile`

### 5. Run Pipeline
Click **Build Now** in Jenkins or push a commit to trigger automatically.

---

## Live Demo

Application is accessible at:
```
http://k8s-eksnodea-eksnodea-a7c7f1fd58-4cdeb8ddcd1a6667.elb.ap-south-1.amazonaws.com
```

Sample response:
```json
{
  "message": "Hello from EKS! 🚀",
  "environment": "production",
  "version": "1.0.0",
  "hostname": "eks-node-app-66749cf4d-z4x5t",
  "timestamp": "2026-04-03T05:01:51.129Z"
}
```

---

## Security Highlights

- Jenkins EC2 accessed exclusively via **AWS SSM Session Manager** (no SSH, no public IP)
- **IRSA** used for LBC — no static AWS credentials in pods
- **Least-privilege IAM** — Jenkins role has only required permissions
- ECR images scanned with **Trivy** in pipeline
- Node groups in **private subnets** only

---

## Key Learnings & Challenges

- Configured IRSA from scratch without `eksctl` using AWS CLI and manual trust policy creation
- Debugged LBC `FailedBuildModel` errors — root cause was missing IRSA annotation and incomplete RBAC ClusterRole
- Resolved Jenkins `/tmp` disk threshold issue blocking node from coming online
- Fixed annotation typo in service manifest (`serice` → `service`)

---

## Author

**Varshita Rajana**
- GitHub: [@Varshita5233](https://github.com/Varshita5233)
- LinkedIn: [linkedin.com/in/varshita-rajana](https://linkedin.com/in/varshita-rajana)

---

## Certifications

- HashiCorp Certified: Terraform Associate (004) — March 2026
- AWS Certified Cloud Practitioner — April 2023
- GitHub Foundations — May 2025