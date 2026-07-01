data "aws_instances" "lab" {
  filter {
    name   = "tag:Project"
    values = ["tf-lab-31"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running", "pending"]
  }
}
