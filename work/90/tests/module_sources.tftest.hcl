run "local_module_source_is_referenced_correctly" {
  command = plan

  assert {
    condition     = output.service_id == "payments-api-prod"
    error_message = "service_id must come from module.service.service_id after using the real service_blueprint module and passing the required inputs."
  }

  assert {
    condition     = output.service_summary == "payments-api::prod::platform"
    error_message = "service_summary must be built by the child module from service_name, environment, and owner inputs."
  }

  assert {
    condition     = output.module_source_style == "local-path-module"
    error_message = "module_source_style must come from the service_blueprint module output, not the placeholder module."
  }

  assert {
    condition     = output.source_examples.local_path == "./modules/service_blueprint"
    error_message = "source_examples.local_path must show the local source path used in this lab."
  }

  assert {
    condition     = output.source_examples.github == "github.com/example-org/example-module"
    error_message = "source_examples.github must show the GitHub source format without an https:// prefix."
  }

  assert {
    condition     = output.source_examples.generic_git == "git::https://example.com/org/example-module.git"
    error_message = "source_examples.generic_git must show the generic git:: source format."
  }

  assert {
    condition     = output.source_examples.s3_archive == "s3::https://s3.amazonaws.com/example-bucket/example-module.zip"
    error_message = "source_examples.s3_archive must show the s3:: archive source format."
  }
}
