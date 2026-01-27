🚀 #Spring PetClinic – Blue-Green CI/CD Deployment on AWS EKS
This project demonstrates a real-world DevOps CI/CD pipeline implementing Blue-Green Deployment using Jenkins, Docker, and AWS EKS (Kubernetes).

The goal was to build an automated, zero-downtime deployment pipeline with image versioning and traffic switching between environments.

🧱 #Architecture Overview
#CI/CD Flow
```
Developer → GitHub → Jenkins → Docker → DockerHub → AWS EKS → Users
```
🛠️ Tech Stack
Category
Tools Used
CI/CD
Jenkins
Code Repository
GitHub
Build Tool
Maven
Containerization
Docker
Container Registry
DockerHub
Security Scanning
Trivy
Orchestration
Kubernetes (AWS EKS)
Cloud
AWS (EC2 + EKS)
Deployment Strategy
Blue-Green Deployment
⚙️ Jenkins Pipeline Stages
The pipeline automates the entire deployment lifecycle:
Clean Workspace
Git Checkout
Maven Build
Docker Image Build
Docker Image Push to DockerHub
Deploy to IDLE Environment (Blue/Green)
Health Check Validation
Switch Traffic to New Version
Post Cleanup
🖥️ Jenkins EC2 Setup
Jenkins server runs on AWS EC2 (Ubuntu, t2.large).
Installed Tools
Java 17
Jenkins
Maven
Docker
Trivy (security scanning)
kubectl
AWS CLI
This EC2 acts as the DevOps control server.
🐳 Docker Image Strategy
Each deployment builds a versioned image:
Copy code

jyotsna2181/petclinic:<build-number>
This ensures:
No image overwrite
Traceability
Rollback capability
☸️ Kubernetes Deployment Strategy
Two environments run in EKS:
Environment
Purpose
Blue
Currently live
Green
New version deployment
Both environments run separate Deployments but share a single Service.
🔄 Traffic Switching (Blue-Green Logic)
The Kubernetes Service selector is updated via pipeline:
Copy code
Bash
kubectl patch svc petclinic-svc -n petclinic \
  -p '{"spec":{"selector":{"app":"petclinic","version":"green"}}}'
This shifts user traffic from Blue → Green without downtime.
🧪 Health Checks
Application health is validated using Spring Boot Actuator:
Copy code
Yaml
livenessProbe:
  httpGet:
    path: /actuator/health
    port: 8080

readinessProbe:
  httpGet:
    path: /actuator/health
    port: 8080
Ensures traffic switches only when the app is healthy.
🔐 Security Scanning
Before deployment:
Trivy FS Scan → source code dependencies
Trivy Image Scan → container vulnerabilities
Prevents insecure images from reaching production.
🎯 Key Achievements
✔ Implemented zero-downtime deployment
✔ Automated full CI/CD pipeline
✔ Used image versioning instead of latest
✔ Built real production-like Kubernetes workflow
✔ Implemented traffic switching at Service level
🚀 Final Outcome
This project simulates a real enterprise DevOps pipeline where:
Code → Build → Scan → Containerize → Push → Deploy → Health Check → Switch Traffic
All automated.
