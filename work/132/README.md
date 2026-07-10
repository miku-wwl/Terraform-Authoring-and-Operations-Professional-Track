# Lab 132：用 aws_caller_identity 查询当前身份

本实验使用本机 Terraform AWS Provider 连接 Docker 中的 LocalStack STS，完成一次真实的 `GetCallerIdentity` 查询。

你会练到：

- `data` 与 `resource` 的区别；
- AWS Provider 当前 credentials 代表哪个 calling entity；
- `account_id`、`user_id` 和 `arn` 的含义；
- 使用动态 Account ID 拼接 ARN，避免硬编码；
- LocalStack 模拟身份与真实 AWS IAM 身份的边界。

## 1. 启动 LocalStack

本 Lab 只需要 STS：

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -e SERVICES=sts `
  localstack/localstack:4.2.0
```

容器已经存在时，确认它仍然健康：

```powershell
docker ps --filter "name=localstack-tf-labs"
```

## 2. 准备安全的测试凭据

在当前 PowerShell 进程中执行脚本。不要使用 `pwsh -File` 启动子进程，否则脚本设置的环境变量不会留给后续 Terraform 命令。

```powershell
cd D:\workshop\Codex\Terraform-Authoring-and-Operations-Professional-Track\work\132
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
& .\scripts\bootstrap.ps1
& .\scripts\check-sandbox.ps1
```

脚本会强制使用：

```text
AWS_ACCESS_KEY_ID=test
AWS_SECRET_ACCESS_KEY=test
LOCALSTACK_ENDPOINT=http://localhost:4566
```

`provider.tf` 不保存 credentials，只从环境变量读取测试值。

## 3. 边学边练

先阅读 `main.tf` 顶部知识总结，再依次完成 TODO。

### TODO 1：声明 Data Source

完成 `data "aws_caller_identity" "current" {}` 后运行：

```powershell
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color
```

`aws_caller_identity` 没有参数。Terraform 通常会在 plan 的 refresh/read 阶段通过 AWS Provider 查询 STS。

### TODO 2：读取身份属性

把 `account_id`、`user_id` 和 `arn` 放入 `local.caller_identity`，再次运行 plan。

注意：

- `user_id` 是唯一标识，不等于 IAM username；
- `arn` 是 calling entity ARN，不保证一定是 IAM User ARN；
- LocalStack 默认返回模拟账号 `000000000000`。

### TODO 3：动态拼接 ARN

使用查询到的 `account_id` 生成：

```text
arn:aws:iam::000000000000:role/platform-deployer
```

这对应真实工程中的常见用法：构造 IAM/KMS policy 时从当前 Provider 身份获取账号，而不是把账号 ID 写死。

## 4. Terraform 原生验收

完成三个 TODO 后运行：

```powershell
terraform fmt
terraform validate
terraform test
```

预期：

```text
Success! 1 passed, 0 failed.
```

测试使用 `command = plan`，因此不需要创建 AWS resource。

## 5. 可选：观察 Data Source State 和 Outputs

如果希望练习 `apply` 和 `terraform output`：

```powershell
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
& .\scripts\verify.ps1
```

这里的 apply 不会创建 LocalStack AWS resource，只会把查询结果和 outputs 记录进本地 Terraform state。

本 Lab 没有 managed resources，因此不需要执行 `terraform destroy`。完成后清理本地文件：

```powershell
& .\scripts\clean.ps1
```

## Linux / Sandbox

必须 source bootstrap 脚本，使环境变量保留在当前 shell：

```sh
cd work/132
. ./scripts/bootstrap.sh
sh scripts/check-sandbox.sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
sh scripts/verify.sh
sh scripts/clean.sh
```

## 停止 LocalStack

```powershell
docker stop localstack-tf-labs
```
