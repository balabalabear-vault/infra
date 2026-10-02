variable "region" {
  description = "Region of the provider account."
  default     = "us-east-1"
}

variable "github_repository" {
  description = "GitHub repository (owner/name) allowed to deploy the website."
  default     = "balabalabear-vault/personal-website"
}
