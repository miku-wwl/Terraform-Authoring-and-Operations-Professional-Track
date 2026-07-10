# Lab 138：IAM Role Policy Attachment

本实验使用 LocalStack IAM，实际创建 Lambda Role、customer managed policy 和它们之间的 attachment。

你会练到：

- trust policy 与 permissions policy 的不同职责；
- `aws_iam_role_policy_attachment` 的两个参数；
- Role name 与 Policy ARN 的类型边界；
- resource reference、创建顺序和销毁顺序；
- 单条 attachment 与独占附件管理的区别。

## 1. 启动 LocalStack

本 Lab 只需要 IAM：

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -e SERVICES=iam `
  localstack/localstack:4.2.0
```

如果同名容器没有启用 IAM，先停止再重建。

## 2. 准备安全环境

```powershell
cd D:\workshop\Codex\Terraform-Authoring-and-Operations-Professional-Track\work\138
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
& .\scripts\bootstrap.ps1
& .\scripts\check-sandbox.ps1
```

bootstrap 必须在当前进程执行。脚本强制使用 `test/test` 和 `http://localhost:4566`。

## 3. 边学边练

### 先理解 Starter

`data.aws_iam_policy_document.lambda_trust` 和 `aws_iam_role.lambda` 已提供，这是对 Lab 137 的最小复习。先运行：

```powershell
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color
```

此时只有 Lambda Role，没有 permissions policy attachment。

### TODO 1：创建 Managed Policy

按答案级 Hint 创建 `aws_iam_policy.logs`。再次 plan 后，应同时看到 Role 和 Policy，但 Role 尚未获得该权限。

这里使用 `jsonencode`，因此单元素 `Action` 和 `Resource` 会保留为 JSON array；不要套用 Lab 136 `aws_iam_policy_document` 的单元素规范化结果。

### TODO 2：建立 Attachment

引用 Role name 和 Policy ARN。运行：

```powershell
terraform graph
terraform plan -input=false -no-color
```

计划最终应为 3 个资源；graph 应显示 Attachment 依赖 Role 与 Policy。

### TODO 3：输出并测试关系

```powershell
terraform fmt -check
terraform validate
terraform test
```

预期：`Success! 1 passed, 0 failed.`

## 4. Apply 与独立验证

```powershell
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
& .\scripts\verify.ps1
```

验证脚本会检查 attachment 两端、Lambda trust service 和 permissions policy 的 Action/Resource。

## 5. Destroy 与清理

```powershell
terraform destroy -auto-approve
& .\scripts\clean.ps1
```

观察 destroy：Attachment 应先解除，之后 Role 和 Policy 才能安全删除。

## Linux / Sandbox

```sh
cd work/138
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

Policy 里出现 CloudWatch Logs Action 只是权限文档内容，不会调用 Logs API。本实验也不运行 Lambda，因此只能验证 IAM attachment 闭环，不能证明真实 workload 已获得预期访问能力。

## 停止 LocalStack

```powershell
docker stop localstack-tf-labs
```
