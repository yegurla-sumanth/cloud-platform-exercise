########################
# Root wiring
########################

# Random suffix for unique resource names (buckets, etc.); optional
resource "random_id" "suffix" {
  byte_length = 2
}

# ECS service module (creates VPC, ALB, ECS Service, ECR, etc.)
module "ecs_service" {
  source = "./modules/ecs_service"

  name_prefix           = var.name_prefix
  region                = var.region
  desired_count         = var.desired_count
  image_repo_name       = var.image_repo_name
  image_tag             = var.image_tag
  container_port        = var.container_port
  alarm_match_string    = var.alarm_match_string
}

# Secure S3 bucket module (encryption + public access block)
module "s3_secure_bucket" {
  source = "./modules/s3_secure_bucket"

  bucket_name = "${var.name_prefix}-data-${random_id.suffix.hex}"
  force_destroy = true
}

# CloudWatch Logs alarm for a specific log line
module "log_alarm" {
  source = "./modules/log_alarm"

  alarm_name          = "${var.name_prefix}-logline-alarm"
  log_group_name      = module.ecs_service.log_group_name
  match_string        = var.alarm_match_string
  threshold_per_min   = 10
  alarm_email         = var.alarm_email
}
