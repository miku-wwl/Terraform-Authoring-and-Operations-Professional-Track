terraform {
  required_version = ">= 1.12.0"
}

resource "terraform_data" "backend_marker" {
  input = {
    lab   = "74"
    topic = "S3 中央后端"
  }
}
