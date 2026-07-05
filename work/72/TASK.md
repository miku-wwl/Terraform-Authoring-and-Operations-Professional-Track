# Terraform 实操训练 72：Terraform Settings 与版本约束

## 1. 背景

本目录是 `work/72` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform settings 练习。

前面已经接触过 `provider` block：它主要用来配置 provider 的运行参数，例如 region、endpoint、credentials 等。但 Terraform 项目级别的行为，例如 Terraform CLI 版本要求、provider 来源和版本约束、backend、实验特性、provider metadata 等，不应该塞进 `provider` block，而是集中放在 `terraform` block 中。

这个 lab 会用不需要下载外部插件的内置 `terraform_data` resource 来模拟设置检查，重点练习：

- `terraform { required_version = ... }`
- `terraform { required_providers { ... } }`
- Terraform block 与 provider block 的职责边界
- 外部 provider 版本固定的表达方式

## 2. 核心主题

- `required_version`：约束当前 module 支持的 Terraform CLI 版本。
- `required_providers`：声明 module 需要哪些 provider，以及 provider source / version 约束。
- 内置 provider：`terraform.io/builtin/terraform` 不需要像 AWS provider 那样从 registry 下载插件。
- 外部 provider：例如 `hashicorp/aws` 可以使用固定版本或范围版本约束。
- Lock file：`.terraform.lock.hcl` 会记录实际选中的 provider 版本，但它不是 Terraform CLI 版本约束的替代品。

## 3. 任务目标

请在 `main.tf` 中完成七个 TODO：

1. 在 `terraform` block 中设置 `required_version`，要求 Terraform 版本为 `>= 1.5.0, < 2.0.0`。
2. 在 `required_providers` 中声明内置 `terraform` provider，source 为 `terraform.io/builtin/terraform`。
3. 在 local 值中记录同样的 Terraform CLI 版本约束。
4. 在 local 值中记录内置 provider 的 source 地址。
5. 在 local 值中记录一个外部 provider 固定版本示例：`hashicorp/aws:5.54.1`。
6. 用 list 记录本节提到的 Terraform settings 功能点。
7. 用 map 说明 `provider` block 与 `terraform` block 的职责边界。

完成后运行 `README.md` 中的命令。

## 4. 验收方式

基础检查：

```sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
```

可选观察输出：

```sh
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

## 5. 预期结果

- `terraform test` 返回 `1 passed, 0 failed`。
- `terraform output terraform_required_version` 显示 `>= 1.5.0, < 2.0.0`。
- `terraform output terraform_provider_source` 显示 `terraform.io/builtin/terraform`。
- `terraform output pinned_external_provider_example` 显示 `hashicorp/aws:5.54.1`。
- `terraform output settings_features` 显示五个 settings 功能点。
- `terraform output block_responsibilities` 能区分 provider block 和 terraform block 的职责。

## 6. 约束

- 不要硬编码测试文件绕过练习。
- `required_version` 必须写在 `terraform` block 内。
- `required_providers` 必须写在 `terraform` block 内。
- 本 lab 使用内置 provider，避免因为外部 registry 网络问题影响练习。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
