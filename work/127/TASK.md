# Terraform 实操训练 127：HCP Terraform Run Triggers 与远程输出依赖

## 1. 背景

本目录是 `work/127` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 HCP Terraform run triggers 的建模练习。

这节课的核心场景是：

- `network-project` workspace 发布组织的公网 IP 列表。
- `security-project` workspace 需要读取这些公网 IP，并生成防火墙白名单规则。
- 如果 network workspace 的输出变化，security workspace 应该自动排队运行。
- HCP Terraform 中这个自动化关系可以通过 run triggers 配置。
- 为了让下游 workspace 读取上游输出，上游 workspace 还需要配置 remote state sharing。

本 lab 用 `data/hcp_workspaces.json` 模拟这些配置，不要求真实 HCP Terraform 账号。

## 2. 核心主题

- HCP Terraform organization：多个 workspace 的协作边界与计费边界。
- Workspace：一组 Terraform 配置、state、variables、secrets 的运行单元。
- Remote state sharing：允许指定 workspace 读取当前 workspace 的输出。
- Run triggers：当 source workspace 更新后，自动触发 dependent workspace 的 run。
- `terraform_remote_state` 与 `tfe_outputs` 思路差异：生产中更推荐只读取输出而不是暴露完整 state。
- 用 Terraform expression 建模 workspace 之间的依赖关系。

## 3. 任务目标

请在 `main.tf` 中完成八个 TODO：

1. 用 `jsondecode(file("${path.module}/data/hcp_workspaces.json"))` 读取并解析 mock 数据。
2. 把 workspace list 转换成以 workspace name 为 key 的 map。
3. 从 map 中取出 `network-project` 和 `security-project` 两个 workspace。
4. 从 network workspace 的 outputs 中读取 `public_ips`。
5. 判断 network workspace 是否把 remote state 分享给 security workspace。
6. 判断 security workspace 是否配置了来自 network workspace 的 run trigger。
7. 生成 run trigger 摘要对象，包含 source、target、auto_apply、output_name、datasource。
8. 基于 network public IPs 生成防火墙白名单标签，例如 `allow:8.8.8.8`。

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
- `terraform output organization` 显示 `kp-labs-org`。
- `terraform output workspaces_by_name` 显示两个 workspace：`network-project` 和 `security-project`。
- `terraform output network_public_ips` 显示三个公网 IP。
- `terraform output network_shares_state_with_security` 为 `true`。
- `terraform output security_has_run_trigger_from_network` 为 `true`。
- `terraform output run_trigger_summary` 显示 security workspace 依赖 network workspace。
- `terraform output firewall_allowlist_rules` 显示三个 `allow:<ip>` 标签。

## 6. 约束

- 不要修改 `data/hcp_workspaces.json`。
- 不要硬编码最终输出绕过 JSON 解析练习。
- JSON 文件路径必须基于 `path.module` 构造。
- workspace map 必须从 JSON 中的 `workspaces` list 派生。
- 判断 run trigger 时应检查 `security-project.run_triggers.source_workspaces`。
- 判断 state sharing 时应检查 `network-project.remote_state_sharing.shared_with`。
- 这是 HCP Terraform 概念建模 lab，不需要真实 HCP token，也不要连接真实 HCP Terraform。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
