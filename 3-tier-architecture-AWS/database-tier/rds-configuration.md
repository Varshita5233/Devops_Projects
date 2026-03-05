# RDS Database Configuration

This document describes the configuration of the Amazon RDS MySQL instance used as the database tier in the 3‑tier architecture project.

## Overview

- **Engine:** MySQL Community Edition
- **Version:** 8.4.7
- **Instance Identifier:** `database-1`
- **Region:** `ap-south-2` (Hyderabad)
- **Multi‑AZ Deployment:** Yes – a standby replica is automatically provisioned in a different Availability Zone for high availability.

## Configuration Details

### Instance Class
- **Type:** `db.t4g.micro` (burstable, 2 vCPU, 1 GiB RAM)
- **Free Tier Eligible:** Yes (when used in Single‑AZ, but Multi‑AZ incurs costs)

### Storage
- **Type:** General Purpose SSD (gp2)
- **Allocated Storage:** 20 GiB
- **Storage Autoscaling:** Enabled – can automatically increase storage up to 100 GiB if needed
- **Encryption at Rest:** Enabled (using AWS managed KMS key)

### Network & Security

#### VPC
- **VPC:** `3tier-vpc` (`vpc-0d1b68156612d0b3c`)
- **Subnet Group:** `db-subnet-group`
  - Includes both isolated subnets:
    - `private-db-subnet-az1` (`subnet-0fa0a7b42884936f3`, AZ `ap-south-2a`)
    - `private-db-subnet-az2` (`subnet-012171aaaf18ee6ce7`, AZ `ap-south-2b`)
- **Public Accessibility:** **No** – the database is not reachable from the internet.

#### Security Group
- **Security Group:** `db-sg` (`sg-05fb759a7552d5fe6`)
- **Inbound Rules:**
  - **Type:** MySQL/Aurora
  - **Protocol:** TCP
  - **Port:** 3306
  - **Source:** `app-tier-sg` (security group of the application instances) – ensures only the app tier can connect.
- **Outbound Rules:** None (default – all traffic allowed, but not needed for the database).

### Authentication & Secrets Management

- **Master Username:** `admin` (stored in AWS Secrets Manager, not hardcoded anywhere)
- **Master Password:** Stored in **AWS Secrets Manager** as a secret named `3tier-app/db-credentials-<random-suffix>`.
- **Secret Contents (JSON):**
  ```json
  {
    "username": "admin",
    "password": "<actual-password>",
    "host": "database-1.c3yumesu8n2h.ap-south-2.rds.amazonaws.com",
    "port": 3306,
    "dbname": "application"
  }