# Terraform 实操训练 90：Module Sources 与 source 参数

## 1. 背景

本目录是 `work/90` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform module source 引用练习。

Terraform module 的源代码可以来自很多位置，例如本地路径、Terraform Registry、GitHub、通用 Git 仓库、HTTP URL、S3 bucket 等。无论来源在哪里，调用 module 时都需要使用 `module` block，并在其中配置 `source` 参数。

为了让练习可以在本地稳定运行，本 lab 使用本地路径 module 模拟 module source 的基本调用方式，不依赖 AWS、GitHub 或外网。

## 2. 核心主题

- `module` block：调用一个 reusable module。
- `source` 参数：指定 module 源代码位置。
- 本地路径 source：例如 `./modules/service_blueprint`。
- module input variables：从 root module 给 child module 传参。
- module outputs：从 `module.<name>.<output>` 读取 child module 输出。
- 修改 module source 后通常需要重新运行 `terraform init`。

## 3. 任务目标

请在 `main.tf` 中完成六个 TODO：

1. 将 `module "service"` 的 `source` 改成真正的本地 module 路径 `./modules/service_blueprint`。
2. 给 module 传入 `service_name = "payments-api"`。
3. 给 module 传入 `environment = "prod"`。
4. 给 module 传入 `owner = "platform"`。
5. 通过 `module.service.service_id` 读取 module 输出。
6. 通过 `module.service.module_source_style` 读取 module 输出。

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
- `terraform output service_id` 显示 `payments-api-prod`。
- `terraform output service_summary` 显示 `payments-api::prod::platform`。
- `terraform output module_source_style` 显示 `local-path-module`。
- `terraform output source_examples` 显示常见 module source 写法示例。

## 6. 约束

- 不要修改 `modules/placeholder/` 和 `modules/service_blueprint/` 下的 module 文件。
- 不要修改 `tests/` 下的验收文件。
- 不要硬编码输出绕过 module output 练习。
- 必须通过 `module.service.*` 读取 child module 的输出。
- 本 lab 只使用本地路径 source；不要改成真实 GitHub、Registry、S3 或 HTTP source。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
