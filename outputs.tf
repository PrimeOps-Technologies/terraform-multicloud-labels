##############################################
# Universal Outputs for Multi-Cloud Labeling #
##############################################

# Lowercase, sanitized resource ID (e.g. "payment-api-prod-v2")
output "id" {
  description = "Normalized ID built from name, environment, and attributes."
  value       = local.id
}

# AWS/Azure-style tags:
#   TitleCase keys (e.g. Name, Environment, Managedby)
#   Includes special 'Name' key for AWS console readability.
output "tags" {
  description = "AWS/Azure-friendly tag map with TitleCase keys and 'Name' key for display in console."
  value       = local.tags
}

# GCP/DO/Hetzner-style labels:
#   Lowercase-safe keys that comply with provider restrictions ([a-z0-9_-]).
output "labels" {
  description = "GCP/DigitalOcean/Hetzner-friendly labels map with lowercase-safe keys."
  value       = local.labels
}

# Raw merged lowercase map before case transformations.
# Can be used for auditing or debugging across all clouds.
output "all_tags" {
  description = "Raw merged lowercase-normalized map of all tags before formatting for provider specifics."
  value       = local.all_tags
}

# Optional: convenience outputs for common fields
output "name" {
  description = "Normalized name value."
  value       = local.name
}

output "environment" {
  description = "Normalized environment value."
  value       = local.environment
}

output "managedby" {
  description = "Normalized managedby value."
  value       = local.managedby
}

output "repository" {
  description = "Normalized repository value."
  value       = local.repository
}
