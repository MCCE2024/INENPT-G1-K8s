# INENPT-G1-K8s - Multi-Tenant Kubernetes Application

## Project Overview

This project implements a multi-tenant Kubernetes application with GitHub OAuth authentication, deployed on Exoscale Cloud using OpenTofu for infrastructure as code.

### Architecture Components

- **Frontend Service**: Node.js application (React/Angular) for displaying user data
- **API Service**: REST API service that handles authentication and database access
- **Producer Service**: Python CronJob that writes data via the API
- **Database**: Exoscale Managed PostgreSQL with tenant isolation
- **Authentication**: GitHub OAuth instead of Keycloak
- **Infrastructure**: OpenTofu for provisioning Exoscale resources
- **GitOps**: ArgoCD for continuous deployment
- **CI/CD**: GitHub Actions with Container Registry

### Key Features

- Multi-tenant architecture with namespace isolation
- GitHub OAuth authentication
- GitOps-driven deployment with ArgoCD
- Infrastructure as Code with OpenTofu
- Zero-trust network policies
- Automated tenant onboarding process

## Project Structure

```
├── infrastructure/          # OpenTofu configuration
├── applications/           # Application manifests
├── helm-charts/           # Helm charts for services
├── ci-cd/                 # GitHub Actions workflows
├── docs/                  # Documentation
└── scripts/               # Utility scripts
```

## Quick Start

1. **Prerequisites**

   - OpenTofu installed
   - kubectl configured
   - Exoscale CLI configured
   - GitHub OAuth App created

2. **Deploy Infrastructure**

   ```bash
   cd infrastructure
   tofu init
   tofu plan
   tofu apply
   ```

3. **Deploy Applications**

   ```bash
   kubectl apply -f applications/
   ```

4. **Configure ArgoCD**
   ```bash
   kubectl apply -f applications/argocd/
   ```

## Documentation

- [Architecture Overview](docs/architecture.md)
- [Tenant Onboarding](docs/tenant-onboarding.md)
- [Security Configuration](docs/security.md)
- [API Documentation](docs/api.md)
