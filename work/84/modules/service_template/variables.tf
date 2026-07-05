variable "service_name" {
  description = "Unique service name provided by the calling team."
  type        = string
}

variable "team_name" {
  description = "Team that owns the service."
  type        = string
}

variable "environment" {
  description = "Deployment environment, such as dev, test, or prod."
  type        = string
}

variable "owner" {
  description = "Operational owner for the service."
  type        = string
}

variable "enabled" {
  description = "Whether this service is enabled."
  type        = bool
}

variable "ports" {
  description = "Service ports that should be standardized into labels."
  type        = list(number)
}

variable "extra_tags" {
  description = "Common tags supplied by the root module."
  type        = map(string)
  default     = {}
}
