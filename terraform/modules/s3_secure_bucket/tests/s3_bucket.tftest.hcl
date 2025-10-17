run "apply_module" {
  command = apply

  module {
    source = "./.."
  }

  variables {
    bucket_name   = "tf-test-${lower(replace(uuid(), "-", ""))}"
    force_destroy = true
  }

  # Assertions live INSIDE the run block
  assert {
    condition     = output.bucket_id != ""
    error_message = "Bucket not created"
  }

  assert {
    condition     = exists(resource.aws_s3_bucket_public_access_block.this)
    error_message = "Public access block not configured"
  }

  assert {
    condition     = exists(resource.aws_s3_bucket_server_side_encryption_configuration.this)
    error_message = "SSE configuration missing"
  }
}
