# Already have bucket_id in main.tf; add extra outputs for testing:
output "has_public_access_block" {
  # true if the public access block resource exists
  value = can(aws_s3_bucket_public_access_block.this.id)
}

output "sse_algorithm" {
  # "AES256" expected
  value = try(
    aws_s3_bucket_server_side_encryption_configuration.this.rule[0].apply_server_side_encryption_by_default[0].sse_algorithm,
    ""
  )
}

output "versioning_status" {
  # "Enabled" expected
  value = try(aws_s3_bucket_versioning.this.versioning_configuration[0].status, "")
}
