
provider "aws" {
  region = "us-east-1"
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

resource "aws_s3_bucket" "test" {
  bucket = module.labels.id
  tags   = module.labels.tags
}
