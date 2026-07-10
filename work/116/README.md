# 第 116 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/` 下的参考实现或讲义文件。

## 本地执行

```powershell
cd work/116
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color
```

## 手动观察 Terraform 调试日志

### Windows PowerShell

```powershell
$env:TF_LOG = "INFO"
terraform plan -input=false

$env:TF_LOG = "TRACE"
$env:TF_LOG_PATH = "terraform-debug.log"
terraform plan -input=false

Remove-Item Env:TF_LOG
Remove-Item Env:TF_LOG_PATH
```

### Windows CMD

```bat
set TF_LOG=INFO
terraform plan -input=false

set TF_LOG=TRACE
set TF_LOG_PATH=terraform-debug.log
terraform plan -input=false

set TF_LOG=
set TF_LOG_PATH=
```

### Linux / macOS

```sh
export TF_LOG=INFO
terraform plan -input=false

export TF_LOG=TRACE
export TF_LOG_PATH=terraform-debug.log
terraform plan -input=false

unset TF_LOG
unset TF_LOG_PATH
```

`TF_LOG` 和 `TF_LOG_PATH` 可能生成大量日志。排错结束后应立即清除环境变量，并在分享日志前检查其中是否包含敏感信息。

最终验证时会使用 `terraform fmt -check`。
