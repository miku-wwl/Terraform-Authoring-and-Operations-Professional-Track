# Terraform 实操训练 89：创建第一个 EC2 Module

## 1. 背景

本目录是 `work/89` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成第一个 Terraform module 的创建练习。

这个 lab 对应“先创建一个最小 EC2 module”的场景：企业内部 module 不一定一开始就像公开 registry module 那样覆盖所有参数。它可以先从一个很小的、可复用的代码块开始，然后被不同 team 通过 `module` block 引用。

为了避免真实 AWS 凭据依赖，本 lab 使用 `terraform_data` 模拟 EC2 instance 配置，不会创建真实云资源。

## 2. 核心主题

- module folder：把可复用代码放到 `modules/ec2/`。
- root module / team caller：根目录用 `module` block 引用本地 module。
- 最小可用 module：先实现组织当前需要的字段，而不是照搬公开 module 的全部参数。
- module output：通过 output 暴露调用方需要消费的结果。
- public module vs internal module：公开 module 通常支持大量选项；内部 module 可以更小、更聚焦。

## 3. 任务目标

请完成两个文件中的 TODO：

### `modules/ec2/main.tf`

1. 在 module 中模拟一个 EC2 instance 配置，`name` 必须为 `team-a-web`。
2. `ami` 必须为 `ami-0abcdef1234567890`。
3. `instance_type` 必须为 `t2.micro`。
4. `region` 必须为 `us-east-1`。
5. `managed_by` 必须为 `terraform-module`。
6. `supported_options` 只保留当前组织需要的四个字段：`ami`、`instance_type`、`region`、`tags`。

### `main.tf`

7. 用 `module "team_a_ec2"` 从 `./modules/ec2` 调用你创建的 EC2 module。

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
- `terraform output team_a_instance_config` 显示 module 返回的模拟 EC2 配置。
- `terraform output team_a_module_metadata` 显示 module 名称、文件数量和支持的最小 option 集合。
- module 只暴露当前练习需要的字段，不要扩展成公开 registry module 那种“大而全”实现。

## 6. 约束

- 不要引入 `aws` provider。
- 不要创建真实 EC2、VPC、Security Group 或 IAM 资源。
- 必须保留本地 module 引用路径 `./modules/ec2`。
- module 内可以硬编码本节练习的 EC2 配置；下一节会继续把硬编码值改成变量。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
