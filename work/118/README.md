# Lab 118：HCP Terraform 定价与功能层级

本节是定价概念课，不需要 HCP Terraform 账号，也不要求购买任何套餐。

请直接阅读 `main.tf` 顶部的知识总结，并按 TODO 1～4 完成。每个 TODO 都提供完整答案级 Hint。

学习路径：

1. 区分 HCP Terraform SaaS 与 Terraform Enterprise 自托管。
2. 理解 managed resource/RUM 计费原则。
3. 根据企业场景选择套餐核对或部署方向。
4. 区分稳定考点与必须实时查询的价格信息。

每完成一段，可以运行：

```powershell
cd work/118
terraform init -input=false
terraform plan -input=false -no-color
```

全部完成后验收：

```powershell
terraform fmt
terraform validate
terraform test
```

本 Lab 没有资源，不需要执行 `apply` 或 `destroy`。

实时信息应查看官方页面：

- [HCP Terraform plans and features](https://developer.hashicorp.com/terraform/cloud-docs/overview)
- [Estimate HCP Terraform cost](https://developer.hashicorp.com/terraform/cloud-docs/overview/estimate-hcp-terraform-cost)
- [HashiCorp product pricing](https://www.hashicorp.com/en/pricing)
