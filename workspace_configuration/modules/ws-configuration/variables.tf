variable "current_user_alphanumeric" {}

variable "node_type_id" {}

variable "spark_version_id" {}

variable "github_token" {
  description = "personal access token from GitHub"
}

variable "git_repo" {
  description = "any git repo needed in the infrastructure"
}
