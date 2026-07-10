# Lab 133：用 aws_subnets 与 aws_subnet 查询子网

本实验使用 Terraform AWS Provider 连接 Docker 中的 LocalStack EC2。你会先创建一个 VPC 和两个 subnet，再分别查询“子网集合”和“单个子网详情”。

```text
aws_vpc + aws_subnet resources
              │
              ├─ aws_subnets：返回一组 ids
              │
              └─ aws_subnet：返回一个 subnet 的详细属性
```

## 1. 启动 LocalStack

本 Lab 只需要 EC2 服务：

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -e SERVICES=ec2 `
  localstack/localstack:4.2.0
```

如果同名容器来自其他 Lab、没有启用 EC2，请重新创建：

```powershell
docker stop localstack-tf-labs
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -e SERVICES=ec2 `
  localstack/localstack:4.2.0
```

## 2. 准备安全环境

```powershell
cd D:\workshop\Codex\Terraform-Authoring-and-Operations-Professional-Track\work\133
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
& .\scripts\bootstrap.ps1
& .\scripts\check-sandbox.ps1
```

脚本会强制使用 LocalStack `test/test` credentials，并拒绝非 `localhost:4566` endpoint。

## 3. 边学边练

### TODO 1：创建查询目标

在已有 VPC 中创建两个 subnet：

| Resource | CIDR | Availability Zone |
|---|---|---|
| `aws_subnet.a` | `10.132.1.0/24` | `us-east-1a` |
| `aws_subnet.b` | `10.132.2.0/24` | `us-east-1b` |

完成后运行：

```powershell
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color
```

### TODO 2：查询集合

使用：

```hcl
data "aws_subnets" "lab"
```

通过 `filter.name = "vpc-id"` 限定当前 VPC。

这里需要显式 `depends_on`：data source 只直接引用 VPC ID。如果不等待 subnet resources，第一次 apply 中查询可能发生得太早。

### TODO 3：读取单个对象详情

使用：

```hcl
data "aws_subnet" "first"
```

按 `aws_subnet.a.id` 精确查询。这个直接引用已经建立隐式依赖，不需要重复写 `depends_on`。

单数 data source 必须唯一匹配。如果过滤条件同时匹配两个 subnet，Provider 会报错，而不是任选一个。

### TODO 4：输出并观察

完成三个 outputs。`subnet_ids` 使用 `sort()` 只为了稳定展示和测试；不要依赖 AWS API 返回集合的自然顺序。

此时 plan 中部分 data source 值可能显示为 `known after apply`，因为查询目标要在本次 apply 中创建。

## 4. Terraform 原生验收

完成全部 TODO 后运行：

```powershell
terraform fmt
terraform validate
terraform test
```

测试使用 `command = apply`，会在 LocalStack 中临时创建并自动清理自己的 VPC/subnets。

预期：

```text
Success! 1 passed, 0 failed.
```

## 5. 手动端到端观察

```powershell
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
& .\scripts\verify.ps1
terraform destroy -auto-approve
& .\scripts\clean.ps1
```

本 Lab 有三个 managed resources，所以必须执行 destroy。

## Linux / Sandbox

```sh
cd work/133
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

## 停止 LocalStack

```powershell
docker stop localstack-tf-labs
```
