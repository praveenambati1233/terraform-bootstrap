variable "tags" {
  type = object({
    ApplicationName = optional(string, "devops")
    managedBy       = optional(string, "Terraform")
    Owner           = optional(string, "praveen.ambati@nttdata.com")
    ServiceTier     = optional(string, "Bronze")
    Environment     = string
    SourceLocation  = optional(string, "https://dev.com/yet-to-update")
  })
}


variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
  default     = "centralus"
}

variable "environment" {
  description = "The environment to deploy to"
  type        = string

}