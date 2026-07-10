# Terraform 实操训练 117：模拟 HCP Terraform Workspace 与 Run Workflow

## 1. 背景

本目录是 `work/117` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成一个 HCP Terraform workspace/run 的本地数据建模练习。

HCP Terraform 为团队提供集中式 runs、远程 state、VCS 集成、workspace variables、cost estimation、policy checks 和人工审批等能力。本 lab 不连接真实 HCP Terraform，而是读取 `data/hcp_workspace.json` 中的 mock 数据，使用 Terraform 表达式分析一个 workspace 和一次 run。

## 2. 核心主题

- HCP Terraform workspace：保存 Terraform 版本、execution mode、VCS 与变量配置。
- VCS-driven workflow：代码仓库变更可以触发远程 run。
- Run phases：plan、cost estimation、policy check、apply。
- Policy checks：失败的强制策略会阻止 run 进入 apply。
- Workspace variables：区分 Terraform variables 与 environment variables。
- Sensitive variables：识别应在平台中以敏感方式保存的变量。
- Manual approval：`auto_apply = false` 时需要人工确认 apply。

## 3. 任务目标

请在 `main.tf` 中完成九个 TODO：

1. 使用 `jsondecode(file(...))` 读取 `data/hcp_workspace.json`。
2. 读取 workspace object。
3. 构造 workspace summary。
4. 构造 VCS source label，例如 `github:acme/network-infrastructure@main`。
5. 从 run phases 中提取 phase name list。
6. 找出 status 为 `failed` 的 policy names。
7. 找出 sensitive variable keys。
8. 分别找出 Terraform variable keys 与 environment variable keys。
9. 根据失败策略与 `auto_apply` 判断 run 是否 blocked、是否需要人工审批。

完成后运行 `README.md` 中的命令。

## 4. 验收方式

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
- workspace summary 正确显示 organization、project、workspace、Terraform version 与 execution mode。
- VCS source label 为 `github:acme/network-infrastructure@main`。
- run phases 按 JSON 中的顺序输出。
- 失败策略只有 `restrict-instance-types`。
- sensitive variables 包含两项 AWS credential key。
- Terraform variables 与 environment variables 被正确分类。
- run 因 policy failure 被阻止，并且由于 `auto_apply = false` 需要人工审批。

## 6. 约束

- 不要修改 `tests/` 下的测试来绕过验收。
- 不要硬编码最终输出；必须从 JSON mock 数据计算。
- JSON 文件路径必须使用 `path.module` 构造。
- 变量分类必须基于 `category` 字段。
- 策略失败判断必须基于 `status == "failed"`。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
