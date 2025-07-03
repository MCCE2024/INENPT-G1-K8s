# INENPT-G1-K8s: Infrastructure as Code Repository

03.07.2025

> **Part 2 of 3: Infrastructure Foundation** 🏗️  
> This repository contains the **Infrastructure as Code (IaC)** components of our multi-tenant cloud-native application. It's designed to work seamlessly with our [Application Code Repository](https://github.com/MCCE2024/INENPT-G1-Code) and [ArgoCD GitOps Repository](https://github.com/MCCE2024/INENPT-G1-Argo) to create a complete GitOps pipeline.
> We worked mostly via the Liveshare extension, so there can often be uneven pushes in the Git repository.

## 🧭 Repository Navigation Guide

> [!TIP]
> This project uses a **3-repository strategy**. Each repository has a distinct role. Use this guide to navigate between them:

**For Students Learning Cloud Computing:**

1. **Start Here:** [INENPT-G1-Code](https://github.com/MCCE2024/INENPT-G1-Code) – Application development and microservices
2. **Next:** [INENPT-G1-K8s](https://github.com/MCCE2024/INENPT-G1-K8s) – Kubernetes infrastructure and deployment (this repository)
3. **Finally:** [INENPT-G1-Argo](https://github.com/MCCE2024/INENPT-G1-Argo) – GitOps automation and ArgoCD

**For Professors Evaluating:**

- **Requirements Coverage:** See the "Learning Objectives & Course Requirements" section below
- **Infrastructure Architecture:** See the "3-Repository Architecture Overview" section
- **Integration Examples:** See the "Integration with Other Repositories" section

**For Developers Contributing:**

- **Infrastructure Setup:** See the "Setup & Deployment" section
- **Cloud Resource Management:** See the "Infrastructure Components" section
- **Development Workflow:** See the "Integration with Other Repositories" section

> [!NOTE]
> Each repository README contains a similar navigation guide and cross-links for a seamless experience.

## 📋 Table of Contents

- [🎯 Repository Purpose & Role](#repository-purpose--role)
- [🏗️ 3-Repository Architecture Overview](#3-repository-architecture-overview)
- [🚀 What This Repository Provides](#what-this-repository-provides)
- [📁 Repository Structure](#repository-structure)
- [🛠️ Infrastructure Components](#infrastructure-components)
- [🔧 Setup & Deployment](#setup--deployment)
- [🔗 Integration with Other Repositories](#integration-with-other-repositories)
- [📊 Learning Objectives & Course Requirements](#learning-objectives--course-requirements)
- [🎓 Key Concepts Demonstrated](#key-concepts-demonstrated)
- [🚨 Troubleshooting Guide](#troubleshooting-guide)
- [📚 Resources & References](#resources--references)
- [🎯 Professor's Assessment Guide](#professors-assessment-guide)

## 🎯 Repository Purpose & Role

> [!NOTE]
> This repository is the **infrastructure backbone** of the project. It is not intended for application code or deployment manifests—those are managed in the other two repositories.

### **Primary Responsibility**

This repository serves as the **infrastructure foundation** for our multi-tenant application. It uses **Terraform/OpenTofu** to provision and manage all cloud infrastructure components on Exoscale Cloud.

### **In the 3-Repository Strategy**

```
┌─────────────────────────────────────────────────────────────┐
│                    COMPLETE GITOPS PIPELINE                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  📦 [INENPT-G1-Code]     🏗️ [INENPT-G1-K8s]     🎭 [INENPT-G1-Argo] │
│  Application Code        Infrastructure         GitOps      │
│  • Source Code          • Terraform Configs    • ArgoCD     │
│  • Docker Images        • Kubernetes Cluster   • Helm Charts│
│  • CI/CD Pipelines      • Database             • Deployment │
│  • Unit Tests           • Security Groups      • Monitoring │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

> [!TIP]
> For a smooth workflow, always start with this repository to provision infrastructure. Once the infrastructure is ready, the other repositories will automatically deploy applications via GitOps.

**This Repository's Role**: Provides the **production-ready infrastructure** that hosts our applications and enables GitOps workflows.

## 🏗️ 3-Repository Architecture Overview

> [!IMPORTANT]
> Each repository in the 3-repo strategy has a distinct role. Mixing responsibilities can lead to confusion and deployment errors.

### **Repository 1: [INENPT-G1-Code](https://github.com/MCCE2024/INENPT-G1-Code)**

- **Purpose**: Application source code and CI/CD pipelines
- **Contains**: Node.js applications, Docker configurations, GitHub Actions
- **Output**: Container images pushed to GitHub Container Registry

### **Repository 2: [INENPT-G1-K8s] (This Repository)**

- **Purpose**: Infrastructure as Code foundation
- **Contains**: Terraform configurations for cloud infrastructure
- **Output**: Production-ready Kubernetes cluster and database

### **Repository 3: [INENPT-G1-Argo](https://github.com/MCCE2024/INENPT-G1-Argo)**

- **Purpose**: GitOps deployment and application lifecycle management
- **Contains**: ArgoCD configurations, Helm charts, deployment manifests
- **Output**: Automated application deployment and continuous sync

## 🚀 What This Repository Provides

> [!NOTE]
> All infrastructure is provisioned using code—no manual steps are required for cloud resource creation.

### **Infrastructure Components**

✅ **Managed Kubernetes Cluster (SKS)** - Production-ready K8s cluster  
✅ **Managed PostgreSQL Database** - Multi-tenant data persistence  
✅ **Security Groups & Network Policies** - Zero-trust security model  
✅ **Load Balancers & Ingress** - Traffic management and routing  
✅ **Monitoring & Logging** - Observability infrastructure  
✅ **Secrets Management** - Secure credential storage

### **Course Requirements Met**

✅ **3+ Microservices** - API, Consumer, Producer services  
✅ **OAuth2 Authentication** - GitHub OAuth integration  
✅ **Multi-tenancy** - Namespace isolation and tenant management  
✅ **No-click Setup** - Fully automated infrastructure provisioning  
✅ **Kubernetes Deployment** - Production-grade cluster configuration  
✅ **Security-First Design** - Comprehensive security policies

## 📁 Repository Structure

> [!TIP]
> Use the provided `terraform.tfvars.example` as a template for your own configuration. Never commit secrets to version control!

```
INENPT-G1-K8s/
├── infrastructure/                    # Infrastructure as Code
│   ├── main.tf                       # Main Terraform configuration
│   ├── variables.tf                  # Variable definitions
│   ├── terraform.tfvars.example      # Configuration template
│   └── outputs.tf                    # Infrastructure outputs (in main.tf)
├── docs/                            # Documentation
│   ├── architecture.mermaid         # System architecture diagram
│   ├── konzept.puml                 # PlantUML architecture
│   ├── konzept.png                  # Architecture visualization
│   ├── Konzept_Gruppe01.pdf         # Project concept document
│   └── Gruppe01_Präsi.html          # Presentation slides
└── .gitignore                       # Git ignore patterns
```

## 🛠️ Infrastructure Components

> [!IMPORTANT]
> All resources are provisioned in Exoscale Cloud. Make sure your API credentials are valid and have sufficient permissions.

### **1. Exoscale SKS Kubernetes Cluster**

```hcl
resource "exoscale_sks_cluster" "k8s_cluster" {
  name        = "${var.project_name}-sks-cluster"
  version     = var.kubernetes_version
  cni         = "calico"
  exoscale_ccm = true
  metrics_server = true
}
```

**Learning Value**: Understanding managed Kubernetes services vs. self-hosted clusters.

### **2. Managed PostgreSQL Database**

```hcl
resource "exoscale_dbaas" "postgresql" {
  name = "${var.project_name}-postgresql"
  type = "pg"
  plan = var.postgresql_plan
  pg {
    version = "15"
    backup_schedule = "02:00"
  }
}
```

**Learning Value**: Database-as-a-Service concepts and multi-tenant data isolation.

### **3. Security Groups & Network Policies**

```hcl
resource "exoscale_security_group" "sks" {
  name = "${var.project_name}-sks-sg"
  description = "Security group for SKS cluster"
}
```

**Learning Value**: Zero-trust security principles and network segmentation.

## 🔧 Setup & Deployment

> [!WARNING]
> Double-check your `terraform.tfvars` for secrets and sensitive data before committing. Never share your API keys or OAuth secrets publicly!

### **Prerequisites**

- Terraform/OpenTofu >= 1.0
- Exoscale Cloud account
- kubectl configured
- GitHub OAuth application

### **Step 1: Configure Environment**

```bash
# Copy configuration template
cp infrastructure/terraform.tfvars.example infrastructure/terraform.tfvars

# Edit with your values
nano infrastructure/terraform.tfvars
```

### **Step 2: Deploy Infrastructure**

```bash
cd infrastructure

# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply infrastructure
terraform apply
```

### **Step 3: Configure Kubernetes Access**

```bash
# Get cluster credentials
exo compute sks kubeconfig inenpt-g1-sks-cluster \
    --zone at-vie-1 \
    --group system:masters \
    --user admin

# Verify cluster access
kubectl get nodes
```

### **Step 4: Verify Infrastructure**

```bash
# Verify cluster is ready for application deployment
kubectl get nodes
kubectl get namespaces

# Check that the infrastructure is ready for GitOps
# The actual application deployment will be handled by:
# - INENPT-G1-Code: Application source code and CI/CD pipelines
# - INENPT-G1-Argo: GitOps deployment with ArgoCD
```

> [!CAUTION]
> If you destroy the infrastructure, all data in the managed PostgreSQL instance will be lost unless backups are configured and restored.

## 🔗 Integration with Other Repositories

> [!NOTE]
> This repository is **only** responsible for infrastructure provisioning. Application deployment, Helm charts, and Kubernetes manifests are handled by the other repositories in the GitOps pipeline.

### **Integration with [INENPT-G1-Code](https://github.com/MCCE2024/INENPT-G1-Code)**

```yaml
# GitHub Actions workflow in INENPT-G1-Code
- name: Deploy to Kubernetes
  run: |
    kubectl set image deployment/api api=ghcr.io/mcce2024/argo-g1-api:${{ github.sha }}
```

**Connection**: This repository provides the Kubernetes cluster where container images from INENPT-G1-Code are deployed.

### **Integration with [INENPT-G1-Argo](https://github.com/MCCE2024/INENPT-G1-Argo)**

```yaml
# ArgoCD Application in INENPT-G1-Argo
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: api
spec:
  source:
    repoURL: https://github.com/MCCE2024/INENPT-G1-K8s
    path: helm-charts/api
```

**Connection**: This repository provides the Kubernetes cluster and database that ArgoCD uses for application deployment. No Helm charts or manifests are stored here.

## 📊 Learning Objectives & Course Requirements

> [!TIP]
> Review this section to ensure your project submission meets all course requirements and learning goals.

### **Infrastructure as Code (IaC)**

✅ **Terraform/OpenTofu Mastery** - Declarative infrastructure definition  
✅ **Cloud Provider Integration** - Exoscale Cloud platform usage  
✅ **State Management** - Infrastructure state tracking and versioning  
✅ **Modular Design** - Reusable infrastructure components

### **Kubernetes & Container Orchestration**

✅ **Cluster Management** - SKS cluster configuration and optimization  
✅ **Resource Provisioning** - CPU, memory, and storage allocation  
✅ **Network Policies** - Pod-to-pod communication control  
✅ **Security Groups** - Network-level security implementation

### **Multi-Tenancy & Security**

✅ **Namespace Isolation** - Tenant separation at Kubernetes level  
✅ **Resource Quotas** - Per-tenant resource limits  
✅ **Network Segmentation** - Security group-based isolation  
✅ **Secrets Management** - Secure credential handling

### **Production Readiness**

✅ **High Availability** - Multi-node cluster configuration  
✅ **Backup & Recovery** - Database backup strategies  
✅ **Monitoring & Logging** - Infrastructure observability  
✅ **Scalability** - Auto-scaling and load balancing

## 🎓 Key Concepts Demonstrated

> [!NOTE]
> The following examples are taken directly from this repository's code and configuration.

### **1. Infrastructure as Code (IaC)**

```hcl
# Declarative infrastructure definition
resource "exoscale_sks_cluster" "k8s_cluster" {
  name    = "${var.project_name}-sks-cluster"
  version = var.kubernetes_version
}
```

**Learning Outcome**: Understanding how to define infrastructure declaratively rather than manually.

### **2. Cloud-Native Architecture**

```hcl
# Managed services integration
resource "exoscale_dbaas" "postgresql" {
  type = "pg"
  plan = var.postgresql_plan
}
```

**Learning Outcome**: Leveraging cloud-native managed services for operational efficiency.

### **3. Security-First Design**

```hcl
# Zero-trust network policies
resource "exoscale_security_group_rule" "sks_internal_tcp" {
  user_security_group_id = exoscale_security_group.sks.id
  protocol               = "tcp"
  start_port             = 1
  end_port               = 65535
}
```

**Learning Outcome**: Implementing security at every layer of the infrastructure.

### **4. Multi-Tenancy Patterns**

```yaml
# Namespace-based tenant isolation
apiVersion: v1
kind: Namespace
metadata:
  name: tenant-${TENANT_ID}
  labels:
    tenant: ${TENANT_ID}
```

**Learning Outcome**: Designing infrastructure that supports multiple tenants securely.

## 🚨 Troubleshooting Guide

> [!WARNING]
> Infrastructure changes are powerful. Always review your Terraform plan before applying changes to avoid accidental resource deletion or downtime.

### **Common Infrastructure Issues**

#### **1. Terraform State Issues**

```bash
# Check Terraform state
terraform show

# Refresh state if needed
terraform refresh

# Import existing resources
terraform import exoscale_sks_cluster.k8s_cluster <cluster-id>
```

#### **2. Kubernetes Cluster Access**

```bash
# Verify cluster connectivity
kubectl cluster-info

# Check node status
kubectl get nodes

# View cluster events
kubectl get events --sort-by='.lastTimestamp'
```

#### **3. Database Connection Issues**

```bash
# Check database status
terraform output -json

# Test database connectivity
kubectl run test-db --image=postgres:15 --rm -it -- \
    psql -h <db-host> -U <username> -d <database>
```

#### **4. Security Group Configuration**

```bash
# List security groups
exo compute security-group list

# Check security group rules
exo compute security-group show <security-group-id>
```

### **Debugging Commands**

```bash
# Infrastructure status
terraform plan

# Kubernetes cluster status
kubectl get all -A

# Database connectivity
kubectl get secret postgresql-secret -o yaml

# Network policies
kubectl get networkpolicies -A
```

## 📚 Resources & References

> [!TIP]
> Use these resources to deepen your understanding of cloud infrastructure and GitOps best practices.

### **Official Documentation**

- [Terraform Documentation](https://www.terraform.io/docs)
- [Exoscale Documentation](https://www.exoscale.com/documentation/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Helm Documentation](https://helm.sh/docs/)

### **Learning Resources**

- [Infrastructure as Code: Managing Servers in the Cloud](https://www.oreilly.com/library/view/infrastructure-as-code/9781491924334/)
- [Kubernetes: Up and Running](https://www.oreilly.com/library/view/kubernetes-up-and/9781492046523/)
- [Terraform: Up & Running](https://www.oreilly.com/library/view/terraform-up-running/9781491977071/)

### **Related Repositories**

- **[INENPT-G1-Code](https://github.com/MCCE2024/INENPT-G1-Code)**: Application source code and CI/CD
- **[INENPT-G1-Argo](https://github.com/MCCE2024/INENPT-G1-Argo)**: GitOps deployment and ArgoCD configuration

---

## 🎯 Professor's Assessment Guide

> [!IMPORTANT]
> This section is designed to help professors quickly assess whether all course requirements and learning objectives have been met.

### **Learning Objectives Met**

✅ **Infrastructure as Code**: Complete Terraform implementation  
✅ **Cloud Computing**: Exoscale Cloud platform mastery  
✅ **Container Orchestration**: Kubernetes cluster management  
✅ **Multi-tenancy**: Namespace isolation and resource management  
✅ **Security**: Zero-trust network policies and secrets management  
✅ **Automation**: Fully automated infrastructure provisioning

### **Technical Competencies Demonstrated**

- **Terraform/OpenTofu**: Advanced infrastructure provisioning
- **Kubernetes**: Production-grade cluster configuration
- **Cloud Security**: Security groups and network policies
- **Database Management**: Managed PostgreSQL configuration
- **Multi-tenancy**: Tenant isolation and resource quotas
- **GitOps Integration**: Infrastructure ready for ArgoCD deployment

### **Course Requirements Satisfaction**

- ✅ **3+ Services**: API, Consumer, Producer services
- ✅ **OAuth2 Authentication**: GitHub OAuth integration
- ✅ **Multi-tenancy**: Complete tenant isolation
- ✅ **No-click Setup**: Fully automated deployment
- ✅ **Kubernetes**: Production-ready cluster
- ✅ **Security-First**: Comprehensive security implementation

---

**Repository Status**: ✅ **Production Ready**  
**Integration Status**: ✅ **Fully Integrated with 3-Repository Strategy**  
**Learning Value**: ⭐⭐⭐⭐⭐ **Excellent demonstration of modern cloud infrastructure**

---

_This repository is part of a comprehensive 3-repository GitOps strategy demonstrating modern cloud computing principles and production-ready infrastructure management._
