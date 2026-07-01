# Lab 32：Resource 与 Data Source 区分

本实验只读取 LocalStack STS 身份，不创建资源。

```sh
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export LOCALSTACK_ENDPOINT=http://localhost:4566

bash scripts/check-sandbox.sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
bash scripts/verify.sh
bash scripts/clean.sh
```
