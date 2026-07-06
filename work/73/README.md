# 第 73 节做题环境

这是你的上机做题目录。请编辑当前目录下的 `main.tf`，完成 LocalStack S3 backend 与 remote state 练习。

本节不再使用普通的 `terraform init && terraform test` 一条龙流程，因为 S3 backend 需要先有 bucket。你需要先用 `bootstrap/` 创建 LocalStack S3 state bucket，再初始化主 lab。

## 前置条件

确认 LocalStack 已经运行，并且本机可以访问：

```powershell
curl http://localhost:4566/_localstack/health
```

如果你要自己启动 LocalStack，可参考：

```powershell
docker run --rm -it -p 4566:4566 -e SERVICES=s3 localstack/localstack
```

## 自验证流程

1. 创建 backend bucket：

```powershell
cd work/73/bootstrap
terraform init -input=false
terraform apply -auto-approve
```

2. 完成 `work/73/main.tf` 的 TODO，然后初始化主 lab 的 S3 backend：

```powershell
cd ..
terraform init -reconfigure -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
```

3. 验证 remote state consumer：

```powershell
cd consumer
terraform init -input=false
terraform apply -auto-approve
terraform output
```

4. 清理资源：

```powershell
cd ..
terraform destroy -auto-approve
cd bootstrap
terraform destroy -auto-approve
```

最终验证时会使用 `terraform fmt -check`。
