terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.41.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "hcloud" {
  token = "" # Security risk
}
module "labels" {
  source = "../../" # adjust path

  name        = "payment-api"
  environment = "prod"
  repository  = "terraform-modules"
  attributes  = ["v1"]
  extra_tags = {
    Owner      = "primeOps-technologies"
    CostCenter = "Finance"
  }
}


# Simple, low-cost Hetzner server for testing
resource "hcloud_server" "test" {
  name        = "module.labels.id"
  server_type = "cx11"
  image       = "ubuntu-22.04"
  location    = "nbg1"

  labels = module.labels.tags
}

output "server_name" {
  value = hcloud_server.test.name
}

output "labels_applied" {
  value = hcloud_server.test.labels
}