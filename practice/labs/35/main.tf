data "aws_ami" "latest" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["tf-lab-app-*-x86_64"]
  }
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.latest.id
  instance_type = "t3.micro"

  tags = {
    Name    = "tf-lab-35-instance"
    Project = "tf-lab-35"
  }
}
