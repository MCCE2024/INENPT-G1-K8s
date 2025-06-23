# Architecture Overview

## System Architecture

This project implements a multi-tenant Kubernetes application with GitHub OAuth authentication, deployed on Exoscale Cloud using OpenTofu for infrastructure as code.

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Exoscale Cloud                          │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │   SKS Cluster   │  │   PostgreSQL    │  │   Container     │ │
│  │   (Kubernetes)  │  │   (Managed)     │  │   Registry      │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Kubernetes Cluster Structure

```
SKS Cluster
├── argocd (Namespace)
│   ├── ArgoCD Server
│   ├── ArgoCD Application Controller
│   └── ArgoCD Repo Server
├── core (Namespace)
│   ├── NGINX Ingress Controller
│   └── Network Policies
├── mcce-g1-prod (Namespace)
│   ├── Frontend Service (Node.js)
│   ├── API Service
│   └── Producer CronJob (Python)
└── mcce-g1-test (Namespace)
    ├── Frontend Service (Node.js)
    ├── API Service
    └── Producer CronJob (Python)
```

## Components

### 1. Infrastructure Layer

#### Exoscale SKS Cluster

- **Purpose**: Managed Kubernetes cluster for application deployment
- **Version**: Kubernetes 1.28
- **CNI**: Calico for network policies
- **Node Pool**: 3 nodes with standard.medium instance type
- **Addons**: Exoscale Cloud Controller, Metrics Server

#### Exoscale PostgreSQL

- **Purpose**: Centralized multi-tenant database
- **Version**: PostgreSQL 15
- **Plan**: startup-4
- **Tenant Isolation**: Logical separation via tenant_id in JSON data

#### Networking

- **Private Network**: 10.0.0.0/16 for SKS and PostgreSQL
- **Security Groups**: Configured for SKS cluster access
- **Network Policies**: Zero-trust communication between namespaces

### 2. Application Layer

#### Frontend Service

- **Technology**: Node.js with React/Angular
- **Purpose**: User interface for displaying data
- **Authentication**: GitHub OAuth integration
- **Deployment**: Separate container per tenant namespace

#### API Service

- **Technology**: Node.js/Python REST API
- **Purpose**: Central API for data access and authentication
- **Features**:
  - GitHub OAuth token validation
  - Database access control
  - Multi-tenant data isolation
- **Security**: Only service with direct database access

#### Producer Service

- **Technology**: Python CronJob
- **Purpose**: Generates and sends time data
- **Authentication**: Uses GitHub OAuth tokens
- **Schedule**: Configurable cron schedule per tenant

### 3. GitOps Layer

#### ArgoCD

- **Purpose**: Continuous deployment and GitOps controller
- **Authentication**: GitHub OAuth integration
- **Applications**:
  - Core Infrastructure
  - Tenant Management
- **Repository**: Separate application repository

#### Application Repository Structure

```
applications/
├── core/
│   ├── namespace.yaml
│   ├── ingress-controller.yaml
│   ├── network-policies.yaml
│   └── kustomization.yaml
└── tenants/
    ├── namespace.yaml
    └── kustomization.yaml
```

### 4. CI/CD Pipeline

#### GitHub Actions

- **Infrastructure Pipeline**: OpenTofu deployment
- **Application Pipeline**: Container builds and pushes
- **Security**: Automated security scanning
- **Registry**: GitHub Container Registry (GHCR)

## Authentication Flow

### GitHub OAuth Integration

1. **User Authentication**:

   ```
   User → Frontend → GitHub OAuth → Access Token
   ```

2. **API Access**:

   ```
   Frontend/Producer → API Service → GitHub Token Validation → Database Access
   ```

3. **Token Validation**:
   - API Service validates GitHub tokens
   - Extracts user information and organization membership
   - Enforces tenant access control

### Multi-Tenant Security

- **Namespace Isolation**: Each tenant has separate prod/test namespaces
- **Network Policies**: Zero-trust communication between components
- **Database Isolation**: Logical separation via tenant_id
- **OAuth Scopes**: Organization-based access control

## Data Flow

### Production Data Flow

```
Producer (CronJob) → API Service → PostgreSQL (tenant_id: prod)
Frontend → API Service → PostgreSQL (tenant_id: prod)
```

### Test Data Flow

```
Producer (CronJob) → API Service → PostgreSQL (tenant_id: test)
Frontend → API Service → PostgreSQL (tenant_id: test)
```

## Tenant Onboarding Process

1. **Repository Setup**: Create tenant-specific Helm values
2. **ArgoCD Application**: Deploy tenant namespaces and services
3. **GitHub OAuth**: Configure organization access
4. **Database Schema**: Initialize tenant data structures
5. **Network Policies**: Configure tenant-specific policies

## Security Considerations

- **Zero-Trust Networking**: All communication explicitly allowed
- **OAuth Token Validation**: Every API request validated
- **Namespace Isolation**: Complete tenant separation
- **Secret Management**: Kubernetes secrets for sensitive data
- **Network Policies**: Pod-to-pod communication control
- **TLS Termination**: Ingress controller handles SSL/TLS

## Monitoring and Observability

- **Metrics Server**: Kubernetes metrics collection
- **ArgoCD Dashboard**: Application deployment monitoring
- **Logging**: Centralized logging via Kubernetes
- **Health Checks**: Application health monitoring

## Scalability

- **Horizontal Scaling**: Multiple replicas per service
- **Load Balancing**: NGINX ingress controller
- **Auto-scaling**: Kubernetes HPA support
- **Multi-tenant**: Easy addition of new tenants
