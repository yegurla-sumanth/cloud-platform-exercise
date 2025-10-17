run "apply_module" {
  command = apply

  module {
    source = "./.."
  }

  variables {
    bucket_name   = "tf-test-${lower(replace(uuid(), "-", ""))}"
    force_destroy = true
  }

  assert {
    condition     = output.bucket_id != ""
    error_message = "Bucket not created"
  }

  assert {
    condition     = output.has_public_access_block == true
    error_message = "Public access block not configured"
  }

  assert {
    condition     = output.has_sse == true
    error_message = "SSE configuration not configured"
  }

  assert {
    condition     = output.versioning_enabled == true
    error_message = "Versioning not enabled"
  }
}
