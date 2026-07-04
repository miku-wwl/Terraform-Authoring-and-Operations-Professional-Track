# Terraform 实操训练 49：状态漂移与 ignore_changes

## 1. 背景

本目录是 `work/49` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 配置，并用 LocalStack 观察真实 drift。

本实验不会创建真实 AWS 资源。AWS Provider 已被配置为访问 LocalStack endpoint。

## 2. 核心主题

- 状态漂移：真实资源被 Terraform 之外的系统修改。
- 外部修改：用 AWS CLI 修改 EC2 tag，模拟云平台、运维系统或安全平台打标。
- `ignore_changes`：告诉 Terraform 忽略某个属性的漂移，不要在 plan 中抢回配置值。

## 3. 任务目标

请在 `main.tf` 中完成 TODO：

1. 让 `aws_instance.web` 忽略外部系统修改的 `tags["Owner"]`。

TODO 下方已经写了自验证提示。完成后运行 `README.md` 中的命令。

本题只需要改 `lifecycle.ignore_changes`，不要改 tag 的初始值，也不要改 provider、脚本或测试。

目标效果是：

- Terraform 配置里仍然写 `Owner = "terraform"`。
- 外部系统把远端 tag 改成 `Owner = "external"`。
- Terraform plan 不再尝试把远端 tag 改回 `terraform`。

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
- `scripts/verify.*` 通过。
- `drift-check.txt` 中能看到远端 `Owner` tag 已经被外部改成 `external`。
- `drift-check.txt` 中应该显示 Terraform plan 没有要执行的资源变更。

如果 `ignore_changes` 没写对，`scripts/verify.*` 会失败，因为 Terraform 会计划修复这个 tag drift。

## 6. 约束

- 不要连接真实 AWS。
- 不要写入真实 AWS credentials。
- 不要修改 `practice/` 下的讲义文件。
- 不要为了让所有 drift 消失而写 `ignore_changes = all`。
- 不要把本实验改成 EC2 running/stopped 状态实验；本节只观察 tag drift。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
