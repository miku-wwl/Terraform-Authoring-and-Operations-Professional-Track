run "backend_remote_state_model_is_correct" {
  command = plan

  assert {
    condition     = length(output.backend_catalog) == 6
    error_message = "backend_catalog must decode all six backend objects from data/backend-catalog.json."
  }

  assert {
    condition     = sort(keys(output.backends_by_name)) == ["consul", "etcd", "http", "kubernetes", "local", "s3"]
    error_message = "backends_by_name must be a map keyed by backend name."
  }

  assert {
    condition     = output.remote_backend_names == ["s3", "consul", "kubernetes", "http", "etcd"]
    error_message = "remote_backend_names must include every backend whose kind is remote, preserving catalog order."
  }

  assert {
    condition     = output.collaboration_ready_backend_names == ["s3", "consul", "kubernetes", "etcd"]
    error_message = "collaboration_ready_backend_names must keep only remote backends that support locking."
  }

  assert {
    condition     = output.credential_required_backend_names == ["s3", "consul", "kubernetes", "http", "etcd"]
    error_message = "credential_required_backend_names must keep backends that require access credentials."
  }

  assert {
    condition = output.aws_team_backend_recommendation == {
      name           = "s3"
      state_location = "Amazon S3 bucket object"
      locking_note   = "remote backend supports state locking"
    }
    error_message = "aws_team_backend_recommendation must recommend the s3 backend with state location and locking note."
  }
}
