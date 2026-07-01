data "aws_ami" "latest" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["tf-lab-ubuntu-*-x86_64"]
  }
}
