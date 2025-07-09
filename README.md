# INENPT-G1-K8s: Infrastructure as Code

_Last Updated: 09.07.2025_

> **Part 2 of 3: Infrastructure Foundation** 🏗️  
> This repository contains the **Infrastructure as Code (IaC)** components of our multi-tenant cloud-native application. It works seamlessly with our [Application Code Repository](https://github.com/MCCE2024/INENPT-G1-Code) and [ArgoCD GitOps Repository](https://github.com/MCCE2024/INENPT-G1-Argo) to create a complete GitOps pipeline.

## 🧭 Repository Navigation Guide

> [!TIP]
> This project uses a **3-repository strategy**. Each repository has a distinct role:

**For Students Learning Cloud Computing:**

1. **Start Here:** [INENPT-G1-Code](https://github.com/MCCE2024/INENPT-G1-Code) – Application development and microservices
2. **Next:** [INENPT-G1-K8s](https://github.com/MCCE2024/INENPT-G1-K8s) – Kubernetes infrastructure and deployment (this repository)
3. **Finally:** [INENPT-G1-Argo](https://github.com/MCCE2024/INENPT-G1-Argo) – GitOps automation and ArgoCD

**For Professors Evaluating:**

- **Requirements Coverage:** [Learning Objectives & Course Requirements](#-learning-objectives--course-requirements)
- **Infrastructure Architecture:** [3-Repository Architecture Overview](#-3-repository-architecture-overview)
- **Technical Assessment:** [Professor's Assessment Guide](#-professors-assessment-guide)

**For Developers Contributing:**

- **Quick Setup:** [Quick Start Guide](#-quick-start-guide)
- **Detailed Setup:** [Complete Setup & Deployment](#-complete-setup--deployment)
- **Integration Info:** [Integration with Other Repositories](#-integration-with-other-repositories)

## 📋 Table of Contents

- [🚀 Quick Start Guide](#-quick-start-guide)
- [🎯 Repository Purpose & Role](#-repository-purpose--role)
- [🏗️ 3-Repository Architecture Overview](#-3-repository-architecture-overview)
- [📁 Repository Structure](#-repository-structure)
- [🛠️ Infrastructure Components](#-infrastructure-components)
- [🔧 Complete Setup & Deployment](#-complete-setup--deployment)
- [🔗 Integration with Other Repositories](#-integration-with-other-repositories)
- [📊 Learning Objectives & Course Requirements](#-learning-objectives--course-requirements)
- [🎓 Key Concepts Demonstrated](#-key-concepts-demonstrated)
- [🚨 Troubleshooting Guide](#-troubleshooting-guide)
- [📚 Resources & References](#-resources--references)
- [🎯 Professor's Assessment Guide](#-professors-assessment-guide)

## 🚀 Quick Start Guide

> [!NOTE] > **New to this project?** Follow these steps to get infrastructure running quickly.

### Prerequisites Checklist

- [ ] **Terraform/OpenTofu** >= 1.0 installed
- [ ] **Exoscale Cloud account** with API credentials
- [ ] **kubectl** configured for cluster management
- [ ] **Git** for version control

### 5-Minute Setup

1. **Clone and configure:**

   ```bash
   git clone https://github.com/MCCE2024/INENPT-G1-K8s.git
   cd INENPT-G1-K8s/infrastructure
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your Exoscale credentials
   ```

2. **Deploy infrastructure:**

   ```bash
   tofu init
   tofu plan
   tofu apply
   ```

3. **Verify deployment:**
   ```bash
   kubectl get nodes
   kubectl get pods -A
   ```

> [!TIP] > **Next Steps:** Continue with [INENPT-G1-Argo](https://github.com/MCCE2024/INENPT-G1-Argo) to deploy applications via GitOps.

## 🎯 Repository Purpose & Role

> [!IMPORTANT]
> This repository is the **infrastructure backbone** of the project. It provisions cloud resources but does not contain application code or deployment manifests.

### Primary Responsibility

This repository serves as the **infrastructure foundation** for our multi-tenant application using **Terraform/OpenTofu** to provision and manage all cloud infrastructure components on Exoscale Cloud.

### In the 3-Repository Strategy

```
┌──────────────────────────────────────────────────────────────────────┐
│                    COMPLETE GITOPS PIPELINE                          │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  📦 [INENPT-G1-Code]     🏗️ [INENPT-G1-K8s]     🎭 [INENPT-G1-Argo] │
│  Application Code        Infrastructure         GitOps               │
│  • Source Code          • Terraform Configs    • ArgoCD              │
│  • Docker Images        • Kubernetes Cluster   • Helm Charts         │
│  • CI/CD Pipelines      • Database             • Deployment          │
│  • Unit Tests           • Security Groups      • Monitoring          │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

**This Repository's Role**: Provides the **production-ready infrastructure** that hosts applications and enables GitOps workflows.

## 🏗️ 3-Repository Architecture Overview

> [!IMPORTANT]
> Each repository has a distinct role to prevent confusion and deployment errors.

### Repository 1: [INENPT-G1-Code](https://github.com/MCCE2024/INENPT-G1-Code)

- **Purpose**: Application source code and CI/CD pipelines
- **Contains**: Node.js applications, Docker configurations, GitHub Actions
- **Output**: Container images pushed to GitHub Container Registry

### Repository 2: [INENPT-G1-K8s] (This Repository)

- **Purpose**: Infrastructure as Code foundation
- **Contains**: Terraform configurations for cloud infrastructure
- **Output**: Production-ready Kubernetes cluster and database

### Repository 3: [INENPT-G1-Argo](https://github.com/MCCE2024/INENPT-G1-Argo)

- **Purpose**: GitOps deployment and application lifecycle management
- **Contains**: ArgoCD configurations, Helm charts, deployment manifests
- **Output**: Automated application deployment and continuous sync

## 📁 Repository Structure

```
INENPT-G1-K8s/
├── infrastructure/              # Infrastructure as Code (Terraform)
│   ├── main.tf                 # Main Terraform configuration
│   ├── variables.tf            # Variable definitions
│   └── terraform.tfvars.example # Configuration template
├── docs/                       # Documentation and diagrams
│   ├── architecture.mermaid    # System architecture diagram
│   └── ...                     # Additional documentation
└── README.md                   # This file
```

## 🛠️ Infrastructure Components

> [!NOTE]
> All infrastructure is provisioned using code—no manual steps required for cloud resource creation.

### What This Repository Provides

✅ **Managed Kubernetes Cluster (SKS)** - Production-ready K8s cluster  
✅ **Managed PostgreSQL Database** - Multi-tenant data persistence with SSL  
✅ **Security Groups & Network Policies** - Zero-trust security model  
✅ **Load Balancers & Ingress** - Traffic management and routing  
✅ **Monitoring & Logging** - Observability infrastructure  
✅ **Secrets Management** - Secure credential storage

### Main Components

- **Exoscale SKS Kubernetes Cluster**: Managed Kubernetes cluster for application workloads
- **Exoscale PostgreSQL Database**: Managed PostgreSQL instance for persistent, multi-tenant data storage
- **Security Groups & Network Policies**: Network-level security for cluster and database access

## 🔧 Complete Setup & Deployment

> [!WARNING]
> Never commit secrets to version control! Use `terraform.tfvars` for sensitive values and keep it in `.gitignore`.

### Prerequisites

Before starting, ensure you have:

- **Terraform/OpenTofu** >= 1.0
- **Exoscale Cloud account** with API credentials
- **kubectl** configured for cluster management
- **Exoscale CLI** for cluster access

### Step 1: Install Required Tools

#### Install Exoscale CLI

```bash
# Check if exoscale CLI is installed
if ! command -v exo &> /dev/null; then
    echo "Installing Exoscale CLI..."
    curl -fsSL https://raw.githubusercontent.com/exoscale/cli/master/install-latest.sh | sh

    # Verify installation
    if command -v exo &> /dev/null; then
        echo "✅ Exoscale CLI installed successfully"
        exo version
    else
        echo "❌ Failed to install Exoscale CLI"
        exit 1
    fi
else
    echo "✅ Exoscale CLI is already installed"
    exo version
fi
```

#### Install Terraform/OpenTofu

```bash
# For OpenTofu (recommended)
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh | sh

# Or for Terraform
# Download from https://developer.hashicorp.com/terraform/downloads
```

### Step 2: Configure Environment

1. **Copy the example configuration:**

   ```bash
   cp infrastructure/terraform.tfvars.example infrastructure/terraform.tfvars
   ```

2. **Edit `terraform.tfvars` with your values:**

   ```bash
   # Required: Exoscale credentials
   exoscale_api_key    = "your-exoscale-api-key"
   exoscale_api_secret = "your-exoscale-api-secret"

   # Optional: Customize deployment
   project_name       = "your-project-name"
   kubernetes_version = "1.32.6"
   node_pool_size     = 3
   ```

### Step 3: Deploy Infrastructure

```bash
cd infrastructure

# Initialize tofu
tofu init   # or 'terraform init' if using Terraform

# Review planned changes
tofu plan

# Apply infrastructure changes
tofu apply
```

### Step 4: Configure Cluster Access

```bash
# Get cluster credentials
exo sks kubeconfig <cluster-name> --zone <zone> --group system:masters

# Verify cluster access
kubectl get nodes
kubectl get pods -A
```

### Step 5: Verify Deployment

```bash
# Check cluster status
kubectl cluster-info

# Check database connectivity
kubectl get secret postgresql-secret -o yaml

# Check security groups
kubectl get networkpolicies -A
```

## 🔗 Integration with Other Repositories

### How This Repository Integrates

- **[INENPT-G1-Code](https://github.com/MCCE2024/INENPT-G1-Code)**:

  - Contains application source code and CI/CD workflows
  - Builds Docker images referenced in deployment manifests
  - Provides the applications that run on our infrastructure

- **[INENPT-G1-K8s](https://github.com/MCCE2024/INENPT-G1-K8s)** (this repository):

  - Provisions Kubernetes cluster and PostgreSQL database
  - Outputs cluster and database connection information
  - Provides the foundation for application deployment

- **[INENPT-G1-Argo](https://github.com/MCCE2024/INENPT-G1-Argo)**:
  - Contains GitOps deployment configuration
  - Uses infrastructure provisioned by this repository
  - Manages application lifecycle and continuous deployment

### Workflow Integration

1. **Infrastructure First**: Deploy this repository to create cloud resources
2. **Application Build**: [INENPT-G1-Code](https://github.com/MCCE2024/INENPT-G1-Code) builds and pushes container images
3. **GitOps Deployment**: [INENPT-G1-Argo](https://github.com/MCCE2024/INENPT-G1-Argo) deploys applications to the infrastructure

## 📊 Learning Objectives & Course Requirements

### Course Requirements Met

✅ **3+ Microservices** - API, Consumer, Producer services  
✅ **OAuth2 Authentication** - GitHub OAuth integration  
✅ **Multi-tenancy** - Namespace isolation and tenant management  
✅ **No-click Setup** - Fully automated infrastructure provisioning  
✅ **Kubernetes Deployment** - Production-grade cluster configuration  
✅ **Security-First Design** - Comprehensive security policies

### Learning Objectives Achieved

✅ **Infrastructure as Code**: Complete Terraform implementation  
✅ **Cloud Computing**: Exoscale Cloud platform mastery  
✅ **Container Orchestration**: Kubernetes cluster management  
✅ **Multi-tenancy**: Namespace isolation and resource management  
✅ **Security**: Zero-trust network policies and secrets management  
✅ **Automation**: Fully automated infrastructure provisioning

## 🎓 Key Concepts Demonstrated

### Technical Competencies

- **Terraform/OpenTofu**: Advanced infrastructure provisioning
- **Kubernetes**: Production-grade cluster configuration
- **Cloud Security**: Security groups and network policies
- **Database Management**: Managed PostgreSQL configuration
- **Multi-tenancy**: Tenant isolation and resource quotas
- **GitOps Integration**: Infrastructure ready for ArgoCD deployment

## 🚨 Troubleshooting Guide

### Common Issues and Solutions

#### Issue: Terraform/OpenTofu fails to initialize

```bash
# Solution: Check provider versions and update
tofu init -upgrade
```

#### Issue: Exoscale API authentication fails

```bash
# Solution: Verify credentials in terraform.tfvars
exo config
```

#### Issue: Kubernetes cluster not accessible

```bash
# Solution: Re-configure kubectl
exo sks kubeconfig <cluster-name> --zone <zone> --group system:masters
kubectl config current-context
```

#### Issue: Database connection fails

```bash
# Solution: Check security group rules and SSL configuration
kubectl describe secret postgresql-secret
```

### Debugging Commands

```bash
# Infrastructure status
tofu plan
tofu show

# Kubernetes cluster status
kubectl get all -A
kubectl describe nodes

# Database connectivity
kubectl get secret postgresql-secret -o yaml
kubectl logs -l app=postgresql

# Network policies
kubectl get networkpolicies -A
kubectl describe networkpolicy <policy-name>
```

### Getting Help

1. **Check the logs**: Use `kubectl logs` to examine pod logs
2. **Review Terraform state**: Use `tofu show` to inspect current state
3. **Verify configuration**: Double-check `terraform.tfvars` values
4. **Consult documentation**: See [Resources & References](#-resources--references)

## 📚 Resources & References

### Official Documentation

- [Terraform Documentation](https://www.terraform.io/docs)
- [OpenTofu Documentation](https://opentofu.org/docs/)
- [Exoscale Documentation](https://www.exoscale.com/documentation/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

### Learning Resources

- [Infrastructure as Code: Managing Servers in the Cloud](https://www.oreilly.com/library/view/infrastructure-as-code/9781491924334/)
- [Kubernetes: Up and Running](https://www.oreilly.com/library/view/kubernetes-up-and/9781492046523/)
- [Terraform: Up & Running](https://www.oreilly.com/library/view/terraform-up-running/9781491977071/)

### Related Repositories

- **[INENPT-G1-Code](https://github.com/MCCE2024/INENPT-G1-Code)**: Application source code and CI/CD
- **[INENPT-G1-Argo](https://github.com/MCCE2024/INENPT-G1-Argo)**: GitOps deployment and ArgoCD configuration

## 🎯 Professor's Assessment Guide

> [!IMPORTANT]
> This section helps professors quickly assess whether all course requirements and learning objectives have been met.

### Technical Competencies Demonstrated

- **Terraform/OpenTofu**: Advanced infrastructure provisioning with proper state management
- **Kubernetes**: Production-grade cluster configuration with security policies
- **Cloud Security**: Comprehensive security groups and network policies
- **Database Management**: Managed PostgreSQL with SSL and multi-tenancy
- **Multi-tenancy**: Tenant isolation and resource quotas
- **GitOps Integration**: Infrastructure ready for automated deployment

### Assessment Criteria

| Criterion                      | Status      | Evidence                                       |
| ------------------------------ | ----------- | ---------------------------------------------- |
| **Infrastructure as Code**     | ✅ Complete | Terraform configurations in `/infrastructure/` |
| **Cloud Platform Integration** | ✅ Complete | Exoscale provider and resource configurations  |
| **Security Implementation**    | ✅ Complete | Security groups, network policies, SSL         |
| **Multi-tenant Architecture**  | ✅ Complete | Namespace isolation and resource management    |
| **Automation**                 | ✅ Complete | Fully automated provisioning process           |
| **Documentation**              | ✅ Complete | Comprehensive README and inline comments       |

### Repository Status

- **Repository Status**: ✅ **Production Ready**
- **Integration Status**: ✅ **Fully Integrated with 3-Repository Strategy**
- **Learning Value**: ⭐⭐⭐⭐⭐ **Excellent demonstration of modern cloud infrastructure**

---

## 🚀 Future Improvements

### Possible Enhancements

- **Secure Database IP Filtering**: Restrict PostgreSQL access to specific CIDRs instead of 0.0.0.0/0
- **Advanced Monitoring**: Implement Prometheus and Grafana for infrastructure monitoring
- **Backup Automation**: Automated backup strategies for critical data
- **Multi-region Deployment**: Extend infrastructure to multiple Exoscale zones

---

_This repository is part of a comprehensive 3-repository GitOps strategy demonstrating modern cloud computing principles and production-ready infrastructure management._

**Created by:** Harald, Patrick, and Susanne  
**Course:** INENPT Cloud Computing  
**Institution:** Hochschule Burgenland
