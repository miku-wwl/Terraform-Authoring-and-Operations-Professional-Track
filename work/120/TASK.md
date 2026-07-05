# Terraform 实操训练 120：HCP Terraform 基础结构建模

## 1. 背景

本目录是 `work/120` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 HCP Terraform 组织结构建模练习。

HCP Terraform 的基础结构可以先按三层理解：

- Organization：一个或多个团队协作的共享空间，billing 通常在 organization 级别管理。
- Project：用来把相关 workspace 组织成组，方便按团队、系统或环境管理。
- Workspace：可以近似理解为 HCP Terraform 里的一个 Terraform 工作目录；它通常连接到 GitHub、GitLab、Bitbucket、Azure DevOps 等 VCS 仓库，并在 workspace 级别管理 state、variables、credentials / secrets。

本 lab 不会调用真实 HCP Terraform API。我们用 JSON mock 数据模拟多个 organization、project 和 workspace，然后用 Terraform 表达式整理出清晰的 inventory。

## 2. 核心主题

- `jsondecode(file(...))`：读取 mock 数据。
- organization 级别 billing：把 organization 名称映射到 billing plan。
- project 分组：把 project 展平成可检查的清单。
- workspace inventory：从 organization -> project -> workspace 的嵌套结构中展开 workspace。
- VCS 连接：筛选已经连接 Git 仓库的 workspace。
- workspace 级别变量与敏感变量：整理每个 workspace 的 sensitive variable 名称。

## 3. 任务目标

请在 `main.tf` 中完成八个 TODO：

1. 用 `jsondecode(file("${path.module}/data/hcp_platform.json"))` 读取并解析 JSON。
2. 从解析后的对象中读取 `organizations` list。
3. 构造 `billing_plan_by_org`，key 为 organization 名称，value 为 billing plan。
4. 展平 project 清单，每条记录包含 `org_name`、`project_name`、`team_access_enabled`、`workspace_count`。
5. 展平 workspace 清单，每条记录包含 `org_name`、`project_name`、`workspace_name`、`vcs_provider`、`repository`、`state_location`。
6. 筛选已经连接 VCS 的 workspace name，排除 `vcs_provider == "none"` 的本地 scratch workspace。
7. 构造 `workspace_repository_map`，key 为 workspace name，value 为 repository，只保留已连接 VCS 的 workspace。
8. 构造 `sensitive_variables_by_workspace`，key 为 workspace name，value 为该 workspace 的 sensitive variable 名称列表。

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
- `terraform output organization_count` 显示 2。
- `terraform output workspace_count` 显示 7。
- `terraform output billing_plan_by_org` 能体现 billing 在 organization 级别管理。
- `terraform output project_inventory` 能体现 project 对 workspace 的分组。
- `terraform output vcs_connected_workspace_names` 只包含连接了 VCS 的 workspace。
- `terraform output sensitive_variables_by_workspace` 能体现 credentials / secrets 应按 workspace 敏感变量管理。

## 6. 约束

- 不要连接真实 HCP Terraform。
- 不要要求 HCP token、云账号或 GitHub token。
- 不要硬编码 output 绕过 JSON 读取与 for 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- 筛选 VCS workspace 时排除 `vcs_provider == "none"`。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
