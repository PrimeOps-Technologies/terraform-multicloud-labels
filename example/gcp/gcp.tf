provider "google" {
  project = "" #
  region  = "us-central1"
}

module "labels" {
  source = "../../"

  name        = "payment-api"
  environment = "prod"
  repository  = "terraform-modules"
  attributes  = ["v1"]
  extra_tags = {
    Owner      = "primeOps-technologies"
    CostCenter = "Finance"
  }
}

resource "google_storage_bucket" "test_bucket" {
  name          = module.labels.id
  location      = "US"
  force_destroy = true

  labels = module.labels.labels
}