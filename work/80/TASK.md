# Terraform 实操训练 80：Terraform test 入门与命名规则测试

## 1. 背景

本目录是 `work/80` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform test 入门练习。

这个 lab 模拟一个常见 review 场景：团队成员写了一个基于 `bucket_name` 变量的资源配置。Terraform 代码本身可能能通过 `validate`，但是如果传入的 bucket 名称太短、太长、包含大写字母，或者使用了保留前缀，真实云资源在 apply 阶段仍然可能失败。

本 lab 不会创建真实 AWS S3 bucket，而是用 `terraform_data` 模拟资源输入，把重点放在：如何把命名规则写成 Terraform 表达式，并通过 `terraform test` 在 plan 阶段自动验证这些规则。

## 2. 核心主题

- `terraform test`：运行 `.tftest.hcl` 测试文件。
- `run` block：定义一个测试用例。
- `command = plan`：在 plan 阶段执行测试，不创建真实资源。
- `variables` block：为不同测试用例注入不同变量值。
- `assert` block：断言输出值是否满足预期。
- `length()`：检查字符串长度范围。
- `regex()` + `can()`：检查字符串是否只包含允许字符。
- `startswith()`：检查并拒绝保留前缀。
- `compact()`：过滤空字符串，生成清晰的错误原因列表。

## 3. 任务目标

请在 `main.tf` 中完成五个 TODO：

1. 判断 `bucket_name` 长度是否在 3 到 63 之间。
2. 判断 `bucket_name` 是否只包含小写字母、数字、点号和连字符。
3. 判断 `bucket_name` 是否没有以 `xn--` 这个保留前缀开头。
4. 根据前三个检查结果生成 `invalid_reasons` 列表。
5. 根据检查结果生成最终布尔值 `is_bucket_name_valid`。

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

也可以手动覆盖变量观察结果：

```sh
terraform plan -input=false -var='bucket_name=hi'
terraform plan -input=false -var='bucket_name=hi-from-zeal'
terraform plan -input=false -var='bucket_name=xn--team-bucket'
```

## 5. 预期结果

- `terraform test` 返回 `5 passed, 0 failed`。
- 合法名称 `hi-from-zeal` 应通过全部检查。
- 两字符名称 `hi` 应触发长度错误。
- 64 字符名称应触发长度错误。
- 包含大写字母的名称应触发字符集错误。
- 以 `xn--` 开头的名称应触发保留前缀错误。

## 6. 约束

- 不要修改 `tests/` 下的测试文件来绕过练习。
- 不要硬编码某一个测试输入的结果。
- 本 lab 只覆盖视频里提到的核心命名规则子集，不要求实现完整 AWS S3 bucket 命名规范。
- 不要添加 `variable` validation 阻止 invalid case plan；本 lab 需要让测试用例能传入错误值，然后通过输出和断言检查错误原因。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
