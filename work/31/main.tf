# TODO 1: Read the existing EC2 instances created by scripts/bootstrap.ps1.
# Hint: use data "aws_instances" "lab" with two filter blocks.
# Hint:
#   filter {
#     name   = "tag:Project"
#     values = ["tf-lab-31"]
#   }
# Hint:
#   filter {
#     name   = "instance-state-name"
#     values = ["running", "pending"]
#   }
