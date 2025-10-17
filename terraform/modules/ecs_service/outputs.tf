output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "ecr_repo_url" {
  value = aws_ecr_repository.repo.repository_url
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.app.name
}
