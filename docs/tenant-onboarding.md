# Tenant Onboarding Process

## Overview

This document describes the automated GitOps process for onboarding new tenants into the multi-tenant Kubernetes application.

## Prerequisites

1. **GitHub Organization**: Tenant must have a GitHub organization
2. **GitHub OAuth App**: OAuth application configured for the tenant
3. **Application Repository**: Access to the application repository
4. **ArgoCD Access**: Access to ArgoCD for deployment management

## Step-by-Step Onboarding Process

### 1. GitHub OAuth App Registration

#### Create GitHub OAuth App

1. Go to GitHub Organization Settings → Developer settings → OAuth Apps
2. Click "New OAuth App"
3. Configure the application:
   ```
   Application name: [Tenant Name] - Multi-Tenant App
   Homepage URL: https://[tenant].yourdomain.com
   Authorization callback URL: https://[tenant].yourdomain.com/auth/callback
   ```
4. Note the Client ID and Client Secret

#### Configure OAuth Scopes

- `read:org` - Read organization membership
- `read:user` - Read user profile
- `user:email` - Read user email addresses

### 2. Tenant Repository Setup

#### Create Tenant Configuration

In the application repository, create tenant-specific configuration:

```yaml
# applications/tenants/[tenant-name]/values.yaml
tenant:
  name: "mcce-g1"
  environments:
    - name: "prod"
      namespace: "mcce-g1-prod"
      domain: "prod.mcce-g1.yourdomain.com"
    - name: "test"
      namespace: "mcce-g1-test"
      domain: "test.mcce-g1.yourdomain.com"

github:
  oauth:
    clientId: "your-github-oauth-client-id"
    clientSecret: "your-github-oauth-client-secret"
    organization: "your-github-org"

services:
  frontend:
    image: "ghcr.io/your-org/frontend:latest"
    replicas: 2
  api:
    image: "ghcr.io/your-org/api:latest"
    replicas: 2
  producer:
    image: "ghcr.io/your-org/producer:latest"
    schedule: "*/5 * * * *" # Every 5 minutes
```

### 3. ArgoCD Application Creation

#### Create ArgoCD Application Manifest

```yaml
# applications/tenants/[tenant-name]/argocd-application.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: [tenant-name]-applications
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/your-org/application-repo
    targetRevision: main
    path: applications/tenants/[tenant-name]
  destination:
    server: https://kubernetes.default.svc
    namespace: tenant-management
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

### 4. Database Schema Initialization

#### Create Tenant Database Schema

```sql
-- Initialize tenant schema
CREATE SCHEMA IF NOT EXISTS tenant_[tenant_id];

-- Create messages table for the tenant
CREATE TABLE IF NOT EXISTS tenant_[tenant_id].messages (
    id SERIAL PRIMARY KEY,
    tenant_id VARCHAR(50) NOT NULL,
    environment VARCHAR(20) NOT NULL,
    message_data JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_tenant_[tenant_id]_messages_tenant_id ON tenant_[tenant_id].messages(tenant_id);
CREATE INDEX idx_tenant_[tenant_id]_messages_environment ON tenant_[tenant_id].messages(environment);
CREATE INDEX idx_tenant_[tenant_id]_messages_created_at ON tenant_[tenant_id].messages(created_at);
```

### 5. Network Policy Configuration

#### Create Tenant-Specific Network Policies

```yaml
# applications/tenants/[tenant-name]/network-policies.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: [tenant-name]-prod-network-policy
  namespace: [tenant-name]-prod
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: ingress-nginx
    ports:
    - protocol: TCP
      port: 80
    - protocol: TCP
      port: 443
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          name: core
    ports:
    - protocol: TCP
      port: 5432  # PostgreSQL
```

### 6. Secret Management

#### Create Kubernetes Secrets

```yaml
# applications/tenants/[tenant-name]/secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: [tenant-name]-secrets
  namespace: [tenant-name]-prod
type: Opaque
data:
  github-oauth-client-id: [base64-encoded-client-id]
  github-oauth-client-secret: [base64-encoded-client-secret]
  database-url: [base64-encoded-database-url]
---
apiVersion: v1
kind: Secret
metadata:
  name: [tenant-name]-secrets
  namespace: [tenant-name]-test
type: Opaque
data:
  github-oauth-client-id: [base64-encoded-client-id]
  github-oauth-client-secret: [base64-encoded-client-secret]
  database-url: [base64-encoded-database-url]
```

## Automated Deployment Process

### 1. Git Commit and Push

```bash
# Add tenant configuration
git add applications/tenants/[tenant-name]/
git commit -m "Add tenant [tenant-name] configuration"
git push origin main
```

### 2. ArgoCD Sync

- ArgoCD detects the new tenant configuration
- Automatically creates the tenant namespaces
- Deploys all tenant services
- Configures network policies

### 3. Service Verification

```bash
# Check tenant deployment status
kubectl get pods -n [tenant-name]-prod
kubectl get pods -n [tenant-name]-test

# Verify ArgoCD application status
kubectl get applications -n argocd
```

## Tenant Management Commands

### Check Tenant Status

```bash
# List all tenant namespaces
kubectl get namespaces -l purpose=tenant-production
kubectl get namespaces -l purpose=tenant-test

# Check tenant services
kubectl get all -n [tenant-name]-prod
kubectl get all -n [tenant-name]-test
```

### Update Tenant Configuration

```bash
# Update tenant values
git checkout -b update-[tenant-name]
# Edit tenant configuration files
git add .
git commit -m "Update [tenant-name] configuration"
git push origin update-[tenant-name]
# Create pull request for review
```

### Remove Tenant

```bash
# Delete tenant ArgoCD application
kubectl delete application [tenant-name]-applications -n argocd

# Delete tenant namespaces
kubectl delete namespace [tenant-name]-prod
kubectl delete namespace [tenant-name]-test

# Remove tenant configuration from repository
git rm -r applications/tenants/[tenant-name]/
git commit -m "Remove tenant [tenant-name]"
git push origin main
```

## Troubleshooting

### Common Issues

1. **OAuth Authentication Failures**

   - Verify GitHub OAuth app configuration
   - Check organization membership
   - Validate callback URLs

2. **Database Connection Issues**

   - Verify database credentials
   - Check network policies
   - Validate database schema

3. **Service Deployment Failures**
   - Check ArgoCD application status
   - Verify container image availability
   - Review resource limits and requests

### Debug Commands

```bash
# Check ArgoCD logs
kubectl logs -n argocd deployment/argocd-server

# Check tenant service logs
kubectl logs -n [tenant-name]-prod deployment/[service-name]

# Verify network policies
kubectl get networkpolicies -n [tenant-name]-prod

# Check ingress configuration
kubectl get ingress -n [tenant-name]-prod
```

## Security Considerations

1. **OAuth Token Security**

   - Store tokens securely in Kubernetes secrets
   - Rotate tokens regularly
   - Use minimal required scopes

2. **Network Isolation**

   - Enforce namespace isolation
   - Use network policies for pod communication
   - Monitor network traffic

3. **Access Control**
   - Implement RBAC for tenant access
   - Use service accounts for service communication
   - Audit access logs regularly
