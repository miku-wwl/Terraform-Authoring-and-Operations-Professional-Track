# Terraform 实操训练 82：Terraform test assert 断言块

## 1. 背景

本目录是 `work/82` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform test 断言练习。

前面的 Terraform test 练习通常只验证 `run` 能不能执行 `plan` 或 `apply`。这种检查粒度太粗：它只能说明 Terraform 可以跑起来，但不能清楚表达“我要验证什么规则”。

本 lab 会使用 `run` 里面的 `assert` block，把 bucket name 的长度规则写成明确的测试条件。为了避免依赖真实 AWS 账号，本 lab 不创建 S3 bucket，而是用 `terraform_data` 模拟一个 S3 bucket contract。

## 2. 核心主题

- `terraform test`：运行 `.tftest.hcl` 中的测试。
- `run` block：定义一个测试执行单元。
- `command = plan`：只执行 plan 阶段，不创建真实资源。
- `assert` block：在测试中写细粒度断言。
- `condition`：返回 `true` 时测试通过，返回 `false` 时测试失败。
- `error_message`：断言失败时在 CLI 中显示的错误信息。
- `length()`：计算字符串、list 或 map 的长度。

## 3. 任务目标

请在 `tests/bucket_name_assertions.tftest.hcl` 中完成四个 TODO：

1. 保持 `command = plan`，确认测试不会进入 apply 创建阶段。
2. 写第一个 `assert`，验证 `var.s3_bucket_name` 长度必须大于 3。
3. 写第二个 `assert`，验证 `var.s3_bucket_name` 长度必须小于 63。
4. 写第三个 `assert`，验证 `output.bucket_name_length` 等于 `length(var.s3_bucket_name)`。

建议完成后的核心写法类似：

```hcl
assert {
  condition     = length(var.s3_bucket_name) > 3
  error_message = "S3 bucket name must be greater than 3 characters."
}
```

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

完成 TODO 后：

- `terraform test` 返回 `1 passed, 0 failed`。
- 测试运行在 plan 阶段，不会创建真实 AWS S3 bucket。
- `output.bucket_name` 显示默认 bucket name。
- `output.bucket_name_length` 显示默认 bucket name 的长度。
- 如果你临时把 `main.tf` 中的默认值改成 `hi`，`terraform test` 应该失败，并显示你写的 `error_message`。

## 6. 约束

- 不要引入 AWS provider。
- 不要创建真实 S3 bucket。
- 不要把 `command` 改成 `apply`。
- 不要用 `condition = true` 绕过练习。
- 长度判断必须基于 `length(var.s3_bucket_name)`。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
