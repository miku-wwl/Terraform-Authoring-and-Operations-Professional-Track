# 第 49 节做题环境

这个 lab 使用 Terraform AWS Provider + LocalStack 模拟 AWS EC2，不会访问真实 AWS。

核心练习：

- 状态漂移 drift
- 外部系统修改云资源
- `ignore_changes`

## 启动 LocalStack

在仓库根目录执行：

```powershell
docker run -d --rm --name localstack-tf-lab-49 `
  -p 4566:4566 `
  -e SERVICES=ec2,sts `
  localstack/localstack:4.2.0
```

如果你在 Terraform Sandbox 里，LocalStack 通常已经准备好，可以直接进入 `work/49`。

## Windows / PowerShell

```powershell
cd work/49
powershell -ExecutionPolicy Bypass -File .\scripts\check-sandbox.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\bootstrap.ps1
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\clean.ps1
```

## Linux / Terraform Sandbox

```sh
cd work/49
sh scripts/check-sandbox.sh
sh scripts/bootstrap.sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
sh scripts/verify.sh
sh scripts/clean.sh
```

## 验证重点

`terraform test` 只检查 starter 的基础结构。

真正的行为检查在 `scripts/verify.*`：

- Terraform 先创建一个带 `Owner = "terraform"` tag 的模拟 EC2。
- 验证脚本用 AWS CLI 把远端 `Owner` tag 改成 `external`，模拟外部系统制造 drift。
- 验证脚本再运行 `terraform plan -detailed-exitcode`。
- 如果 `ignore_changes` 写对，远端 `Owner` 会保持 `external`，但 Terraform plan 不会计划把它改回 `terraform`。
- 完整 plan 会写入 `drift-check.txt`。

这个 lab 练的是 tag drift，不练 EC2 running/stopped 这类状态机行为。
