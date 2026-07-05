# Terraform 实操训练 95：自定义 Module 的 Provider 改进

## 1. 背景

本目录是 `work/95` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform module provider 改进练习。

在前面的 module 练习中，EC2 module 里直接写了 `provider "aws"`，并把 region 作为 module 变量传进去。这种写法不推荐：module 应该声明自己需要哪个 provider、provider 来源和兼容版本；而 region、credentials、assume role 等具体 provider 配置应由调用方负责。

本节目标是把 provider 配置从 child module 中移走，改成标准的 `required_providers` 声明。

## 2. 核心主题

- `terraform.required_providers`：声明 module 依赖的 provider 名称、source 和 version constraint。
- `source = "hashicorp/aws"`：使用官方 AWS provider 地址。
- `version = ">= 5.5"`：给 module 代码声明兼容的 AWS provider 版本约束。
- child module 不写 `provider "aws"`：避免把 region 等环境配置硬编码进可复用 module。
- 调用方配置 provider：`teams/team_a` 负责声明 `provider "aws"` 和 `region`。
- module input 只保留业务参数：例如 `name`、`instance_type`，不要把 provider region 当成 EC2 module 参数。

## 3. 任务目标

请完成下面五个 TODO：

1. 在 `modules/ec2/main.tf` 中删除硬编码的 `provider "aws"` block。
2. 在 `modules/ec2/main.tf` 中删除 `variable "region"`，因为 region 应由调用方 provider 配置负责。
3. 在 `modules/ec2/main.tf` 中新增 `terraform` block，并在里面声明：

   ```hcl
   required_providers {
     aws = {
       source  = "hashicorp/aws"
       version = ">= 5.5"
     }
   }
   ```

4. 在 `teams/team_a/main.tf` 中新增调用方 `provider "aws"` block，并使用 `var.aws_region`：

   ```hcl
   provider "aws" {
     region = var.aws_region
   }
   ```

5. 在 `teams/team_a/main.tf` 的 `module "ec2"` 调用中删除 `region = "ap-south-1"`，只保留 EC2 module 真正需要的参数。

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
- `output.ec2_module_has_hardcoded_provider_block` 为 `false`。
- `output.ec2_module_region_variable_removed` 为 `true`。
- `output.ec2_module_required_provider_ready` 为 `true`。
- `output.team_a_provider_ready` 为 `true`。
- `output.team_a_module_region_argument_removed` 为 `true`。

## 6. 约束

- 不要修改 `tests/` 下的测试文件。
- 不要把 AWS region 留在 child module 中。
- `required_providers` 必须写在 `modules/ec2/main.tf` 中，而不是只写在 `teams/team_a/main.tf` 中。
- AWS provider source 必须是 `hashicorp/aws`。
- 本 lab 只做 provider 改进练习，不要求真的创建 AWS 资源。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
