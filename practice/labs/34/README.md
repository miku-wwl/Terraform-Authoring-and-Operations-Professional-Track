# Lab 34：AMI 动态查询的必要性

本实验用 LocalStack 模拟 AMI 查询。它训练 `aws_ami` 写法，不等价于真实 AWS 公共 AMI 目录。

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
bash scripts/clean.sh
```
