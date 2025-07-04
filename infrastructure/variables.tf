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
  default     = "1.32.6"
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

variable "container_registry" {
  description = "Container registry URL"
  type        = string
  default     = "ghcr.io"
}