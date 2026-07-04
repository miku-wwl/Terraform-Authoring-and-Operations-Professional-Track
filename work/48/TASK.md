# Terraform 实操训练 48：prevent_destroy 与 state 清理

## 1. 背景

本目录是 `work/48` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 配置，并通过命令观察防误删和 state 清理行为。

这个 lab 使用本地文件模拟关键配置，不需要真实云资源。

## 2. 核心主题

- `prevent_destroy`：阻止 Terraform 销毁受保护资源。
- 防误删：关键对象不应该被普通 `terraform destroy` 直接删掉。
- `terraform state rm`：从 state 中移除对象，解除 Terraform 管理关系。

## 3. 任务目标

请在 `main.tf` 中完成 TODO：

1. 给 `local_file.critical_config` 启用 `prevent_destroy`。

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
```

Windows PowerShell 使用对应的 `.ps1` 脚本。

## 5. 预期结果

- `terraform test` 通过。
- `terraform destroy` 被 `prevent_destroy` 阻止。
- `terraform state rm local_file.critical_config` 能解除 state 管理。
- 本地文件最终被清理。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要把清理命令写成 output 来“过测试”。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
