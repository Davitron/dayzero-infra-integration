variable "github_token" {
  description = "GitHub token for private repo access"
  type        = string
  sensitive   = true
  default     = ""
}