# Kubernetes WordPress Ingress Mini Project 🚀

This mini project demonstrates deploying a **stateful WordPress application on Kubernetes** with **MySQL**, secured networking, persistent storage, and **Ingress-based routing** using **NGINX Ingress Controller**.

The focus of this project is to practice **StatefulSets, Persistent Volumes, Secrets, Network Policies, and Ingress (Host & Path based routing)** in a real-world scenario.

---

## 🧱 Architecture Overview

- WordPress application exposed via **NGINX Ingress**
- MySQL deployed as a **StatefulSet** with persistent storage
- Kubernetes **Secrets** for database credentials
- **NetworkPolicy** to restrict pod-to-pod communication
- Host-based and Path-based routing implemented using Ingress

---

## 🛠️ Tools & Technologies Used

- Kubernetes (EKS compatible)
- NGINX Ingress Controller
- WordPress
- MySQL (StatefulSet)
- PersistentVolumeClaim (PVC)
- Kubernetes Secrets
- Network Policies
- YAML Manifests
  
---

## ✅ What I Implemented

- Deployed **WordPress application** using Kubernetes Deployment
- Deployed **MySQL as StatefulSet** with PersistentVolumeClaim
- Used **Kubernetes Secrets** for secure database credentials
- Configured **NetworkPolicy** to allow only WordPress → MySQL traffic
- Implemented **Host-based routing** using NGINX Ingress
- Implemented **Path-based routing** (e.g., `/`, `/admin`) using Ingress rules

---

## 🌐 Ingress Routing Details

### Host-Based Routing
- Routes traffic based on hostname
- Example:
  - `wordpress.example.com` → WordPress service

### Path-Based Routing
- Routes traffic based on URL path
- Example:
  - `/` → WordPress
  - `/admin` → Admin application

---

## 🔐 Security Considerations

- Database credentials stored securely using **Kubernetes Secrets**
- Network traffic restricted using **NetworkPolicy**
- No hardcoded passwords in manifests

---

## 📌 Learning Outcomes

- Clear understanding of **Stateful vs Stateless workloads**
- Hands-on experience with **Ingress controllers**
- Practical exposure to **Kubernetes networking & security**
- Real-world application deployment patterns

---

## 🧹 Cleanup

After practice, the cluster and resources can be safely deleted to avoid unnecessary cloud costs.

---

## 📷 Screenshots

Refer to the included screenshots (`*.png`) for:
- Pod & Service status
- Ingress routing validation
- WordPress UI
- NetworkPolicy behavior

---

## ⭐ Notes

This project is designed for **learning and practice purposes** and can be extended further with:
- TLS/HTTPS
- Horizontal Pod Autoscaling (HPA)
- Monitoring with Prometheus & Grafana

---

### ✨ Author
**Varshita Rajana**  
DevOps Engineer | Kubernetes | AWS | CI/CD


