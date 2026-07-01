data "aws_instance" "production" {
  filter {
    name   = "tag:Project"
    values = ["tf-lab-33"]
  }

  filter {
    name   = "tag:Team"
    values = ["production"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running", "pending"]
  }
}

data "aws_instances" "all_lab" {
  filter {
    name   = "tag:Project"
    values = ["tf-lab-33"]
  }
}
