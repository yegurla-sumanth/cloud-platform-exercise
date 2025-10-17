# Terraform test for S3 module: validates bucket exists + secure config in plan/apply

run "setup" {
  module {
    source = "./.."
  }
  variables = {
    bucket_name   = "tf-test-bucket-example-123456" # consider overriding via -var if needed
    force_destroy = true
  }
}

# Assert bucket resource planned/created
assert {
  condition     = module.setup.bucket_id != ""
  error_message = "Bucket not created"
}

# Validate public access block planned
assert {
  condition     = exists(resource.aws_s3_bucket_public_access_block.this)
  error_message = "Public access block not configured"
}

# Validate SSE planned
assert {
  condition     = exists(resource.aws_s3_bucket_server_side_encryption_configuration.this)
  error_message = "SSE configuration missing"
}
