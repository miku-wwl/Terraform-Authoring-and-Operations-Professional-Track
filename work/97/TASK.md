# Terraform 实操训练 97：Root Module 与 Child Module

## 1. 背景

本目录是 `work/97` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform module 调用练习。

Terraform 中有两个非常重要的 module 术语：

- **root module**：当前 Terraform 工作目录，也就是你运行 `terraform init/plan/apply/test` 的入口目录。
- **child module**：被另一个 module 调用的 module。比如 root module 通过 `module` block 调用 `./modules/service_identity`，那么 `service_identity` 就是 child module。

这个 lab 使用一个本地 child module，帮助你理解 root module 如何调用 child module、如何传入变量，以及如何读取 child module 的 output。

## 2. 核心主题

- root module：当前工作目录是 Terraform 配置入口。
- child module：被 `module` block 调用的模块。
- `module` block：在 root module 中声明 child module 调用。
- `source`：指定 child module 的来源路径。
- module input variables：root module 给 child module 传参。
- module outputs：root module 通过 `module.<NAME>.<OUTPUT>` 读取 child module 输出。

## 3. 任务目标

请在 `main.tf` 中完成五个 TODO：

1. 将 root module 的名称设置为 `root-module`。
2. 使用 `path.module` 暴露当前 root module 的工作目录。
3. 给 child module 传入 `service_name = "checkout-api"`。
4. 给 child module 传入 `environment = "dev"`。
5. 给 child module 传入 `owner = "platform"`。

`modules/service_identity` 是已经写好的 child module。你主要需要完成 root module 对它的调用与输出读取。

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
- `terraform output root_module_name` 显示 `root-module`。
- `terraform output root_working_directory` 显示当前 root module 目录。
- `terraform output child_module_role` 显示 `child-module`。
- `terraform output service_full_name` 显示 `dev-checkout-api`。
- `terraform output child_module_summary` 显示从 child module 汇总出的 service 信息。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要删除 `modules/service_identity` 目录。
- root module 必须通过 `module "service_identity"` 调用 child module。
- child module 的 `source` 必须保持为本地路径 `./modules/service_identity`。
- 不要硬编码 `service_full_name`，它必须来自 `module.service_identity.service_full_name`。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
