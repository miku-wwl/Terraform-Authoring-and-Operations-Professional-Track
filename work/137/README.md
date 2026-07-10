# Lab 137：IAM Role 与 AssumeRole 信任策略

本实验使用 Terraform AWS Provider 连接 LocalStack IAM，实际创建一个只信任 EC2 service principal 的 IAM Role。

你会练到：

- Role、trust policy 与 permissions policy 的职责边界；
- `Principal.Service` 和 `sts:AssumeRole`；
- `aws_iam_policy_document` 如何生成 trust JSON；
- `.json` 如何进入 `aws_iam_role.assume_role_policy`；
- 使用 `jsondecode` 验证 Role 实际保存的信任语义。

## 1. 启动 LocalStack

本 Lab 只需要 IAM：

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -e SERVICES=iam `
  localstack/localstack:4.2.0
```

如果同名容器没有启用 IAM，先执行 `docker stop localstack-tf-labs`，再重新启动。

## 2. 准备安全环境

bootstrap 必须在当前 PowerShell 进程执行：

```powershell
cd D:\workshop\Codex\Terraform-Authoring-and-Operations-Professional-Track\work\137
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
& .\scripts\bootstrap.ps1
& .\scripts\check-sandbox.ps1
```

脚本强制使用 `test/test` 和 `http://localhost:4566`。Provider 只配置 IAM endpoint。

## 3. 边学边练

### TODO 1：构造 Trust Policy

完成 `aws_iam_policy_document.ec2_trust` 后运行：

```powershell
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color
```

检查生成 JSON 中的 `Principal.Service`、`Action` 和 `Effect`。HCL 输入是 list，但单元素在 JSON 中可能规范化为字符串，语义不变。

### TODO 2：创建 Role

把 data source 的 `.json` 赋给 `assume_role_policy`。再次 plan，应只出现 1 个待创建 IAM Role。

本 Lab 没有 permissions policy。这是有意设计：trust policy 只允许 EC2 扮演 Role，不赋予 S3、EC2 或其他业务权限。

### TODO 3：输出并测试信任语义

完成 outputs 后运行：

```powershell
terraform fmt -check
terraform validate
terraform test
```

预期：

```text
Success! 1 passed, 0 failed.
```

## 4. Apply 与验证

```powershell
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
& .\scripts\verify.ps1
```

验证脚本检查 Role identity 和完整 trust policy 语义，不只检查 ARN 是否存在。

## 5. Destroy 与清理

```powershell
terraform destroy -auto-approve
& .\scripts\clean.ps1
```

## Linux / Sandbox

```sh
cd work/137
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
terraform destroy -auto-approve
sh scripts/clean.sh
```

## 实验边界

真实 EC2 使用这个 Role 还通常需要 Instance Profile，以及调用方的 `iam:PassRole` 权限。应用最终能访问哪些 AWS 资源，则由 Role 的 permissions policies 决定。这些属于后续主题，本 Lab 不混入额外操作。

## 停止 LocalStack

```powershell
docker stop localstack-tf-labs
```
