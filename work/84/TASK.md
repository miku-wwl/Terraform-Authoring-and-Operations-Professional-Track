# Terraform 实操训练 84：Terraform Modules 与 DRY 复用

## 1. 背景

本目录是 `work/84` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform module 复用练习。

这个 lab 会模拟一个平台团队提供的标准服务模板：业务团队不再重复编写相似的资源配置，而是通过 `module` block 调用同一个本地模块。这样可以体现 DRY（Don't Repeat Yourself）原则：标准逻辑集中维护，多个团队复用同一份模板。

## 2. 核心主题

- `module` block：在 root module 中调用 child module。
- `source = "./modules/service_template"`：引用本地模块目录。
- module input variables：把团队、服务、端口、owner、环境等参数传入标准模板。
- module outputs：从 child module 暴露标准化后的服务记录。
- `merge()`：把公共标签和模块内部标准标签合并。
- `for` 表达式：把多个 module 输出整理成 list、map 和标签列表。

## 3. 任务目标

请在 `main.tf` 和 `modules/service_template/main.tf` 中完成八个 TODO：

1. 在 root module 中定义公共标签 `common_tags`。
2. 补全 `payments_api` module 调用的输入参数。
3. 补全 `commerce_web` module 调用的输入参数。
4. 补全 `batch_worker` module 调用的输入参数。
5. 在 child module 中用 `merge()` 生成标准标签 `standard_tags`。
6. 在 child module 中用 `for` 表达式生成 `service:port` 标签。
7. 在 root module 中收集三个 module 的 `service_record` 输出。
8. 在 root module 中用 `for` 表达式生成 `services_by_name`、`enabled_service_names` 和 `all_port_labels`。

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
- `terraform output service_records` 显示三个由同一个本地模块标准化后的服务对象。
- `terraform output services_by_name` 显示按服务名索引的 map。
- `terraform output enabled_service_names` 只显示启用的服务：`payments-api` 和 `commerce-web`。
- `terraform output all_port_labels` 显示四个 `service:port` 标签。
- 每个服务记录都包含公共标签和模块内部补充的标准标签。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要硬编码输出绕过 module 调用和 module outputs。
- root module 中的三个业务服务必须调用同一个本地模块 `./modules/service_template`。
- child module 中的标准标签必须通过 `merge(var.extra_tags, {...})` 生成。
- `all_port_labels` 必须通过 `flatten()` 和 `for` 表达式从 module 输出中生成。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
