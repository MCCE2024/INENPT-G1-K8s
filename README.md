# INENPT-G1-K8s: Infrastructure as Code

> **Infrastructure Foundation** 🏗️  
> This repository contains the **Infrastructure as Code (IaC)** components for provisioning cloud resources on Exoscale using OpenTofu (or Terraform).

## 📁 Project Structure

```
INENPT-G1-K8s/
├── infrastructure/           # Infrastructure as Code (Terraform)
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars.example
└── docs/                    # Documentation
```

## 🏗️ Infrastructure Overview

All infrastructure in this repository is provisioned using OpenTofu (or Terraform) and targets the Exoscale Cloud platform. The configuration is modular and designed for production-ready, multi-tenant Kubernetes environments.

### Main Components

- **Exoscale SKS Kubernetes Cluster**: Managed Kubernetes cluster for application workloads.
- **Exoscale PostgreSQL Database**: Managed PostgreSQL instance for persistent, multi-tenant data storage.
- **Security Groups & Network Policies**: Network-level security for cluster and database access.

## 🔧 Usage Guide

### 1. Configure Your Variables

Copy the example variables file and fill in your values:

```bash
cp infrastructure/terraform.tfvars.example infrastructure/terraform.tfvars
# Edit infrastructure/terraform.tfvars with your settings
```

### 2. Initialize and Apply Infrastructure

Run the following commands from the `infrastructure/` directory:

```bash
cd infrastructure
tofu init   # or 'terraform init' if using Terraform
tofu plan
tofu apply
```

### 3. Cluster Access

After provisioning, retrieve your Kubernetes cluster credentials using the Exoscale CLI:

```bash
exo compute sks kubeconfig <cluster-name> --zone <zone> --group system:masters --user admin
kubectl get nodes
```

## 📚 Documentation

See the `docs/` folder for detailed architecture, onboarding, and integration guides.

## ⚠️ Notes

- **Never commit secrets** to version control. Use `terraform.tfvars` for sensitive values and keep it out of git.
- All resources are created in Exoscale Cloud. Ensure your API credentials are valid and have sufficient permissions.

## 🔗 How This Repository Integrates with the Others

- **INENPT-G1-Code**:  
  - Contains the application source code and CI/CD workflows for building and pushing Docker images.
  - The images built here are referenced in the deployment manifests managed by INENPT-G1-Argo.

- **INENPT-G1-K8s (this repo)**:  
  - Provisions the Kubernetes cluster and managed PostgreSQL database using OpenTofu (or Terraform).
  - Outputs cluster and database connection information for use by the other repositories.

- **INENPT-G1-Argo**:  
  - Contains the GitOps deployment configuration (Helm charts, ArgoCD ApplicationSets, Sealed Secrets).
  - Uses the infrastructure provisioned by this repository as the deployment target.

## 🚀 Possible Improvements

- **ArgoCD GitHub Action for ApplicationSet Templates** (INENPT-G1-Argo):
  - Automate the generation and update of ApplicationSet YAMLs using a GitHub Action, reducing manual errors and improving scalability for new tenants/services.

- **GitHub Action for Tag Update** (INENPT-G1-Code & INENPT-G1-Argo):
  - After a successful image build, automatically create a PR in INENPT-G1-Argo to update the image tag in Helm values, ensuring seamless GitOps deployment.

- **Secure Database IP Filtering** (INENPT-G1-K8s):
  - Restrict PostgreSQL access to only the Kubernetes cluster or specific CIDRs, rather than 0.0.0.0/0, to enhance security.

- **Proxy for Request Forwarding & JWT Generation** (INENPT-G1-Code):
  - Implement a proxy service to route requests to the correct tenant namespace based on URL, and optionally generate JWT tokens for secure, multi-tenant authentication.

### Additional Considerations
- All improvements are viable and align with best practices for automation, security, and scalability.
- Ensure proper testing and review for automation (GitHub Actions) to avoid accidental disruptions.
- For security enhancements, validate network policies and access controls after changes.
- Proxy and JWT logic should be thoroughly tested for security vulnerabilities and correct multi-tenancy behavior.
