# Terraform 实操训练 93：Module Variables 与避免硬编码

## 1. 背景

本目录是 `work/93` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform module variable 练习。

这节的核心是：模块作者不应该把调用方可能需要调整的值硬编码在 module 里。更好的方式是把这些值声明成变量，让不同团队在调用 module 时传入自己的配置。

例如：

- team one 想要 `t2.micro`。
- team two 想要 `m5.large`。
- 如果 module 内部把 instance type 写死，team two 就无法覆盖。
- 如果 module 使用 `var.instance_type`，不同调用方就可以复用同一个 module，但传入不同配置。

## 2. 核心主题

- `variable` block：定义 module 接收的输入。
- `var.<name>`：在 module 内部引用调用方传入的值。
- module caller：root module 通过 `module` block 给 child module 传值。
- 避免硬编码：把 name、environment、instance_type、tags 这类值从固定字符串改成变量。
- module flexibility：同一个 module 被调用两次，但输出不同的配置模型。

## 3. 目录结构

```text
93/
├── README.md
├── TASK.md
├── main.tf
├── modules/
│   └── flexible_instance/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── tests/
    └── module_variables.tftest.hcl
```

## 4. 任务目标

请在 `modules/flexible_instance/main.tf` 中完成 TODO，把硬编码值替换成变量引用：

1. `name` 使用 `var.name`。
2. `environment` 使用 `var.environment`。
3. `instance_type` 使用 `var.instance_type`。
4. `enable_hibernation` 使用 `var.enable_hibernation`。
5. `tags` 使用 `var.tags`。
6. `label` 使用变量拼接成 `name:environment:instance_type`。

`variables.tf` 已经给出变量声明。你的重点是让 module implementation 真正使用这些变量，而不是继续使用写死的默认值。

## 5. 验收方式

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

## 6. 预期结果

- `terraform test` 返回 `1 passed, 0 failed`。
- `team_one_profile` 使用 `team-one-api`、`dev`、`t2.micro`。
- `team_two_profile` 使用 `team-two-worker`、`prod`、`m5.large`。
- 两个 module 调用来自同一个 child module，但因为传入变量不同，所以输出不同。

## 7. 约束

- 不要为了通过测试而在 root module output 中硬编码结果。
- 不要删除 `module "team_one"` 和 `module "team_two"`。
- 不要把 team two 的值写死在 child module 中。
- child module 应通过 `var.<name>` 接收调用方传入的值。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
