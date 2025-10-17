run "apply_module" {
  command = apply

  module {
    source = "./.."
    variables = {
      bucket_name   = "tf-test-${lower(replace(uuid(), "-", ""))}"
      force_destroy = true
    }
  }

  # Assertions against module outputs
  assert {
    condition     = output.bucket_id != ""
    error_message = "Bucket not created"
  }

  assert {
    condition     = output.has_public_access_block == true
    error_message = "Public access block not configured"
  }

  assert {
    condition     = output.sse_algorithm == "AES256"
    error_message = "SSE configuration missing or wrong algorithm"
  }

  assert {
    condition     = output.versioning_status == "Enabled"
    error_message = "Versioning not enabled"
  }
}
