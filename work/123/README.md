# 第 123 节做题环境

这是你的上机做题目录。请编辑当前目录下的文件，不要修改 `tests/` 下的测试文件。

本节练习的目标是理解 HCP Terraform 的 CLI-driven workflow：代码仍然保存在本地工作目录，但通过 `terraform { cloud { ... } }` 把本地目录链接到 HCP Terraform workspace。之后从本地 terminal 发起 `terraform plan`、`terraform apply`、`terraform destroy`，实际 run 会在 HCP Terraform 远端执行，并把输出 stream 回本地 CLI。

## 本地执行

```powershell
cd work/123
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

最终验证时会使用 `terraform fmt -check`。

## 目录说明

```text
123/
├── main.tf                         # 测试辅助代码：读取 hcp/ 和 commands/ 下的文件并输出检查结果
├── hcp/
│   └── cli_workflow.tf             # 需要你补全的 HCP Terraform CLI-driven workflow 示例配置
├── commands/
│   └── cli_driven_workflow.sh      # 需要你补全的本地 CLI 发起远端 run 的命令
└── tests/
    └── cli_driven_workflow.tftest.hcl
```

> 注意：本 lab 不会真的连接 HCP Terraform，也不会创建 AWS Security Group。根目录 `main.tf` 只是做静态检查，用来练习 CLI-driven workflow 的关键配置和命令写法。
