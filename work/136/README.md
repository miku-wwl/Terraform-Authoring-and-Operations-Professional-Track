# Lab 136：aws_iam_policy_document 策略文档数据源

本实验使用 `aws_iam_policy_document` 生成 CloudWatch Logs 权限 JSON，再通过 Terraform AWS Provider 在 LocalStack IAM 中创建 customer managed policy。

你会练到：

- 用 HCL statement 构造 IAM JSON；
- `effect` 默认值和策略语言 Version；
- `.json` 如何流入 `aws_iam_policy.policy`；
- Action 与 Resource 的权限语义；
- `jsondecode` 如何进行稳定的策略测试；
- data source 与 managed resource 的职责差异。

## 1. 启动 LocalStack

本 Lab 只需要 IAM。Policy 中出现 Logs Action 不代表 Terraform 会调用 Logs API：

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -e SERVICES=iam `
  localstack/localstack:4.2.0
```

如果同名容器没有启用 IAM，先停止再重建：

```powershell
docker stop localstack-tf-labs
```

## 2. 准备安全环境

bootstrap 必须在当前 PowerShell 进程执行：

```powershell
cd D:\workshop\Codex\Terraform-Authoring-and-Operations-Professional-Track\work\136
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
& .\scripts\bootstrap.ps1
& .\scripts\check-sandbox.ps1
```

脚本强制使用 `test/test` 和 `http://localhost:4566`；Provider 只配置 IAM endpoint。

## 3. 边学边练

### TODO 1：生成 Policy Document

阅读 `main.tf` 顶部总结，完成两条 statement 后运行：

```powershell
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color
```

此时 `aws_iam_policy_document` 负责本地生成 JSON。第一条省略 `effect`，最终结果仍应出现 `"Effect":"Allow"`。

同时观察一个细节：HCL 写的是 `actions = ["..."]`，但单元素集合在最终 JSON 中可能显示为 `"Action":"..."`。这不是权限变化，只是 Provider 对等价 IAM JSON 的规范化。

### TODO 2：创建 Managed Policy

把：

```hcl
data.aws_iam_policy_document.read_logs.json
```

传给 `aws_iam_policy.read_logs.policy`。再次 plan，应看到 1 个待创建 IAM Policy，而不是 CloudWatch Logs 资源。

### TODO 3：观察并测试语义

输出 policy summary、解码后的 document 和原始 JSON，然后运行：

```powershell
terraform fmt -check
terraform validate
terraform test
```

预期：

```text
Success! 1 passed, 0 failed.
```

测试会创建并自动清理测试 Policy。

## 4. Apply 与验证

```powershell
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
& .\scripts\verify.ps1
```

验证脚本按 JSON 语义检查两条 statement，不会依赖空格、换行或 key 顺序。

## 5. Destroy 与清理

```powershell
terraform destroy -auto-approve
& .\scripts\clean.ps1
```

## Linux / Sandbox

必须 source bootstrap：

```sh
cd work/136
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

## 能验证什么，不能验证什么

本实验能确认 HCL block 合法、生成 JSON 结构正确、IAM Policy 能在 LocalStack 创建和销毁。它不能确认 Action 名称一定真实存在，也不能模拟 SCP、permission boundary、显式 Deny 或 IAM Access Analyzer 的全部判断。

## 停止 LocalStack

```powershell
docker stop localstack-tf-labs
```
