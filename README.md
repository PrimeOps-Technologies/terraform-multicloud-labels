# 🌍 Terraform-Multicloud-Labels

[![PrimeOps](https://img.shields.io/badge/Made%20by-PrimeOps-blue?style=flat-square&logo=terraform)](https://www.PrimeOps.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-1.13%2B-purple.svg?logo=terraform)](#)
[![CI](https://github.com/PrimeOps-Technologies/terraform-multicloud-labels/actions/workflows/ci.yml/badge.svg)](https://github.com/PrimeOps-Technologies/terraform-multicloud-labels/actions/workflows/ci.yml)

> 🧩 **A universal, opinionated Terraform module by [PrimeOps](https://www.primeops.co.in/)**  
> to generate consistent **resource names, tags, and labels** across **AWS, Azure, GCP, DigitalOcean, and Hetzner**.

---

## 🏢 About PrimeOps

**PrimeOps** delivers **Cloud & DevOps excellence** for modern teams:
- 🚀 **Infrastructure Automation** with Terraform, Ansible & Kubernetes
- 💰 **Cost Optimization** via scaling & right-sizing
- 🛡️ **Security & Compliance** baked into CI/CD pipelines
- ⚙️ **Fully Managed Operations** across AWS, Azure, and GCP

> 💡 Need enterprise-grade DevOps automation?  
> 👉 Visit [**www.primeops.co.in**](https://www.primeops.co.in) or email **primeopstechnologies@gmail.com**

---

## 🌟 Features

- ✅ Unified **naming & tagging** across all major clouds
- ✅ Auto-sanitizes labels for **GCP, DigitalOcean, Hetzner** (lowercase-safe)
- ✅ Generates AWS-compatible **`Name`** and title-case tags
- ✅ Prevents invalid characters & enforces compliance
- ✅ Lightweight, reusable, and easy to integrate

---
                        🧩 Architecture — Naming Flow

            ┌───────────┐     ┌─────────────┐     ┌──────────────┐
            │   name    │  +  │ environment │  +  │ attributes[] │
            └─────┬─────┘     └──────┬──────┘     └──────┬───────┘
                  │                  │                   │
                  └──────────────┬───┴───────┬───────────┘
                                 ▼           ▼
                           ┌───────────────────────────┐
                           │       Normalization       │
                           └──────────────┬────────────┘
                                          ▼
                           ┌───────────────────────────┐
                           │            id             │
                           └──────────────┬────────────┘
                                          ▼
     ┌──────────────────────────┬─────────────────────────┬──────────────────────────┐
     │          tags            │          labels          │        all_tags         │
     └──────────────────────────┴─────────────────────────┴──────────────────────────┘


## ⚙️ Usage Examples

### ☁️ AWS Example
```hcl
module "labels" {
  source      = "git::https://github.com/PrimeOps-Technologies/terraform-multicloud-labels.git?ref=v1.0.0"
  name        = "payment-api"
  environment = "prod"
  repository  = "terraform-multicloud-labels"
  attributes  = ["v1"]

  extra_tags = {
    Owner      = "PrimeOps"
    CostCenter = "Finance"
  }
}

resource "aws_security_group" "main" {
  name = module.labels.id
  tags = module.labels.tags
}
```
### ☁️ GCP Example
```hcl
module "labels" {
  source      = "git::https://github.com/PrimeOps-Technologies/terraform-multicloud-labels.git?ref=v1.0.0"
  name        = "payment-api"
  environment = "prod"
  repository  = "terraform-multicloud-labels"
  attributes  = ["gcp"]
}

resource "google_storage_bucket" "main" {
  name   = module.labels.id
  labels = module.labels.labels
}
```

### ☁️ DigitalOcean Example
```hcl

module "labels" {
  source      = "git::https://github.com/PrimeOps-Technologies/terraform-multicloud-labels.git?ref=v1.0.0"
  name        = "payment-api"
  environment = "prod"
  repository  = "terraform-multicloud-labels"
  attributes  = ["do"]
}

locals {
  do_tag_list = [for k, v in module.labels.labels : "${k}:${v}"]
}

resource "digitalocean_droplet" "main" {
  name   = module.labels.id
  region = "nyc3"
  image  = "ubuntu-22-04-x64"
  size   = "s-1vcpu-1gb"
  tags   = local.do_tag_list
}
```
### ☁️ Hetzner Example
```hcl
module "labels" {
  source      = "git::https://github.com/PrimeOps-Technologies/terraform-multicloud-labels.git?ref=v1.0.0"
  name        = "payment-api"
  environment = "dev"
  repository  = "terraform-multicloud-labels"
  attributes  = ["hetzner"]
}

resource "hcloud_server" "main" {
  name        = "${module.labels.id}-vm"
  server_type = "cx11"
  image       = "ubuntu-22.04"
  location    = "nbg1"
  labels      = module.labels.labels
}
```
### ☁️ Azure Example
```hcl
module "labels" {
  source      = "git::https://github.com/PrimeOps-Technologies/terraform-multicloud-labels.git?ref=v1.0.0"
  name        = "payment-api"
  environment = "uat"
  repository  = "terraform-multicloud-labels"
  attributes  = ["az"]
}

resource "azurerm_resource_group" "main" {
  name     = module.labels.id
  location = "East US"
  tags     = module.labels.tags
}
```
### ☁️ Outputs
| Name         | Description                                                                 |
|---------------|------------------------------------------------------------------------------|
| `id`          | Normalized identifier built from `name`, `environment`, and `attributes`.   |
| `tags`        | AWS/Azure-style TitleCase map (includes `Name`).                            |
| `labels`      | GCP/DO/Hetzner lowercase-safe label map.                                    |
| `all_tags`    | Raw lowercase normalized map (before formatting).                           |
| `name`        | Normalized resource name.                                                   |
| `environment` | Lowercased environment name.                                                |
| `managedby`   | Source or management owner.                                                 |
| `repository`  | Terraform module or repository name.                                        |

### 🧪 Input Variables
| Variable      | Type         | Default                   | Description              |
| ------------- | ------------ |---------------------------|--------------------------|
| `name`        | string       | n/a                       | Base resource name       |
| `environment` | string       | `"dev"`                   | Environment name         |
| `attributes`  | list(string) | `[]`                      | Optional suffix parts    |
| `repository`  | string       | `null`                    | Repo or module name      |
| `managedby`   | string       | `"primeOps-technologies"` | Management owner         |
| `extra_tags`  | map(string)  | `{}`                      | Additional tags          |
| `delimiter`   | string       | `"-"`                     | Join delimiter           | 


### ☁️ Tag Normalization Rules
| Cloud          | Case             | Allowed characters | Example                        |
|----------------|------------------|--------------------|----------------------------------|
| **AWS**        | TitleCase        | Any                | `Name`, `Environment`, `CostCenter` |
| **Azure**      | Case-insensitive | Any                | `environment`, `Name`           |
| **GCP**        | Lowercase        | `[a-z0-9_-]`       | `environment`, `repository`     |
| **DigitalOcean** | Lowercase      | `[a-z0-9_-]`       | `environment`, `repository`     |
| **Hetzner**    | Lowercase        | `[a-z0-9_-]`       | `environment`, `repository`     |

## 👥 Team Members

| Photo |  GitHub |
|-------|-------|
| <img src="https://github.com/sureshyadav76.png" width="60" style="border-radius:50%"> | [@sureshyadav76](https://github.com/sureshyadav76) |
| <img src="https://github.com/themanojkumawat.png" width="60" style="border-radius:50%"> | [@themanojkumawat](https://github.com/themanojkumawat) |
| <img src="https://github.com/Rohityadav-7.png" width="60" style="border-radius:50%"> | [@Rohityadav-7](https://github.com/Rohityadav-7) |
| <img src="https://github.com/yrahul05.png" width="60" style="border-radius:50%"> | [@yrahul05](https://github.com/yrahul05) |
| <img src="https://github.com/therahul28.png" width="60" style="border-radius:50%"> | [@therahul28](https://github.com/therahul28) |




### 💙 Maintained by [PrimeOps](https://www.primeops.co.in)
> PrimeOps — Simplifying Cloud, Securing Scale.