# EKS CI/CD Demo — Runbook

Follow these steps in order. Estimated time: 2-3 hours (mostly waiting on the cluster).

---

## PREREQUISITES (install locally if you don't have them)

- AWS CLI (`aws --version`)
- kubectl (`kubectl version --client`)
- eksctl (`eksctl version`)
- helm (`helm version`)
- docker (`docker --version`)

Configure AWS CLI with your credentials:
```bash
aws configure
# enter your Access Key, Secret Key, region us-east-1
```

---

## STEP 1 — Create the ECR repository (2 min)

```bash
aws ecr create-repository --repository-name myapp --region us-east-1
```

Note the `repositoryUri` in the output — you'll need it. It looks like:
`123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp`

Save it:
```bash
export ECR_URL=$(aws ecr describe-repositories --repository-names myapp \
  --region us-east-1 --query 'repositories[0].repositoryUri' --output text)
echo $ECR_URL
```

---

## STEP 2 — Create the EKS cluster (START THIS NOW — takes ~15-20 min)

Run this and let it work in the background while you do Steps 3-4.

```bash
eksctl create cluster \
  --name demo-cluster \
  --region us-east-1 \
  --nodes 2 \
  --node-type t3.medium \
  --managed
```

When done, verify:
```bash
kubectl get nodes
```
You should see 2 nodes in Ready state.

---

## STEP 3 — Build and test the Docker image locally (10 min)

```bash
cd app
docker build -t myapp:local .

# Test it locally
docker run -p 8080:8080 myapp:local
# Open http://localhost:8080 in a browser — you should see the demo page
# Ctrl+C to stop
cd ..
```

---

## STEP 4 — Push the image to ECR (5 min)

```bash
# Log in to ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin $ECR_URL

# Tag and push
docker tag myapp:local $ECR_URL:v1
docker push $ECR_URL:v1
```

---

## STEP 5 — Deploy with Helm (10 min)

First, make sure the cluster is ready (`kubectl get nodes` shows Ready).

**Deploy to DEV:**
```bash
helm upgrade --install myapp ./helm/myapp \
  --namespace dev \
  --create-namespace \
  -f ./helm/myapp/values-dev.yaml \
  --set image.repository=$ECR_URL \
  --set image.tag=v1 \
  --wait --timeout 5m
```

Check it:
```bash
kubectl get pods -n dev
kubectl get svc -n dev
```

Get the public URL (wait 1-2 min for the load balancer):
```bash
kubectl get svc myapp-myapp -n dev \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```
Open `http://<that-hostname>` in a browser. **Your app is live on EKS.**

**Also deploy to PROD to show env-specific values:**
```bash
helm upgrade --install myapp-prod ./helm/myapp \
  --namespace prod \
  --create-namespace \
  -f ./helm/myapp/values-prod.yaml \
  --set image.repository=$ECR_URL \
  --set image.tag=v1 \
  --wait --timeout 5m

kubectl get pods -n prod    # note: 3 replicas vs dev's 1
```

---

## STEP 6 — Set up the CI/CD pipeline (20 min)

1. Create a GitHub repo and push this project:
```bash
git init
git add .
git commit -m "Initial EKS demo"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/eks-demo.git
git push -u origin main
```

2. In GitHub: **Settings → Secrets and variables → Actions → New repository secret**

Add two secrets:
- `AWS_ACCESS_KEY_ID` — your AWS access key
- `AWS_SECRET_ACCESS_KEY` — your AWS secret key

3. The workflow (`.github/workflows/deploy.yml`) runs automatically on every push to main.

4. Trigger it — make any small change and push:
```bash
# edit app/server.js, change VERSION to 'v2'
git add .
git commit -m "Update to v2"
git push
```

5. Watch it run: GitHub repo → **Actions** tab. You'll see build → push → deploy happen automatically.

---

## THE DEMO SCRIPT (what to show the interviewer)

**1. Show the running app**
- Open the public URL. Refresh a few times → pod name changes → "load balancing across pods."

**2. Show self-healing**
```bash
kubectl get pods -n dev
kubectl delete pod <one-pod-name> -n dev
kubectl get pods -n dev -w    # watch it get recreated automatically
```
Say: "Kubernetes maintains the desired replica count — I deleted a pod and it recreated it. That's self-healing."

**3. Show env-specific deployment**
```bash
kubectl get pods -n dev     # 1 replica
kubectl get pods -n prod    # 3 replicas
```
Say: "Same Helm chart, different values file per environment — dev runs 1 replica, prod runs 3 with autoscaling."

**4. Show the CI/CD pipeline**
- Make a code change, push to GitHub.
- Show the Actions tab running: build image → push to ECR → helm deploy.
- Refresh the app → new version live.
Say: "A code push automatically builds an image tagged with the commit, pushes to ECR, and deploys to EKS with Helm. No manual steps."

**5. Show scaling (optional)**
```bash
kubectl scale deployment myapp-myapp -n dev --replicas=5
kubectl get pods -n dev    # watch 5 pods
```

---

## CLEANUP — CRITICAL, DO THIS AFTER THE DEMO (avoids AWS charges)

```bash
# Delete the Helm releases
helm uninstall myapp -n dev
helm uninstall myapp-prod -n prod

# Delete the cluster (this deletes the nodes and load balancers too)
eksctl delete cluster --name demo-cluster --region us-east-1

# Delete the ECR repo
aws ecr delete-repository --repository-name myapp --region us-east-1 --force
```

**Set a phone reminder to run cleanup.** An idle EKS cluster costs ~$0.10/hr for the control plane plus EC2 node costs — it adds up if left running.

---

## TALKING POINTS (weave these in during the demo)

- **Immutable image tags** — "I tag images with the commit SHA, never `latest`, so I always know exactly what's running and can roll back precisely."
- **helm upgrade --install** — "Idempotent — same command whether it's the first deploy or the fiftieth."
- **--atomic** — "If the deploy fails, Helm auto-rolls-back — no half-broken state."
- **Non-root container** — "The Dockerfile runs as a non-root user for security."
- **Probes** — "Readiness controls traffic, liveness controls restarts."
- **One chart, many environments** — "The chart is the package; each environment is just a different values file."
