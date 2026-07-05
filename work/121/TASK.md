# Terraform 实操训练 121：HCP Terraform 组织、项目与工作区建模

## 1. 背景

本目录是 `work/121` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 HCP Terraform 基础结构建模练习。

这节课的核心是理解 HCP Terraform 里的几个基础对象：

- organization：HCP Terraform 的顶层组织边界。
- project：组织下用于分组管理 workspace 的项目。
- workspace：真正运行 Terraform workflow、保存远程 state、连接 VCS/CLI/API 的工作区。
- registry：企业可以放私有 modules 和 providers 的位置。
- settings：组织级设置，例如用户邀请、计划与账单。

本 lab 不会真的调用 HCP Terraform API，也不会创建真实云资源。你需要从 `data/hcp-structure.json` 读取 mock 数据，用 `jsondecode()` 和 `for` 表达式整理出课程要求的结构化输出。

## 2. 核心主题

- `file()`：读取当前 module 下的 JSON 文件。
- `jsondecode()`：把 HCP mock JSON 转成 Terraform 值。
- organization / project / workspace 的层级关系。
- workspace workflow：`version_control`、`cli_driven`、`api_driven`。
- 用 `for` 表达式构造 list 和 map。
- 用过滤条件区分默认项目和用户创建的项目。

## 3. 任务目标

请在 `main.tf` 中完成八个 TODO：

1. 用 `jsondecode(file("${path.module}/data/hcp-structure.json"))` 读取并解析 JSON。
2. 从解析后的对象中读取 `organization`。
3. 从解析后的对象中读取 `projects`。
4. 从解析后的对象中读取 `workspaces`。
5. 从解析后的对象中读取 `registry_features`。
6. 提取 organization name。
7. 筛选不是默认创建的 project name。
8. 构造 workspace workflow map、workspace project pair list、registry feature list 和 free plan summary。

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
- `terraform output organization_name` 显示 `example-kplabs-org`。
- `terraform output user_created_project_names` 只显示用户手动创建的 `Terraform Learning`。
- `terraform output workspace_workflows_by_name` 显示三个 workspace 分别对应 VCS、CLI、API workflow。
- `terraform output workspace_project_pairs` 显示 workspace 到 project 的绑定关系。
- `terraform output registry_feature_names` 显示私有 module 和 provider registry 能力。
- `terraform output free_plan_summary` 显示 free plan 和 500 resource limit。

## 6. 约束

- 不要硬编码输出绕过 `jsondecode()` 和 `for` 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- 筛选用户创建项目时使用 `project.auto_created == false`。
- workspace workflow map 必须以 workspace name 作为 key。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
