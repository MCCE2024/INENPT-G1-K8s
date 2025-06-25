terraform {
  required_version = ">= 1.0"
  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
      version = "~> 0.54"
    }
  }
}

# Configure Exoscale Provider
provider "exoscale" {
  key    = var.exoscale_api_key
  secret = var.exoscale_api_secret
}

# Private Network for SKS and PostgreSQL
# resource "exoscale_private_network" "main" {
#   name        = "${var.project_name}-private-network"
#   description = "Private network for SKS cluster and PostgreSQL"
#   zone        = var.exoscale_zone
#   start_ip    = "192.168.0.0"
#   end_ip      = "192.168.255.255"
#   netmask     = "255.255.0.0"
# }

# Security Group for SKS Cluster
resource "exoscale_security_group" "sks" {
  name        = "${var.project_name}-sks-sg"
  description = "Security group for SKS cluster"
}

# Security Group Rules for SKS
resource "exoscale_security_group_rule" "sks_ssh" {
  security_group_id = exoscale_security_group.sks.id
  protocol          = "tcp"
  start_port        = 22
  end_port          = 22
  cidr              = "0.0.0.0/0"
  type              = "INGRESS"
}

resource "exoscale_security_group_rule" "sks_http" {
  security_group_id = exoscale_security_group.sks.id
  protocol          = "tcp"
  start_port        = 80
  end_port          = 80
  cidr              = "0.0.0.0/0"
  type              = "INGRESS"
}

resource "exoscale_security_group_rule" "sks_https" {
  security_group_id = exoscale_security_group.sks.id
  protocol          = "tcp"
  start_port        = 443
  end_port          = 443
  cidr              = "0.0.0.0/0"
  type              = "INGRESS"
}

resource "exoscale_security_group_rule" "sks_k8s" {
  security_group_id = exoscale_security_group.sks.id
  protocol          = "tcp"
  start_port        = 6443
  end_port          = 6443
  cidr              = "0.0.0.0/0"
  type              = "INGRESS"
}

# Additional rules for LoadBalancer and NodePort access
resource "exoscale_security_group_rule" "sks_nodeport_range" {
  security_group_id = exoscale_security_group.sks.id
  protocol          = "tcp"
  start_port        = 30000
  end_port          = 32767
  cidr              = "0.0.0.0/0"
  type              = "INGRESS"
}

# Internal cluster communication rules
resource "exoscale_security_group_rule" "sks_internal_tcp" {
  security_group_id      = exoscale_security_group.sks.id
  protocol               = "tcp"
  start_port             = 1
  end_port               = 65535
  user_security_group_id = exoscale_security_group.sks.id
  type                   = "INGRESS"
}

resource "exoscale_security_group_rule" "sks_internal_udp" {
  security_group_id      = exoscale_security_group.sks.id
  protocol               = "udp"
  start_port             = 1
  end_port               = 65535
  user_security_group_id = exoscale_security_group.sks.id
  type                   = "INGRESS"
}

# Pod network communication (Calico CNI)
resource "exoscale_security_group_rule" "sks_pod_network" {
  security_group_id = exoscale_security_group.sks.id
  protocol          = "tcp"
  start_port        = 1
  end_port          = 65535
  cidr              = "192.168.0.0/16"
  type              = "INGRESS"
}

resource "exoscale_security_group_rule" "sks_pod_network_udp" {
  security_group_id = exoscale_security_group.sks.id
  protocol          = "udp"
  start_port        = 1
  end_port          = 65535
  cidr              = "192.168.0.0/16"
  type              = "INGRESS"
}

resource "exoscale_security_group_rule" "sks_egress_tcp" {
  security_group_id = exoscale_security_group.sks.id
  protocol          = "tcp"
  start_port        = 1
  end_port          = 65535
  cidr              = "0.0.0.0/0"
  type              = "EGRESS"
}

resource "exoscale_security_group_rule" "sks_egress_udp" {
  security_group_id = exoscale_security_group.sks.id
  protocol          = "udp"
  start_port        = 1
  end_port          = 65535
  cidr              = "0.0.0.0/0"
  type              = "EGRESS"
}

# SKS Kubernetes Cluster
resource "exoscale_sks_cluster" "k8s_cluster" {
  name        = "${var.project_name}-sks-cluster"
  description = "Managed Kubernetes cluster for multi-tenant application"
  zone        = var.exoscale_zone
  version     = var.kubernetes_version
  cni         = "calico"
  exoscale_ccm = true
  metrics_server = true

  timeouts {
    create = "30m"
    delete = "30m"
  }
}

# SKS Node Pool
resource "exoscale_sks_nodepool" "main" {
  cluster_id  = exoscale_sks_cluster.k8s_cluster.id
  name        = "${var.project_name}-nodepool"
  description = "Main node pool for the SKS cluster"
  zone        = var.exoscale_zone
  size        = var.node_pool_size
  instance_type = var.instance_type
  disk_size   = var.disk_size

  security_group_ids = [exoscale_security_group.sks.id]
  # private_network_ids = [exoscale_private_network.main.id]

  timeouts {
    create = "30m"
    delete = "30m"
  }
}

# Exoscale PostgreSQL Service
resource "exoscale_dbaas" "postgresql" {
  zone = var.exoscale_zone
  name = "${var.project_name}-postgresql"
  type = "pg"
  plan = var.postgresql_plan
  maintenance_dow = "sunday"
  maintenance_time = "23:00:00"

  pg {
    version = "15"
    ip_filter = ["0.0.0.0/0"]
    backup_schedule = "02:00"
  }

  timeouts {
    create = "30m"
    delete = "30m"
  }
}

# Outputs
output "cluster_endpoint" {
  description = "Kubernetes cluster endpoint"
  value       = exoscale_sks_cluster.k8s_cluster.endpoint
} 