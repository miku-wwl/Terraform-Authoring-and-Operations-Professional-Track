resource "terraform_data" "ami_rollout" {
  input = {
    generation = var.ami_rollout_generation
  }
}

resource "terraform_data" "protected_release_marker" {
  input = {
    name  = "tf-lab-46-protected-release"
    owner = "platform"
  }

  lifecycle {
    # TODO 1: Enable prevent_destroy to protect this release marker from accidental destroy.
    # Hint: after apply, `terraform destroy -target=terraform_data.protected_release_marker`
    # should fail. `scripts/verify.*` checks this behavior automatically.
    prevent_destroy = false
  }
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name    = "tf-lab-46-web"
    Project = "tf-lab-46"
    Owner   = "terraform"
  }

  lifecycle {
    # TODO 2: During replacement, create the new EC2 instance before destroying the old one.
    # Hint: after changing TF_VAR_ami_rollout_generation, the plan should say
    # "create replacement and then destroy".
    create_before_destroy = false

    # TODO 3: Ignore only the externally managed Owner tag.
    # Hint: `scripts/verify.*` changes Owner to "external" with AWS CLI, then expects
    # `terraform plan -detailed-exitcode` to return 0.
    ignore_changes = []

    # TODO 4: Force EC2 replacement when the rollout marker changes.
    # Hint: point this at terraform_data.ami_rollout so rollout generation changes
    # replace the instance even when ami and instance_type stay the same.
    replace_triggered_by = []
  }
}
