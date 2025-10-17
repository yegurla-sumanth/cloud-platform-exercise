variable "name_prefix" { type = string }
variable "region"      { type = string }
variable "desired_count" { type = number }
variable "image_repo_name" { type = string }
variable "image_tag" { type = string }
variable "container_port" { type = number }
variable "alarm_match_string" { type = string }
