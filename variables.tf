variable "name" {
  type        = string
  default     = ""
  description = "Name (e.g. `app` or `cluster`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "repository" {
  type        = string
  default     = ""
  description = "Repository or module name (for tagging)."
}

variable "label_order" {
  type        = list(string)
  default     = ["name", "environment"]
  description = "Label order, e.g. `name`,`environment`."
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)."
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. {BusinessUnit = \"XYZ\"})."
}

variable "managedby" {
  type        = string
  default     = "primeOps-technologies"
  description = "ManagedBy, eg 'primeOps-technologies'."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter used between labels and attributes."
}
