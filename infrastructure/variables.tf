variable "exoscale_api_key" {
  description = "Exoscale API key"
  type        = string
  sensitive   = true
}

variable "exoscale_api_secret" {
  description = "Exoscale API secret"
  type        = string
  sensitive   = true
}

variable "exoscale_zone" {
  description = "Exoscale zone"
  type        = string
  default     = "at-vie-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "inenpt-g1"
}

variable "kubernetes_version" {
  description = "Kubernetes version for SKS cluster"
  type        = string
  default     = "1.32.5"
}

variable "node_pool_size" {
  description = "Number of nodes in the SKS node pool"
  type        = number
  default     = 3
}

variable "instance_type" {
  description = "Exoscale instance type for SKS nodes"
  type        = string
  default     = "standard.medium"
}

variable "disk_size" {
  description = "Disk size in GB for SKS nodes"
  type        = number
  default     = 50
}

variable "postgresql_plan" {
  description = "PostgreSQL service plan"
  type        = string
  default     = "Hobbyist 2"
}

variable "github_oauth_client_id" {
  description = "GitHub OAuth Client ID"
  type        = string
}

variable "github_oauth_client_secret" {
  description = "GitHub OAuth Client Secret"
  type        = string
  sensitive   = true
}

variable "github_org" {
  description = "GitHub organization for OAuth"
  type        = string
  default     = "your-github-org"
}

variable "container_registry" {
  description = "Container registry URL"
  type        = string
  default     = "ghcr.io"
}

variable "argocd_repo_url" {
  description = "ArgoCD repository URL for application manifests"
  type        = string
}

variable "argocd_repo_username" {
  description = "ArgoCD repository username"
  type        = string
}

variable "argocd_repo_password" {
  description = "ArgoCD repository password/token"
  type        = string
  sensitive   = true
} 