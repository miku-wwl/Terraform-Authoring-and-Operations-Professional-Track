# 第 31 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/labs/31/` 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 0. 先确认工具可用

建议使用 PowerShell 7，也就是 `pwsh`。Windows PowerShell 5.1 在读取本实验的 UTF-8 脚本时可能会把中文解析成乱码，导致 `verify.ps1` 报语法错误。

```powershell
docker version
terraform version
aws --version
pwsh --version
```

如果 `docker version` 只有 Client、没有 Server，请先启动 Docker Desktop。

## 1. 启动 LocalStack

在仓库根目录打开 PowerShell：

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -p 4510-4559:4510-4559 `
  -e SERVICES=ec2,sts `
  localstack/localstack:4.2.0
```

如果容器已经存在，先确认它是否还在运行：

```powershell
docker ps --filter "name=localstack-tf-labs"
```

如果输出里能看到 `localstack-tf-labs`，说明已经启动，不需要重复执行 `docker run`。

可以用下面的命令确认 LocalStack 是否就绪：

```powershell
Invoke-WebRequest -UseBasicParsing http://localhost:4566/_localstack/health
```

返回内容中看到 `ec2` 和 `sts` 是 `available` 后，再继续下一步。

## 2. 进入实验目录

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\31

$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
$env:TF_VAR_localstack_endpoint="http://localhost:4566"
```

## 3. 开始做题

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

`terraform output` 应该能看到类似结果：

```text
lab_instance_count = 2
lab_instance_ids = tolist([
  "i-xxxxxxxxxxxxxxxxx",
  "i-yyyyyyyyyyyyyyyyy",
])
```

## 4. 清理 LocalStack

完成练习后，如果后面暂时不做 AWS sandbox lab，可以停止 LocalStack：

```powershell
docker stop localstack-tf-labs
```

## 5. Sandbox / Linux 方式

如果你在 Terraform Sandbox、WSL 或 Linux 环境中，也可以使用 `scripts/*.sh`：

```sh
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
