# 第 111 节做题环境

这是你的上机做题目录。请编辑当前目录，不要修改 `practice/labs/111/` 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 本节主旨

本节练习 AWS Provider 的 `default_tags`。

重点是：**在 provider 层统一给资源加默认标签**。

```hcl
default_tags {
  tags = {
    ManagedBy   = "Terraform"
    Environment = "lab"
    Team        = "platform"
  }
}
```

S3 bucket 只是验证工具，用来观察：

```text
provider default_tags + resource tags = tags_all
```

## tags 和 tags_all

| 字段 | 含义 |
| --- | --- |
| `tags` | resource 自己显式声明的标签 |
| `tags_all` | provider default_tags 和 resource tags 合并后的最终标签 |

## 预期结果

| Resource | Resource tags | Final `tags_all` |
| --- | --- | --- |
| `aws_s3_bucket.default` | 无 | `ManagedBy=Terraform`、`Environment=lab`、`Team=platform` |
| `aws_s3_bucket.override` | `Team=network` | `ManagedBy=Terraform`、`Environment=lab`、`Team=network` |

同名 key 冲突时，resource 自己的 `tags` 优先。

## 1. 启动 LocalStack

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -p 4510-4559:4510-4559 `
  -e SERVICES=s3,sts `
  localstack/localstack:4.2.0
```

如果容器已经存在，先确认它是否还在运行：

```powershell
docker ps --filter "name=localstack-tf-labs"
```

## 2. 进入实验目录

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\111
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
$env:TF_VAR_localstack_endpoint="http://localhost:4566"
```

## 3. 边学边练

第一步，先在 `provider.tf` 里补 `default_tags`。

第二步，在 `main.tf` 里创建两个 bucket：

```hcl
resource "aws_s3_bucket" "default" {
  bucket = "tf-pro-lab-111-a"
}

resource "aws_s3_bucket" "override" {
  bucket = "tf-pro-lab-111-b"

  tags = {
    Team = "network"
  }
}
```

第三步，输出 `tags_all`：

```hcl
output "default_tags" {
  value = aws_s3_bucket.default.tags_all
}

output "override_tags" {
  value = aws_s3_bucket.override.tags_all
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

- `default_tags` 在 provider 中配置。
- `default_tags` output 中能看到 `Team = "platform"`。
- `override_tags` output 中能看到 `Team = "network"`。
- 两个 output 都应该包含 `ManagedBy = "Terraform"` 和 `Environment = "lab"`。

## 5. Sandbox / Linux 方式

```sh
export LOCALSTACK_ENDPOINT=http://localhost:4566
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
