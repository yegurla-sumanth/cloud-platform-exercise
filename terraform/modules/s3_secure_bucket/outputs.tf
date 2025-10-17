# Extra outputs to make testing simple & stable
output "has_public_access_block" {
  # true if the public access block resource exists
  value = can(aws_s3_bucket_public_access_block.this.id)
}

output "has_sse" {
  # true if SSE config resource exists
  value = can(aws_s3_bucket_server_side_encryption_configuration.this.id)
}

output "versioning_enabled" {
  # true if versioning status is Enabled
  value = try(aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Enabled", false)
}
