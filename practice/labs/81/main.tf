terraform {
  required_version = ">= 1.5.0"
}

locals {
  test_command  = "terraform test"
  test_file     = "tests/example.tftest.hcl"
  expected_port = 8080
  parallelism   = 1
  topic         = "Terraform test 文件位置"
}

output "test_command" {
  value = local.test_command
}

output "test_file" {
  value = local.test_file
}

output "expected_port" {
  value = local.expected_port
}

output "parallelism" {
  value = local.parallelism
}

