variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for named resources"
  default     = "catgif"
}

variable "desired_count" {
  type        = number
  description = "Desired number of ECS tasks"
  default     = 1
}

variable "image_repo_name" {
  type        = string
  description = "ECR repository name"
  default     = "catgif-app"
}

variable "image_tag" {
  type        = string
  description = "Tag to deploy (CI sets this to the Git SHA)"
  default     = "latest"
}

variable "container_port" {
  type        = number
  description = "Container port to expose via ALB"
  default     = 80
}

variable "alarm_email" {
  type        = string
  description = "Email for SNS alarm notifications"
  default     = "example@example.com"
}

variable "alarm_match_string" {
  type        = string
  description = "Substring to match in app logs for metric filter"
  default     = "ALERT_TRIGGER"
}
