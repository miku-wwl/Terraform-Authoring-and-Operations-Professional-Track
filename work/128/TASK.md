# Terraform 实操训练 128：HCP Terraform Teams 与用户邀请建模

## 1. 背景

本目录是 `work/128` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 数据处理练习。

本节对应 HCP Terraform 的 Teams 功能：组织可以邀请用户加入，用户会收到邀请链接；组织内可以有多个 team；默认会有 `owners` team；`owners` team 拥有最高权限。为了避免真实调用 HCP Terraform API，本 lab 使用 `data/hcp-teams.json` 作为 mock 数据。

## 2. 核心主题

- `file()`：读取当前 module 下的 mock JSON 文件。
- `jsondecode()`：把 HCP Terraform 组织、team、邀请数据转换成 Terraform 值。
- `for` 表达式：从 team list 中提取 name、默认 team、member count。
- `if` 过滤：筛选 pending invitations 和最高权限 team。
- map 构造：把 invitation list 转换成按 email 索引的 map。
- `one()`：从 team list 中选出唯一的 `owners` team。

## 3. 任务目标

请在 `main.tf` 中完成八个 TODO：

1. 用 `jsondecode(file("${path.module}/data/hcp-teams.json"))` 读取并解析 mock 数据。
2. 从解析结果中读取 `organization`。
3. 从解析结果中读取 `teams` list。
4. 从解析结果中读取 `invitations` list。
5. 用 `for` 表达式输出全部 team 名称。
6. 用 `for` + `if` 找到默认 team 名称。
7. 用 `one()` + `for` 找到 `owners` team，并判断它是否具备最高访问级别。
8. 构造 team member count map、pending invitation emails、invitation targets、invitations by email。

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
- `terraform output organization_name` 显示 `kp-labs`。
- `terraform output team_names` 显示 `owners`、`platform-engineering`、`app-developers`。
- `terraform output default_team_names` 只显示 `owners`。
- `terraform output owners_has_highest_access` 显示 `true`。
- `terraform output pending_invitation_emails` 显示两个 pending 邀请邮箱。
- `terraform output invitations_by_email` 按 email 索引所有邀请记录。

## 6. 约束

- 不要硬编码输出绕过 `jsondecode()` 和 `for` 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- `owners` team 必须从 `local.teams` 中筛选出来，不要手写一个 owners 对象。
- pending invitation 必须通过 `invitation.status == "pending"` 筛选。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
