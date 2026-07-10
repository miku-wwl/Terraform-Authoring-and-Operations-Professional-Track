# Lab 135：IAM Managed Policy、Inline Policy 与用户绑定

本实验使用 Terraform AWS Provider 连接 Docker 中的 LocalStack IAM，实际创建并比较 customer managed policy 与 inline policy。

你会练到：

- `jsonencode` 如何把 HCL value 转成 IAM JSON policy；
- `file()` 如何读取独立 JSON policy；
- managed policy、inline policy 和 attachment 的职责；
- resource reference 如何建立正确依赖；
- Action 与 Resource 的最小权限对应关系；
- 创建、检查和销毁 IAM policy 的完整闭环。

## 1. 启动 LocalStack

本 Lab 只需要 IAM：

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -e SERVICES=iam `
  localstack/localstack:4.2.0
```

如果同名容器已经用于其他 Lab，但没有启用 IAM，请先停止再按上面的命令重建：

```powershell
docker stop localstack-tf-labs
```

确认容器健康：

```powershell
docker ps --filter "name=localstack-tf-labs"
```

## 2. 准备安全的测试环境

必须在当前 PowerShell 进程执行 bootstrap；不要用 `pwsh -File` 启动子进程，否则环境变量不会留给后续 Terraform 命令。

```powershell
cd D:\workshop\Codex\Terraform-Authoring-and-Operations-Professional-Track\work\135
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
& .\scripts\bootstrap.ps1
& .\scripts\check-sandbox.ps1
```

脚本会强制使用 `test/test` 和 `http://localhost:4566`。Provider 不保存 credentials，并且只配置 IAM endpoint。

## 3. 边学边练

先阅读 `main.tf` 顶部总结，再完成四个 TODO。

### TODO 1：Customer Managed Policy

使用 `jsonencode` 写 S3 read policy。先观察 HCL value 与最终 JSON 的区别：

```powershell
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color
```

计划中应出现独立的 `aws_iam_policy.s3_read`。Policy 还没有通过 attachment 连接 User 时，它只是独立 IAM 对象。

### TODO 2：Managed Policy Attachment

使用 User name 和 Policy ARN 的 resource reference 创建 attachment，然后运行：

```powershell
terraform validate
terraform graph
```

graph 中应体现 User 与 Policy 都先于 Attachment。

### TODO 3：Inline Policy 与 file()

打开 `policies/ec2-describe.json` 看它的标准 JSON，再使用 `file("${path.module}/policies/ec2-describe.json")` 把它交给 `aws_iam_user_policy`。

Inline policy 通过 `user` 参数直接属于 User，不需要另建 attachment，也没有独立 policy ARN。

### TODO 4：输出策略语义

输出绑定关系，并使用 `jsondecode` 把 Provider 中的 JSON 字符串转回 Terraform value，方便测试 Action 和 Resource，而不是只判断字符串非空。

完成后运行原生测试：

```powershell
terraform fmt -check
terraform validate
terraform test
```

预期：

```text
Success! 1 passed, 0 failed.
```

测试会创建并自动清理测试资源。

## 4. Apply 与独立验证

```powershell
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
& .\scripts\verify.ps1
```

验证脚本会检查：

- managed policy 的 ARN 与 attachment 是否对应；
- S3 bucket/object Action 是否匹配正确 ARN；
- inline policy 是否属于预期 User；
- EC2 Describe Action 是否来自外部 JSON 文件。

## 5. Destroy 与清理

```powershell
terraform destroy -auto-approve
& .\scripts\clean.ps1
```

destroy 应按依赖顺序解除 attachment，并删除 inline policy、managed policy 和 User。

## Linux / Sandbox

必须 source bootstrap，使变量留在当前 shell：

```sh
cd work/135
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

## LocalStack 与真实 AWS 的边界

LocalStack 能验证 Terraform resource、JSON 文档、attachment 和销毁流程，但不证明真实 AWS 的最终授权结果。真实环境还要验证显式 Deny、permissions boundary、SCP、session policy 及资源策略，并使用 IAM Access Analyzer 等工具审查权限。

## 停止 LocalStack

```powershell
docker stop localstack-tf-labs
```
