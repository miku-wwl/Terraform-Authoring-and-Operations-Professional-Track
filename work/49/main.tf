resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name    = "tf-lab-49-web"
    Project = "tf-lab-49"
    Owner   = "terraform"
  }

  lifecycle {
    # TODO 1: Ignore only the externally managed Owner tag drift.
    # Hint: scripts/verify.* changes Owner from "terraform" to "external"
    # with AWS CLI, then expects `terraform plan -detailed-exitcode` to return 0.
    ignore_changes = []
  }
}
