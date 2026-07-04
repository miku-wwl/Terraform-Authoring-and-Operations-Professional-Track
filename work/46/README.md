# 第 46 节做题环境

这个 lab 使用 Terraform AWS Provider + LocalStack 模拟 AWS EC2，不会访问真实 AWS。

核心练习是四个 `lifecycle` meta-argument：

- `prevent_destroy`
- `create_before_destroy`
- `ignore_changes`
- `replace_triggered_by`

## 启动 LocalStack

在仓库根目录执行：

```powershell
docker run -d --rm --name localstack-tf-lab-46 `
  -p 4566:4566 `
  -e SERVICES=ec2,sts `
  localstack/localstack:4.2.0
```

如果你在 Terraform Sandbox 里，LocalStack 通常已经准备好，可以直接进入 `work/46`。

## Windows / PowerShell

```powershell
cd work/46
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
cd work/46
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

`terraform test` 只做基础结构检查；真正的 lifecycle 行为由 `scripts/verify.*` 验证：

- 用 AWS CLI 修改 `Owner` tag，确认 `ignore_changes` 生效。
- 修改 `ami_rollout_generation`，确认 `replace_triggered_by` 触发替换。
- 检查替换计划是否显示先创建新实例再销毁旧实例。
- 尝试销毁受保护标记，确认 `prevent_destroy` 会阻止 destroy。

`prevent_destroy` 会故意阻止普通 destroy，所以最后请用 `scripts/clean.*` 清理。
