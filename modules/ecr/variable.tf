variable "ecr_repo_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}