# Lab 134：IAM 用户、登录配置与访问密钥

本实验使用 Terraform AWS Provider 连接 Docker 中的 LocalStack IAM，实际创建 User、Login Profile 和 Access Key。

你会练到：

- 三种 IAM resource 的职责边界；
- resource reference 如何建立隐式依赖；
- 控制台密码与 API Access Key 的区别；
- `sensitive = true` 与 state 加密不是一回事；
- 创建、验证和销毁身份凭据的完整生命周期。

## 1. 启动 LocalStack

本 Lab 只需要 IAM：

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -e SERVICES=iam `
  localstack/localstack:4.2.0
```

如果同名容器已经用于其他 Lab，但没有启用 IAM，请先停止它，再使用上面的命令重建：

```powershell
docker stop localstack-tf-labs
```

确认容器健康：

```powershell
docker ps --filter "name=localstack-tf-labs"
```

## 2. 准备安全的测试环境

在当前 PowerShell 进程中执行脚本。不要用 `pwsh -File` 启动子进程，否则脚本设置的环境变量不会留给后续 Terraform 命令。

```powershell
cd D:\workshop\Codex\Terraform-Authoring-and-Operations-Professional-Track\work\134
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
& .\scripts\bootstrap.ps1
& .\scripts\check-sandbox.ps1
```

脚本会强制使用 `test/test` 和 `http://localhost:4566`。`provider.tf` 不保存 credentials，并且只配置 IAM endpoint。

## 3. 边学边练

先阅读 `main.tf` 顶部总结，再依次完成三个 TODO。

### TODO 1：创建 Login Profile

引用已有 IAM User 的 `name`，设置 20 位生成密码，并要求首次登录修改密码。完成后先检查语法和依赖图：

```powershell
terraform init -input=false
terraform fmt
terraform validate
terraform graph
```

在 graph 文本中，你应能看到 Login Profile 依赖 IAM User。

### TODO 2：创建 Access Key

为同一个 User 创建状态为 `Active` 的 Access Key。再次执行：

```powershell
terraform validate
terraform plan -input=false -no-color
```

计划应包含三个待创建资源。注意：创建 Access Key 不会自动给用户附加任何 IAM policy。

### TODO 3：设计 Outputs

普通输出用于用户名、重置要求、Access Key ID 和状态。生成密码与 Secret Access Key 必须设置 `sensitive = true`。

完成后运行 Terraform 原生验收：

```powershell
terraform fmt -check
terraform validate
terraform test
```

预期：

```text
Success! 1 passed, 0 failed.
```

`terraform test` 会创建并自动清理测试资源，不会保留供下一阶段观察的普通 state。

## 4. Apply、观察与验证

```powershell
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
& .\scripts\verify.ps1
```

`terraform output` 应显示两个 `<sensitive>`。验证脚本只检查秘密是否非空以及长度，不会打印秘密内容。

如果你主动执行 `terraform output -raw access_key_secret`，仍能读取秘密。这正说明 `sensitive` 是显示层保护，不是 state 加密。请勿把输出复制到日志或提交中。

## 5. 销毁与清理

```powershell
terraform destroy -auto-approve
& .\scripts\clean.ps1
```

destroy 应删除 Access Key、Login Profile 和 User。不要跳过销毁身份凭据的练习。

## Linux / Sandbox

必须 source bootstrap，使环境变量留在当前 shell：

```sh
cd work/134
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

本实验能验证 Terraform resource、依赖关系、敏感 output、state 和销毁路径，但不能证明真实 AWS 中的下列内容：

- IAM policy、permission boundary 或 SCP 是否允许操作；
- 控制台首次登录、密码策略和 MFA 的真实体验；
- 长期凭据的保管、轮换、撤销和审计流程；
- 企业身份联合或 IAM Identity Center 配置是否正确。

真实环境应优先使用角色与短期凭据；本 Lab 创建长期凭据只是为了识别课程中的 Terraform 资源与风险边界。

## 停止 LocalStack

```powershell
docker stop localstack-tf-labs
```
