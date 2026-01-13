## YouTube Clone - CI/CD Pipeline (Jenkins + SonarQube + Trivy + Docker + AWS EKS)

## 📌 Project Overview
This project demonstrates an end-to-end **CI/CD pipeline** for a **YouTube Clone application** using DevOps best practices.  
The pipeline automates code checkout, code quality scanning, security scanning, Docker image build & push, and deployment to **AWS EKS**.

---

## ✅ Tech Stack Used
- **Jenkins** – CI/CD automation
- **SonarQube** – Code Quality & Security Analysis
- **Trivy** – Filesystem + Docker image vulnerability scanning
- **Docker** – Containerization
- **DockerHub** – Image Registry
- **AWS EKS** – Kubernetes Deployment
- **Terraform** – Infrastructure provisioning (EC2, Security Group, etc.)
- **GitHub** – Source Code management

---

## 🚀 Pipeline Stages
The Jenkins Pipeline includes the following stages:

1. **Clean Workspace**
2. **Checkout from Git**
3. **SonarQube Analysis**
4. **Quality Gate Check**
5. **Install Dependencies**
6. **Trivy Scan (Filesystem)**
7. **Docker Build & Push (DockerHub)**
8. **Trivy Scan (Docker Image)**
9. **Deploy to AWS EKS Cluster**

---

## 🛠 Jenkins Tools Configured
- **JDK 17**
- **NodeJS 16**
- **Sonar Scanner**
- Required Jenkins Plugins:
  - SonarQube Scanner
  - Pipeline
  - Docker Pipeline
  - Credentials Binding
  - Kubernetes
  - Email Extension (optional)

---

## 🔐 Credentials Used in Jenkins
Configured under:

**Jenkins Dashboard → Manage Jenkins → Credentials**

- `sonarQube-Token` (Secret Text)
- `dockerhub` (Username & Password)
- AWS credentials (if required)

---

## 🌐 SonarQube Setup
- SonarQube is installed on EC2 instance (Docker container / direct setup).
- Integrated with Jenkins using token.
- **Quality Gate** is enabled to ensure builds fail if code quality fails.

---

## 🛡 Trivy Security Scanning
Trivy is used for:
- **Filesystem Scan** (Project dependencies & vulnerabilities)
- **Docker Image Scan** (Before deployment)

Example:
```bash
trivy fs .

**## Docker Build & Push**
docker build -t youtube-clone .
docker tag youtube-clone <dockerhub-username>/youtube-clone:latest
docker push <dockerhub-username>/youtube-clone:latest

**## Kubernetes Deployment (AWS EKS)**
After successful build & scan, deployment is done to AWS EKS using kubectl.
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

**✨ Author
Varshita Rajana**
**DevOps | AWS | Kubernetes | CI/CD | Jenkins | Terraform**

trivy image <image-name>

