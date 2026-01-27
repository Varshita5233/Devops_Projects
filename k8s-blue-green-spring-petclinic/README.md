🚀 **Spring PetClinic – Blue-Green CI/CD Deployment on AWS EKS**
This project demonstrates a real-world DevOps CI/CD pipeline implementing Blue-Green Deployment using Jenkins, Docker, and AWS EKS (Kubernetes).

The goal was to build an automated, zero-downtime deployment pipeline with image versioning and traffic switching between environments.

🧱 **Architecture Overview**
```
Developer → GitHub → Jenkins → Docker → DockerHub → AWS EKS → Users
```
🛠️ **Tech Stack**
| Category            | Tools Used              |
|---------------------|-------------------------|
| CI/CD               | Jenkins                 |
| Code Repository     | GitHub                  |
| Build Tool          | Maven                   |
| Containerization    | Docker                  |
| Container Registry  | DockerHub               |
| Orchestration       | Kubernetes (AWS EKS)    |
| Cloud               | AWS (EC2 + EKS)         |
| Deployment Strategy | Blue-Green Deployment   |

⚙️ **Jenkins Pipeline Stages**
The pipeline automates the entire deployment lifecycle:
1. Clean Workspace
2. Git Checkout
3. Maven Build
4. Docker Image Build
5. Docker Image Push to DockerHub
6. Deploy to IDLE Environment (Blue/Green)
7. Health Check Validation
8. Switch Traffic to New Version
9. Post Cleanup
    
🖥️ **Jenkins EC2 Setup**
Jenkins server runs on AWS EC2 (Ubuntu, t2.large).
**Installed Tools**
1. Java 17
2. Jenkins
3. Maven
4. Docker
5. kubectl
6. AWS CLI
This EC2 acts as the DevOps control server.
🐳 Docker Image Strategy

Each deployment builds a versioned image:
```
jyotsna2181/petclinic:<build-number>
```
This ensures:
- No image overwrite
- Traceability
- Rollback capability
  
☸️ **Kubernetes Deployment Strategy**
Two environments run in EKS:
| Environment | Purpose                 |
|-----------  |-------------------------|
| Blue        | Currently live          |
| Green       | New version deployment  |

Both environments run separate Deployments but share a single Service.

🔄 **Traffic Switching (Blue-Green Logic)**
The Kubernetes Service selector is updated via pipeline:
```
kubectl patch svc petclinic-svc -n petclinic \
  -p '{"spec":{"selector":{"app":"petclinic","version":"green"}}}'
```
This shifts user traffic from Blue → Green without downtime.

🧪 **Health Checks**
Application health is validated using Spring Boot Actuator:
```
livenessProbe:
  httpGet:
    path: /actuator/health
    port: 8080

readinessProbe:
  httpGet:
    path: /actuator/health
    port: 8080
```
Ensures traffic switches only when the app is healthy.

🎯 **Key Achievements**
- Implemented zero-downtime deployment
- Automated full CI/CD pipeline
- Used image versioning instead of latest
- Built real production-like Kubernetes workflow
- Implemented traffic switching at Service level

🚀 **Final Outcome**
This project simulates a real enterprise DevOps pipeline where:
```
Code → Build → Containerize → Push → Deploy → Health Check → Switch Traffic
```
<img width="1920" height="1080" alt="Finalss" src="https://github.com/user-attachments/assets/c7a5b3e1-299e-46b6-ab61-ae13794eea6a" />

All automated.
