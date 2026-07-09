variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
  default     = "southeastasia"
}

variable "project_code" {
  default = "azlz"
}

variable "environment" {
  type = string
}

variable "instance_id" {
  default = "01"
}

variable "resource_group_type" {
  default = "devops"
}

variable "zone_tier" {
  default = "intr"
}

variable "function_name" {
  default = "tfs"
}

variable "service_type" {
  default = "devops"
}