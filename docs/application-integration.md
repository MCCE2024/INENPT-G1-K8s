# Application Repository Integration

## Overview

This infrastructure repository is designed to work with a separate application repository that contains the actual application code (Frontend, API, and Producer services). This document explains how to set up and integrate with the application repository.

## Application Repository Structure

The application repository should have the following structure:

```
AKTT1-Group1-K8S/
├── frontend/                 # Frontend service (Node.js/React)
│   ├── Dockerfile
│   ├── package.json
│   ├── src/
│   └── ...
├── api/                      # API service (Node.js/Python)
│   ├── Dockerfile
│   ├── package.json
│   ├── src/
│   └── ...
├── producer/                 # Producer service (Python CronJob)
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── src/
│   └── ...
├── helm-charts/              # Helm charts for services
│   ├── frontend/
│   ├── api/
│   └── producer/
├── applications/             # Kubernetes manifests
│   ├── core/
│   └── tenants/
└── ci-cd/                    # CI/CD workflows
    └── .github/workflows/
```

## Setting Up the Application Repository

### 1. Create Application Repository

```bash
# Clone the application repository
git clone https://github.com/your-org/AKTT1-Group1-K8S.git
cd AKTT1-Group1-K8S
```

### 2. Configure GitHub OAuth App

1. Go to your GitHub organization settings
2. Navigate to Developer settings → OAuth Apps
3. Create a new OAuth App:
   ```
   Application name: INENPT-G1 Multi-Tenant App
   Homepage URL: https://your-domain.com
   Authorization callback URL: https://your-domain.com/auth/callback
   ```
4. Note the Client ID and Client Secret

### 3. Set Up Container Registry

The application containers will be pushed to GitHub Container Registry (GHCR):

```bash
# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin
```

### 4. Create CI/CD Workflows

Create the following GitHub Actions workflows in the application repository:

#### Build and Push Workflow

```yaml
# ci-cd/.github/workflows/build-push.yml
name: Build and Push Containers

on:
  push:
    branches: [main]
    paths:
      - "frontend/**"
      - "api/**"
      - "producer/**"

jobs:
  build-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Frontend
        run: |
          cd frontend
          docker build -t ghcr.io/${{ github.repository }}/frontend:${{ github.sha }} .
          docker push ghcr.io/${{ github.repository }}/frontend:${{ github.sha }}
          docker tag ghcr.io/${{ github.repository }}/frontend:${{ github.sha }} ghcr.io/${{ github.repository }}/frontend:latest
          docker push ghcr.io/${{ github.repository }}/frontend:latest

  build-api:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build API
        run: |
          cd api
          docker build -t ghcr.io/${{ github.repository }}/api:${{ github.sha }} .
          docker push ghcr.io/${{ github.repository }}/api:${{ github.sha }}
          docker tag ghcr.io/${{ github.repository }}/api:${{ github.sha }} ghcr.io/${{ github.repository }}/api:latest
          docker push ghcr.io/${{ github.repository }}/api:latest

  build-producer:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Producer
        run: |
          cd producer
          docker build -t ghcr.io/${{ github.repository }}/producer:${{ github.sha }} .
          docker push ghcr.io/${{ github.repository }}/producer:${{ github.sha }}
          docker tag ghcr.io/${{ github.repository }}/producer:${{ github.sha }} ghcr.io/${{ github.repository }}/producer:latest
          docker push ghcr.io/${{ github.repository }}/producer:latest
```

## Integration with Infrastructure Repository

### 1. Update Infrastructure Variables

In the infrastructure repository, update the `terraform.tfvars` file:

```hcl
# Application repository configuration
argocd_repo_url      = "https://github.com/your-org/AKTT1-Group1-K8S"
argocd_repo_username = "your-github-username"
argocd_repo_password = "your-github-token"

# GitHub OAuth configuration
github_oauth_client_id     = "your-github-oauth-client-id"
github_oauth_client_secret = "your-github-oauth-client-secret"
github_org                = "your-github-organization"
```

### 2. Create Tenant Configuration

In the application repository, create tenant-specific configurations:

