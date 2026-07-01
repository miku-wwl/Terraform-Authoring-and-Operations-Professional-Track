terraform {
  required_version = ">= 1.12.0"
}

resource "terraform_data" "state_audit" {
  input = {
    lab   = "77"
    topic = "Terraform State 管理命令"
  }
}
