# Terraform 实操训练 92：Custom Module 去硬编码与 Provider 改进

## 1. 背景

本目录是 `work/92` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform custom module 改进练习。

前面已经做过最基础的 custom module：开发者可以在 root module 中调用 `module`，让 module 帮自己生成一组基础设施配置。但一个初级 module 往往会有两个明显问题：

1. module 内部写死 AMI、instance type 等值，调用方无法覆盖。
2. module 内部写死 provider 或 region，导致调用方以为自己改了 region，实际资源仍可能落在 module 写死的区域。

本 lab 不会真实创建 EC2。我们用 `terraform_data` 模拟一个 EC2 module 的最终配置，通过 `terraform test` 检查 module 是否从“硬编码 demo”改成了“可复用 module”。

## 2. 核心主题

- Module 输入变量：用 `var.ami_id` 和 `var.instance_type` 替代 module 内部硬编码。
- 调用方覆盖：root module 传入不同 AMI 和实例规格时，module 应该尊重调用方输入。
- Provider 责任边界：module 不应该在内部写死 region，region 应交给调用方的 provider 配置决定。
- `required_providers`：module 可以声明自己需要的 provider 来源和版本约束，但不应该把 region 写死在 module 里。
- 静态验收：用 `file()`、`regexall()` 和 `terraform test` 检查 module 源码是否完成关键改进。

## 3. 任务目标

请完成以下 TODO：

1. 在 `modules/ec2_instance/main.tf` 中，把硬编码 AMI 改成 `var.ami_id`。
2. 在 `modules/ec2_instance/main.tf` 中，把硬编码 instance type 改成 `var.instance_type`。
3. 在 `modules/ec2_instance/main.tf` 中，移除 module 自己维护的 region 字段，不要让 module 输出或保存 `region`。
4. 在 `modules/ec2_instance/versions.tf` 中，添加 AWS provider 的 `required_providers` 声明：

```hcl
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = ">= 5.5"
  }
}
```

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
- `terraform output effective_module_config` 中的 `ami_id` 应来自 root module 传入值：`ami-team-a-ubuntu`。
- `terraform output effective_module_config` 中的 `instance_type` 应来自 root module 传入值：`t2.large`。
- `effective_module_config` 不应再包含 `region` 字段。
- `module_main_has_region_literal` 应为 `false`。
- `module_versions_has_aws_required_provider` 应为 `true`。

## 6. 约束

- 不要真实创建 AWS EC2 实例。
- 不要在 module 内部写 `provider "aws" { region = ... }`。
- 不要在 module 内部保留 `us-east-1`、`ap-south-1` 这类固定 region 字符串。
- 不要把测试期望值硬编码到 output 里绕过 module 输入变量练习。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
