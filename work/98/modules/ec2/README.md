# EC2 Module

This is a small local training module that demonstrates the standard Terraform module file layout.

In a real AWS module, `main.tf` would normally contain `aws_instance` resources and related configuration. This training module uses `terraform_data` so the lab can run without cloud credentials.

## Usage

```hcl
module "ec2" {
  source = "./modules/ec2"

  service_name  = "ec2"
  instance_type = "t3.micro"
  tags = {
    Environment = "training"
  }
}
```
