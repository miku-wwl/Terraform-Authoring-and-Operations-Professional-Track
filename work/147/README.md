# 第 147 节做题环境

这是你的上机做题目录。请编辑当前目录下的文件，不要修改 `tests/` 下的测试文件。

本节练习的目标是整理 Terraform Professional lab-based exam 的实战策略：先备份 base scenarios，考试场景中快速补 AWS provider block，优先做简单 scenario，按 task 依赖关系取分，熟悉 Terraform 文档位置，并用 validation command 验证结果。

> 注意：本 lab 不会连接 AWS，也不会要求你真的参加考试环境操作。根目录 `main.tf` 只做静态文本检查，用来训练 exam strategy 的关键关键词和工作流。

## 本地执行

```powershell
cd work/147
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
147/
├── main.tf                         # 测试辅助代码：读取 exam/ 下的文件并输出检查结果
├── exam/
│   ├── exam_strategy.md             # 需要你补全的考试策略笔记
│   ├── provider_template.tf          # 需要你补全的考试用 AWS provider 模板
│   ├── docs_navigation.md            # 需要你补全的 Terraform 文档导航笔记
│   └── workflow_checklist.sh         # 需要你补全的考试操作 checklist
└── tests/
    └── terraform_professional_exam_tips.tftest.hcl
```

## 现实工作提醒

`provider_template.tf` 里的 access key / secret key 写法只用于理解视频中的考试环境策略。真实项目中不要把云凭据硬编码进 Terraform 代码，应使用环境变量、workspace variables、OIDC、Vault 或云原生身份机制。
