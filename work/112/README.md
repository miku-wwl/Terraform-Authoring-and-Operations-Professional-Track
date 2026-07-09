# 第 112 节做题环境

这是你的上机做题目录。请编辑当前目录，不要修改 `practice/labs/112/` 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 本节主旨

本节练习 AWS Provider 的 `assume_role`。

重点不是 S3 bucket，而是 provider 的身份获取流程：

```text
基础凭证 -> STS AssumeRole -> 临时身份 -> 创建资源
```

在 Terraform 里，这个流程写在 `provider "aws"` 中：

```hcl
assume_role {
  role_arn     = "arn:aws:iam::000000000000:role/tf-pro-lab-112"
  session_name = "tf-pro-lab-112"
}
```

资源本身不需要写 `assume_role`。只要资源使用这个 provider，provider 就会先完成 assume role，再创建资源。

## 为什么要学它

真实项目里，`assume_role` 很常见：

- CI/CD 用一个基础身份进入目标账号部署资源。
- 平台团队跨账号管理 dev/test/prod 环境。
- Terraform 不长期持有高权限 access key，而是换取短期临时身份。

本实验用 LocalStack 模拟 STS 调用路径，所以不会访问真实 AWS。

## 1. 启动 LocalStack

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -p 4510-4559:4510-4559 `
  -e SERVICES=s3,iam,sts `
  localstack/localstack:4.2.0
```

如果容器已经存在，先确认它是否还在运行：

```powershell
docker ps --filter "name=localstack-tf-labs"
```

## 2. 进入实验目录

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\112
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
$env:TF_VAR_localstack_endpoint="http://localhost:4566"
```

## 3. 边学边练

第一步，先在 `provider.tf` 中补 `assume_role`：

- `endpoints.sts` 指向 LocalStack，因为 assume role 要通过 STS。
- `assume_role.role_arn` 是要扮演的角色 ARN。
- `assume_role.session_name` 是本次临时会话的名字，方便审计。

```hcl
assume_role {
  role_arn     = "arn:aws:iam::000000000000:role/tf-pro-lab-112"
  session_name = "tf-pro-lab-112"
}
```

第二步，在 `main.tf` 中创建一个 S3 bucket，验证这个 provider 可以工作：

```hcl
resource "aws_s3_bucket" "assumed" {
  bucket = "tf-pro-lab-112"
}

output "bucket_name" {
  value = aws_s3_bucket.assumed.bucket
}
```

## 4. 验收命令

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\check-sandbox.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\clean.ps1
```

验收重点：

- provider 中配置了 `assume_role`。
- provider endpoints 中包含 `sts = var.localstack_endpoint`。
- S3 bucket 不直接写 assume role 逻辑。
- Terraform 能通过该 provider 创建 `tf-pro-lab-112` S3 bucket。

## 5. Sandbox / Linux 方式

```sh
export LOCALSTACK_ENDPOINT=http://localhost:4566
export TF_VAR_localstack_endpoint=http://localhost:4566
bash scripts/check-sandbox.sh
bash scripts/bootstrap.sh
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
bash scripts/verify.sh
terraform destroy -auto-approve
bash scripts/clean.sh
```

## 6. 清理 LocalStack

```powershell
docker stop localstack-tf-labs
```
