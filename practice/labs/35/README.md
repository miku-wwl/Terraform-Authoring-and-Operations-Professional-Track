# Lab 35：使用 `aws_ami` 创建 EC2

本实验用 LocalStack 模拟 `aws_ami` 查询并创建 EC2。

```sh
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export LOCALSTACK_ENDPOINT=http://localhost:4566

bash scripts/check-sandbox.sh
bash scripts/bootstrap.sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
bash scripts/verify.sh
terraform destroy -auto-approve
bash scripts/clean.sh
```
