# Terraform 实操训练 47：替换顺序与 triggers_replace

## 1. 背景

本目录是 `work/47` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 配置，并观察 plan 中的替换顺序。

这个 lab 不需要 LocalStack。`terraform_data` 是 Terraform 内置资源，足够用来模拟“某个配置变化后必须替换对象”。

## 2. 核心主题

- `triggers_replace`：当指定表达式变化时，强制替换 `terraform_data` 对象。
- `create_before_destroy`：替换时先创建新对象，再销毁旧对象。
- 替换顺序：从 plan 中读懂 `-/+` 和 `+/-` 的区别。

## 3. 任务目标

请在 `main.tf` 中完成两个 TODO：

1. 让 `image_version` 变化时触发 `terraform_data.service_release` 替换。
2. 让替换顺序变成先创建新对象，再销毁旧对象。

TODO 下方已经写了自验证提示。完成后运行 `README.md` 中的命令。

## 4. 验收方式

基础检查：

```sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
```

行为检查：

```sh
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
sh scripts/verify.sh
sh scripts/clean.sh
```

Windows PowerShell 使用对应的 `.ps1` 脚本。

这里的 `terraform plan` / `terraform apply` 只会创建默认的 `image_version = "v1"`。
`scripts/verify.*` 会额外执行一次 `terraform plan -var="image_version=v2"`，用来观察替换计划；这个 `v2` 不会被 apply。

## 5. 预期结果

- `terraform test` 通过。
- `scripts/verify.*` 通过。
- `replace-check.txt` 中能看到 `image_version = "v2"` 触发的 replacement plan。
- `replace-check.txt` 中能看到 `create replacement and then destroy`。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要为了通过测试去写描述型 output。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
