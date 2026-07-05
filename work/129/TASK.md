# Terraform 实操训练 129：HCP Terraform Team 与 Workspace Permission 建模

## 1. 背景

本目录是 `work/129` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 本地数据建模练习。

这个 lab 对应 HCP Terraform 中的权限管理概念：organization 默认存在 `owners` team，owners 拥有非常高的组织级权限；新用户不应该随便加入 owners，而应该加入 developers、security 等更小权限的 team。team 可以在 project、workspace、private registry 等层面获得不同权限。workspace 级别还可以细分 run 权限、variable 权限、state 权限、Sentinel mocks、run tasks 等控制项。

为了避免真实 HCP Terraform 账号和付费功能依赖，本 lab 使用 `data/permissions.json` 模拟 HCP Terraform 的 team、workspace access 和 invitation 配置。

## 2. 核心主题

- HCP Terraform `owners` team 拥有最高权限，应谨慎使用。
- 新用户应按职责加入最小权限 team，例如 developers 或 security。
- Team permission 可以出现在 organization、project、workspace、private registry 等层面。
- Workspace access 支持 `read`、`plan`、`write`、`admin`、`custom` 等权限级别。
- Custom workspace permission 可以细化 run、variables、state、Sentinel mocks、run tasks 等权限。
- 用 `jsondecode(file(...))` 读取权限 mock 数据。
- 用 `for` 表达式、过滤条件、map 构造和排序完成权限信息整理。

## 3. 任务目标

请在 `main.tf` 中完成十个 TODO：

1. 用 `jsondecode(file("${path.module}/data/permissions.json"))` 读取并解析 JSON。
2. 从解析后的对象中读取 `organization`。
3. 从解析后的对象中读取 `teams` list。
4. 构造 `teams_by_name` map，key 使用 team name。
5. 找出拥有 full organization access 的 owner team。
6. 生成适合新普通用户加入的 safe invite team name list，排除 `owners`。
7. 从解析后的对象中读取 `workspaces` list，并构造 `workspaces_by_name` map。
8. 选中 `dev-web-app` workspace。
9. 构造该 workspace 的 `workspace_access_by_team` map。
10. 读取 developers 的 custom workspace permission、生成权限标签，并把 pending invitation 整理成 email => team map。

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
- `organization_name` 输出 `example-kplabs-org`。
- `owner_team_names` 只包含 `owners`。
- `safe_invite_team_names` 包含 `developers` 和 `security`，不包含 `owners`。
- `developer_workspace_access_level` 输出 `custom`。
- `developer_permission_labels` 能体现 read/plan/apply、variables write、state outputs-only、run tasks read 等细粒度权限。
- `invite_team_assignments` 能把 pending invitation 解析为 email 到 team 的映射。

## 6. 约束

- 不要连接真实 HCP Terraform。
- 不要硬编码最终输出绕过 `jsondecode()` 和 `for` 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- safe invite team 必须从 JSON team 数据中过滤得出，不能包含 `owners`。
- workspace access 必须从 `dev-web-app.team_access` 中筛选/映射得出。
- developer custom permission 必须从 developers team 的 workspace access 中读取。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
