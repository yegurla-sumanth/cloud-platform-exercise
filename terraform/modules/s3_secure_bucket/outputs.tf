output "has_public_access_block" {
  value = can(aws_s3_bucket_public_access_block.this.id)
}
output "has_sse" {
  value = can(aws_s3_bucket_server_side_encryption_configuration.this.id)
}
output "versioning_enabled" {
  value = try(aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Enabled", false)
}
