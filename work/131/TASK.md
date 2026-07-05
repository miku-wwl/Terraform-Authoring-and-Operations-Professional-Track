# Terraform 实操训练 131：迁移 Local State 到 HCP Terraform

## 1. 背景

本目录是 `work/131` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 HCP Terraform state migration 的概念建模练习。

这一节的重点是理解：当项目一开始使用本地 `terraform.tfstate`，后续要迁移到 HCP Terraform workspace 时，需要先准备 cloud integration，再完成认证，然后通过 `terraform init` 触发 state migration。HCP Terraform 会把 state 存在 workspace 中，保留 historical state version，便于团队协作、审计变更和必要时回滚。

为了避免真实 HCP token、真实 workspace 和外部 provider 依赖，本 lab 使用 `data/state_migration.json` 模拟迁移场景。你需要用 Terraform 表达式读取 mock 数据，生成 cloud block 片段、迁移命令、版本处理策略、state 迁移契约和备份要求。

## 2. 核心主题

- Local state：初始 state 存在当前工作目录的 `terraform.tfstate`。
- HCP Terraform remote state：state 迁移后存储在 HCP Terraform workspace。
- Cloud block：`terraform { cloud { organization = ... workspaces { name = ... } } }`。
- `terraform login`：迁移前需要 CLI 完成 HCP Terraform 认证。
- `terraform init`：加入 cloud block 后，init 会提示是否迁移现有 state。
- `-ignore-remote-version`：本地 Terraform 版本和 remote workspace 版本不一致且确认兼容时使用。
- `-migrate-state`：自动化/CI 场景下避免交互确认，直接迁移 state。
- State safety：迁移前额外备份 `terraform.tfstate`，不能只依赖自动生成的 backup。

## 3. 任务目标

请在 `main.tf` 中完成十个 TODO：

1. 用 `jsondecode(file("${path.module}/data/state_migration.json"))` 读取并解析 mock 数据。
2. 从解析后的对象中读取 `migration`。
3. 读取 migration 中的 `commands` list。
4. 生成按顺序排列的 command name list。
5. 构造 cloud target map，包含 `organization`、`workspace` 和 `state_workspace_specific`。
6. 渲染 cloud block HCL 字符串，展示迁移前需要加入本地配置的 cloud block。
7. 构造 migration commands map，包含 interactive 和 automated 两种迁移命令。
8. 构造 version strategy，判断本地版本和 remote workspace 版本是否不一致，以及是否可以使用 `-ignore-remote-version`。
9. 构造 state migration contract，表达迁移前后 state 位置、历史版本、回滚能力、备份要求、迁移后本地 state 文件状态。
10. 构造 migration prompt object，表达 `terraform init` 期间出现的迁移确认问题和答案。

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
- `terraform output command_names` 显示本地 apply、添加 cloud block、login、interactive init、automated init 的顺序。
- `terraform output cloud_target` 显示组织名、workspace 名，并确认 state 是 workspace-specific。
- `terraform output cloud_block_hcl` 显示可复制到 Terraform 配置中的 cloud block 片段。
- `terraform output migration_commands` 显示交互式迁移命令和自动化迁移命令。
- `terraform output version_strategy` 显示版本不一致时的处理逻辑。
- `terraform output state_migration_contract` 显示 state 从 local 迁移到 HCP Terraform workspace 的安全契约。
- `terraform output backup_files` 显示迁移前建议保留的备份文件。
- `terraform output migration_prompt` 显示 init 迁移确认提示。

## 6. 约束

- 不要硬编码输出绕过 `jsondecode()` 和 Terraform 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- 不要把真实 HCP Terraform token 写入任何文件。
- 不要在本 lab 中添加真实 `terraform { cloud { ... } }` block，否则会要求真实 HCP 登录和 workspace。
- 不要引入 `random`、`aws`、`time` 或其他外部 provider；本 lab 必须可离线初始化和测试。
- 迁移前必须表达额外备份 state 的要求，不要只依赖 `terraform.tfstate.backup`。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