```yaml
# applications/tenants/mcce-g1/values.yaml
tenant:
  name: "mcce-g1"
  environments:
    - name: "prod"
      namespace: "mcce-g1-prod"
      domain: "prod.mcce-g1.yourdomain.com"
    - name: "test"
      namespace: "mcce-g1-test"
      domain: "test.mcce-g1.yourdomain.com"

services:
  frontend:
    image: "ghcr.io/your-org/AKTT1-Group1-K8S/frontend:latest"
    replicas: 2
    resources:
      requests:
        memory: "128Mi"
        cpu: "100m"
      limits:
        memory: "256Mi"
        cpu: "200m"

  api:
    image: "ghcr.io/your-org/AKTT1-Group1-K8S/api:latest"
    replicas: 2
    resources:
      requests:
        memory: "256Mi"
        cpu: "200m"
      limits:
        memory: "512Mi"
        cpu: "500m"

  producer:
    image: "ghcr.io/your-org/AKTT1-Group1-K8S/producer:latest"
    schedule: "*/5 * * * *" # Every 5 minutes
    resources:
      requests:
        memory: "128Mi"
        cpu: "100m"
      limits:
        memory: "256Mi"
        cpu: "200m"

github:
  oauth:
    clientId: "your-github-oauth-client-id"
    clientSecret: "your-github-oauth-client-secret"
    organization: "your-github-organization"
```

### 3. Create Kubernetes Manifests

Create the necessary Kubernetes manifests in the application repository:

```yaml
# applications/tenants/mcce-g1/frontend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: mcce-g1-prod
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: frontend
          image: ghcr.io/your-org/AKTT1-Group1-K8S/frontend:latest
          ports:
            - containerPort: 3000
          env:
            - name: REACT_APP_API_URL
              value: "http://api.mcce-g1-prod.svc.cluster.local:8080"
            - name: REACT_APP_GITHUB_CLIENT_ID
              valueFrom:
                secretKeyRef:
                  name: mcce-g1-secrets
                  key: github-oauth-client-id
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: mcce-g1-prod
spec:
  selector:
    app: frontend
  ports:
    - port: 80
      targetPort: 3000
```

## Deployment Process

### 1. Deploy Infrastructure

```bash
# In the infrastructure repository
cd infrastructure
tofu init
tofu plan
tofu apply
```

### 2. Deploy Applications

The applications will be automatically deployed by ArgoCD when you push to the application repository:

```bash
# In the application repository
git add .
git commit -m "Add tenant configuration"
git push origin main
```

### 3. Monitor Deployment

```bash
# Check ArgoCD applications
kubectl get applications -n argocd

# Check tenant pods
kubectl get pods -n mcce-g1-prod
kubectl get pods -n mcce-g1-test
```

## Application Development Workflow

### 1. Development

1. Make changes to application code
2. Test locally with Docker
3. Commit and push to trigger CI/CD

### 2. Testing

1. Changes are automatically built and pushed to GHCR
2. ArgoCD detects new images and deploys to test environment
3. Verify functionality in test environment

### 3. Production Deployment

1. Create a release tag
2. ArgoCD deploys the tagged version to production
3. Monitor production deployment

## Environment Variables

### Frontend Service

```bash
REACT_APP_API_URL=http://api.mcce-g1-prod.svc.cluster.local:8080
REACT_APP_GITHUB_CLIENT_ID=your-github-oauth-client-id
REACT_APP_GITHUB_ORG=your-github-organization
```

### API Service

```bash
DATABASE_URL=postgresql://user:pass@host:port/db
GITHUB_CLIENT_ID=your-github-oauth-client-id
GITHUB_CLIENT_SECRET=your-github-oauth-client-secret
GITHUB_ORG=your-github-organization
PORT=8080
```

### Producer Service

```bash
DATABASE_URL=postgresql://user:pass@host:port/db
GITHUB_CLIENT_ID=your-github-oauth-client-id
GITHUB_CLIENT_SECRET=your-github-oauth-client-secret
API_URL=http://api.mcce-g1-prod.svc.cluster.local:8080
```

## Troubleshooting

### Common Issues

1. **Container Build Failures**

   - Check Dockerfile syntax
   - Verify dependencies in package.json/requirements.txt
   - Check GitHub Actions logs

2. **Deployment Failures**

   - Check ArgoCD application status
   - Verify image tags and availability
   - Check resource limits and requests

3. **OAuth Authentication Issues**
   - Verify GitHub OAuth app configuration
   - Check callback URLs
   - Validate organization membership

### Debug Commands

```bash
# Check application logs
kubectl logs -n mcce-g1-prod deployment/frontend
kubectl logs -n mcce-g1-prod deployment/api
kubectl logs -n mcce-g1-prod cronjob/producer

# Check ArgoCD sync status
kubectl get applications -n argocd -o wide

# Check ingress configuration
kubectl get ingress -A
kubectl describe ingress -n mcce-g1-prod
```

## Security Considerations

1. **Secrets Management**

   - Store sensitive data in Kubernetes secrets
   - Use external secret management for production
   - Rotate secrets regularly

2. **Network Security**

   - Use network policies for pod communication
   - Implement TLS for all external communication
   - Monitor network traffic

3. **Access Control**
   - Use RBAC for Kubernetes access
   - Implement OAuth scopes for application access
   - Audit access logs regularly
