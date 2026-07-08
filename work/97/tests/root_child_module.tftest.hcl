run "root_module_calls_child_module_correctly" {
  command = plan

  assert {
    condition     = output.root_module_name == "root-module"
    error_message = "root_module_name must identify the current working directory as the root module."
  }

  assert {
    condition     = basename(abspath(output.root_working_directory)) == "97"
    error_message = "root_working_directory must use path.module from the root module."
  }

  assert {
    condition     = output.child_module_role == "child-module"
    error_message = "child_module_role must come from the child module output."
  }

  assert {
    condition     = output.service_full_name == "dev-checkout-api"
    error_message = "service_full_name must be built by the child module from environment and service_name."
  }

  assert {
    condition = output.child_module_summary == {
      module_role       = "child-module"
      service_name      = "checkout-api"
      environment       = "dev"
      owner             = "platform"
      service_full_name = "dev-checkout-api"
    }
    error_message = "child_module_summary must show values passed from the root module into the child module."
  }

  assert {
    condition     = terraform_data.lesson.input.child_module_role == "child-module"
    error_message = "terraform_data.lesson must read the child module output through module.service_identity."
  }
}
