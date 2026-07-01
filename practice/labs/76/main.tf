terraform {
  required_version = ">= 1.12.0"
}

resource "terraform_data" "s3_lockfile_marker" {
  input = {
    lab         = "76"
    lock_method = "use_lockfile"
  }
}
