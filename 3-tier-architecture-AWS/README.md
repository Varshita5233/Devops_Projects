# Production‑Ready 3‑Tier AWS Architecture

This project demonstrates a complete, secure, and highly available three‑tier web application deployed on AWS. Built entirely from scratch over three days, it incorporates industry best practices for networking, security, auto scaling, monitoring, and secrets management.

![Architecture Diagram](./architecture-diagram/3tier-arch.png)  
*(Replace with your actual diagram file)*

---

## 🏗️ Architecture Overview

The application is divided into three logical tiers, each deployed across two Availability Zones for high availability:

- **Web Tier** – Serves static content and proxies API requests to the app tier.
- **App Tier** – Runs a Node.js application that processes business logic and queries the database.
- **Data Tier** – An Amazon RDS MySQL database, isolated from the internet.

All components are contained within a custom VPC with public, private, and isolated subnets. Security groups enforce strict, least‑privilege communication between tiers.

---

## ✨ Key Features

- ✅ **Highly Available** – Multi‑AZ deployment for all tiers.
- ✅ **Secure by Design** – Private subnets, security group chaining, no public access to app/database.
- ✅ **Auto Scaling** – Web and app tiers scale based on CPU utilization.
- ✅ **Infrastructure as Code ready** – All configurations can be recreated from this documentation.
- ✅ **Centralised Secrets Management** – Database credentials stored in AWS Secrets Manager, no hardcoded secrets.
- ✅ **Operational Excellence** – Access instances via AWS Systems Manager Session Manager (no SSH keys).
- ✅ **Comprehensive Monitoring** – CloudWatch dashboards and alarms for CPU, latency, and errors.

---

## 🛠️ Technologies Used

| Category       | Services                                                                 |
|----------------|--------------------------------------------------------------------------|
| **Compute**    | EC2, Auto Scaling Groups, Launch Templates                               |
| **Networking** | VPC, Subnets, Route Tables, Internet Gateway, NAT Gateway, Security Groups |
| **Load Balancing** | Application Load Balancers (External & Internal)                     |
| **Database**   | Amazon RDS for MySQL (isolated subnets, Multi‑AZ)                        |
| **Security**   | IAM Roles, Security Groups, AWS Secrets Manager                          |
| **Monitoring** | CloudWatch Dashboards, CloudWatch Alarms                                 |
| **Access**     | AWS Systems Manager Session Manager                                      |

---

## 🚀 Deployment Steps (Summary)

### 1. Network Layer
- Created VPC `10.0.0.0/16` with 6 subnets across 2 AZs: public, private, and isolated.
- Set up Internet Gateway, NAT Gateways, and route tables to control traffic flow.

### 2. Security Groups
- **`external-lb-sg`** – Allows HTTP/HTTPS from internet.
- **`web-tier-sg`** – Allows HTTP only from external ALB.
- **`internal-lb-sg`** – Allows HTTP from web-tier-sg.
- **`app-tier-sg`** – Allows traffic on port 4000 from internal‑lb‑sg; DNS outbound.
- **`db-sg`** – Allows MySQL (3306) from app-tier-sg.

### 3. Database Tier
- Launched RDS MySQL in isolated subnets, Multi‑AZ, no public access.
- Initialised schema and sample data using a script.

### 4. App Tier
- Node.js application with endpoints `/health`, `/api/test`, `/api/test-db`.
- Systemd service to ensure app runs on boot.
- Integrated **AWS Secrets Manager** – credentials fetched at startup, no env vars.
- Created AMI from configured instance.
- Auto Scaling Group (min=2, max=4) with target tracking scaling policy (avg CPU = 50%).

### 5. Web Tier
- Nginx serving static `index.html` and proxying `/api/*` to internal ALB.
- Updated HTML to use relative URLs (`API_BASE_URL = ''`).
- Created AMI, ASG with min=2, attached to external ALB.

### 6. Monitoring
- CloudWatch dashboard displaying:
  - External ALB request count and 5xx errors
  - App tier CPU utilization
  - Database connections and freeable memory
- Alarms for:
  - App CPU >80% (SNS email notification)
  - Web 5xx errors >0
  - RDS connections >50

---

## 🔐 Security Highlights

- **IAM Roles** – EC2 instances assume roles with minimal permissions (SSM, Secrets Manager read).
- **Secrets Manager** – Database credentials are never stored in code or environment variables. The app retrieves them at runtime.
- **Security Group Chaining** – Each tier only accepts traffic from the previous tier’s security group, never from wide IP ranges.
- **No Bastion Hosts** – All administrative access via Session Manager, with full audit logs.

---

## ⚠️ Challenges & Solutions

| Challenge                                      | Solution                                                                                       |
|------------------------------------------------|------------------------------------------------------------------------------------------------|
| Web instances unhealthy in target group        | Corrected security group inbound rule to allow traffic from ALB security group.                |
| App tier 504 from internal ALB                 | Changed target group port from 80 to 4000 and updated listener.                                |
| SSM Agent unable to register                   | Added IAM role with `AmazonSSMManagedInstanceCore` to launch template and performed instance refresh. |
| Inconsistent web instances                      | Created new AMI from manually fixed instance, updated launch template, and ran instance refresh. |
| Secrets Manager `AccessDenied`                  | Fixed IAM policy resource ARN to include the random suffix (or used a wildcard).               |

---

## 📊 Testing

- Verified web page loads via external ALB DNS.
- Tested API endpoints: `/api/test` and `/api/test-db` return expected JSON.
- Simulated CPU load using Python script to trigger auto scaling.
- Confirmed CloudWatch alarms send email notifications.

---

## 🧹 Clean Up

To avoid ongoing charges, remember to:
- Stop or terminate EC2 instances.
- Delete NAT Gateways and release Elastic IPs.
- Delete Load Balancers and Target Groups.
- Delete Auto Scaling groups.
- Take a final snapshot of RDS and delete the database.
- Delete unused AMIs and snapshots.

---

## 📌 What I Learned

- Deep understanding of AWS networking and security groups.
- How to troubleshoot load balancer health checks and target group configurations.
- Importance of IAM least‑privilege and how to debug permission issues.
- Automating instance configuration with user data and systemd.
- Integrating AWS Secrets Manager to eliminate hardcoded secrets.

---

## 🔗 Links

- [GitHub Repository](https://github.com/Varshita5233/Devops_Projects/tree/main/aws-3tier-production-project)
- [My LinkedIn Profile](https://www.linkedin.com/in/your-profile) *(replace with your actual URL)*

---

## 🏆 Acknowledgements

This project was built as a hands‑on learning experience to solidify AWS concepts. Special thanks to the AWS documentation and community resources that helped along the way.
