# Terraform 实操训练 46：Lifecycle meta-argument 行为实验

## 1. 背景

本目录是 `work/46` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 配置，并用 LocalStack 观察真实计划和资源行为。

本实验不会创建真实 AWS 资源。AWS Provider 已被配置为访问 LocalStack endpoint。

## 2. 核心主题

- `create_before_destroy`：替换资源时先创建新对象，再销毁旧对象。
- `prevent_destroy`：阻止 Terraform 销毁受保护资源。
- `ignore_changes`：忽略指定属性的外部漂移。
- `replace_triggered_by`：引用对象变化时强制替换当前资源。

## 3. 任务目标

请在 `main.tf` 中完成四个 TODO：

1. 给 `terraform_data.protected_release_marker` 启用 `prevent_destroy`。
2. 给 `aws_instance.web` 启用 `create_before_destroy`。
3. 让 `aws_instance.web` 忽略外部系统修改的 `tags["Owner"]`。
4. 让 `aws_instance.web` 在 `terraform_data.ami_rollout` 变化时被强制替换。

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

## 5. 预期结果

- `terraform test` 通过。
- `scripts/verify.*` 通过，并确认四个 lifecycle 行为都能观察到。
- `scripts/clean.*` 能清理实验资源。

## 6. 约束

- 不要连接真实 AWS。
- 不要写入真实 AWS credentials。
- 不要修改 `practice/` 下的讲义文件。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
