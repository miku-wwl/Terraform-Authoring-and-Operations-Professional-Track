# 第 130 节做题环境

这是你的上机做题目录。请编辑当前目录下的文件，不要修改 `tests/` 下的测试文件。

本节练习的目标是理解 HCP Terraform Health Assessments：它可以在 workspace 里做自动健康评估，核心包括 drift detection 和 continuous validation。由于该能力不是免费基础层可用的能力，本 lab 不会真的连接 HCP Terraform，也不会要求你开通付费 tier；你只需要完成静态说明、check block 示例和替代自动化命令。

## 本地执行

```powershell
cd work/130
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
130/
├── main.tf                                      # 测试辅助代码：读取 hcp/、examples/、commands/ 下的文件并输出检查结果
├── hcp/
│   └── health_assessments.md                    # 需要你补全的 HCP Terraform Health Assessments 说明
├── examples/
│   └── continuous_validation_check.tf           # 需要你补全的 Terraform check block 示例
├── commands/
│   └── health_assessment_alternatives.sh        # 需要你补全的自定义 drift/check 自动化命令
└── tests/
    └── health_assessments.tftest.hcl
```

> 注意：本 lab 不会真的调用 HCP Terraform Health Assessments。根目录 `main.tf` 只做静态文本检查，用来练习 exam 视角下的关键概念。
