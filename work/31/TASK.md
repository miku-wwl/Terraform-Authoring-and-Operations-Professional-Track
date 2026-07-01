# Lab 31 任务：读取已有 EC2 实例列表

## 背景

LocalStack 中已经通过 `scripts/bootstrap.sh` 创建了两台带 `Project=tf-lab-31` 标签的模拟 EC2。

## 任务目标

你需要使用 Terraform data source 读取这些已有实例，而不是创建新实例。

## 你需要编辑的文件

- `main.tf`
- `outputs.tf`

## 禁止事项

- 不要创建 `aws_instance` resource。
- 不要访问真实 AWS。
- 不要修改 `provider.tf` 中的 LocalStack endpoint。

## 验收标准

- `terraform validate` 通过。
- `terraform apply` 后输出实例 ID 列表。
- `bash scripts/verify.sh` 通过。

## 建议执行顺序

```sh
bash scripts/check-sandbox.sh
bash scripts/bootstrap.sh
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
bash scripts/verify.sh
```
