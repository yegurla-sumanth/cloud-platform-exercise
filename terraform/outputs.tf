output "alb_dns_name" {
  description = "Public ALB DNS name"
  value       = module.ecs_service.alb_dns_name
}

output "ecr_repo_url" {
  description = "ECR repo URL for the app image"
  value       = module.ecs_service.ecr_repo_url
}

output "log_group_name" {
  description = "CloudWatch Log Group name for the app"
  value       = module.ecs_service.log_group_name
}
