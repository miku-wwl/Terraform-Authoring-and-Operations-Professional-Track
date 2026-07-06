run "localstack_s3_backend_is_configured" {
  command = plan

  assert {
    condition     = output.localstack_endpoint == "http://localhost:4566"
    error_message = "localstack_endpoint must point to the LocalStack edge endpoint."
  }

  assert {
    condition     = output.backend_region == "us-east-1"
    error_message = "backend_region must be us-east-1 for this LocalStack lab."
  }

  assert {
    condition     = output.state_bucket_name == "tfstate-lab73"
    error_message = "state_bucket_name must match the bucket created by bootstrap/."
  }

  assert {
    condition     = output.state_key == "lab73/terraform.tfstate"
    error_message = "state_key must store this lab's state under lab73/terraform.tfstate."
  }

  assert {
    condition     = output.application_bucket_name == "lab73-app-state-demo"
    error_message = "application_bucket_name must create the expected LocalStack S3 bucket."
  }

  assert {
    condition     = output.backend_note_object_key == "backend/remote-state.txt"
    error_message = "backend_note_object_key must identify the object created through the LocalStack AWS provider."
  }

  assert {
    condition = output.backend_lesson_summary == {
      backend_type      = "s3"
      state_location    = "s3://tfstate-lab73/lab73/terraform.tfstate"
      provider_endpoint = "http://localhost:4566"
      lesson            = "Terraform can store state in an S3-compatible remote backend while the AWS provider manages S3 resources."
    }
    error_message = "backend_lesson_summary must describe the LocalStack S3 backend practice."
  }
}
