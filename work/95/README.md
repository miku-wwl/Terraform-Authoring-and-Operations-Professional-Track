# 第 95 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `tests/` 下的测试文件。

本节练习的目标是改进自定义 module 的 provider 写法：child module 只声明它需要的 provider 来源和版本，真正的 provider 配置，例如 AWS region，放到调用方目录中。

## 本地执行

```powershell
cd work/95
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
95/
├── main.tf                         # 测试辅助代码：读取 module/team 文件并输出检查结果
├── modules/
│   └── ec2/
│       └── main.tf                 # 需要你改进的 EC2 module 代码
├── teams/
│   └── team_a/
│       └── main.tf                 # 需要你补充 provider 配置的调用方代码
└── tests/
    └── module_provider_improvements.tftest.hcl
```

> 注意：本 lab 不会真的创建 AWS EC2。根目录 `main.tf` 只是读取子目录文件内容并做静态检查，用来练习 provider block 与 `required_providers` 的职责边界。
