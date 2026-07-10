# Terraform 实操训练 124：HCP Terraform CLI-driven Run Workflow

## 1. 背景

本目录是 `work/124` 上机做题环境。

CLI-driven workflow 允许工程师继续在本地目录运行 Terraform CLI，但 `plan` 和 `apply` 可以由 HCP Terraform workspace 在远端执行。完整流程通常包括：

1. 在配置中指定 HCP Terraform hostname、organization 和 workspace。
2. 执行 `terraform login` 获取并保存登录凭据。
3. 执行 `terraform init` 初始化 HCP Terraform 集成。
4. 从本地 CLI 发起 `terraform plan` 和 `terraform apply`。

本 lab 不会真的连接 HCP Terraform，而是使用 `data/cli_workflow.json` 模拟上述配置和运行证据。

## 2. 核心主题

- HCP Terraform CLI-driven workflow 的四步执行顺序。
- organization 与 workspace 如何形成远端执行目标。
- `terraform login app.terraform.io` 的用途。
- `terraform init` 后从本地 CLI 触发远端 run。
- 通过执行模式和 Terraform 版本差异识别远端执行。
- 登录 token 的本地存储与 Git 安全边界。

## 3. 任务目标

请在 `main.tf` 中完成七个 TODO：

1. 使用 `jsondecode(file(...))` 读取 `data/cli_workflow.json`。
2. 构造包含 hostname、organization 和 workspace name 的 `cloud_target` object。
3. 使用 `for` 表达式生成按顺序排列的 CLI command list。
4. 生成 HCP Terraform workspace 的浏览器 URL。
5. 根据 execution mode 与本地/远端 Terraform 版本判断 run 是否在远端执行。
6. 构造 authentication safety object，确认 mock 数据没有 token 且 credentials 文件不应提交。
7. 构造最终 `run_summary`，汇总 workspace、命令和远端执行证据。

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
- `cloud_target` 指向 `app.terraform.io`、指定 organization 和 `cli-driven-workflow` workspace。
- `command_sequence` 按 login、init、plan、apply 的顺序排列。
- `workspace_url` 能定位对应 HCP Terraform workspace。
- `remote_execution_detected` 为 `true`。
- `authentication_safety` 显示 mock 数据未包含 token，且 credentials 文件不得提交。

## 6. 约束

- 不要在代码或 JSON 中写入真实 HCP Terraform token。
- 不要把本地 credentials 文件加入仓库。
- JSON 路径必须基于 `path.module` 构造。
- 命令列表必须使用 `for` 表达式从 mock 数据生成，不要直接硬编码最终 list。
- 远端执行判断必须同时检查 `execution_mode == "remote"` 和本地/远端版本不同。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
