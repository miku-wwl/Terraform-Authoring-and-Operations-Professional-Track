terraform {
  required_version = ">= 1.12.0"
}

resource "terraform_data" "locking_marker" {
  input = {
    lab   = "75"
    topic = "State Locking 基础"
  }
}
