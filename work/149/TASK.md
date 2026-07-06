# Terraform 实操训练 149：Terraform Professional MCQ 重点指针建模

## 1. 背景

本目录是 `work/149` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform Professional 认证 MCQ 重点知识点的本地建模练习。

这个 lab 不连接真实 HCP Terraform、Vault 或 VCS。你会从 `data/exam_pointers.json` 读取一组考试重点指针，用 `jsondecode()` 转成 Terraform 值，然后整理出可被测试验证的 outputs。

## 2. 核心主题

- HCP Terraform organization、project、workspace 的定位。
- Sentinel policy 与 policy set 的挂载范围。
- Variable set 的作用域、变量类别，以及 workspace variable 覆盖 variable set 的优先级。
- Vault provider 读取 secret 后，secret 在 Terraform state 中的风险点。
- `terraform plan -out=...` 与 `terraform apply <planfile>` 的 saved plan workflow。
- HCP Terraform 中读取 workspace outputs 的 `tfe_outputs` 数据源。
- Run triggers、run tasks、check block、CLI flags、VCS trigger troubleshooting 的考试高频点。

## 3. 任务目标

请在 `main.tf` 中完成十五个 TODO：

1. 用 `jsondecode(file("${path.module}/data/exam_pointers.json"))` 读取并解析 JSON。
2. 输出 HCP Terraform 的三个核心对象名称。
3. 读取 organization 的共享协作能力。
4. 读取 workspace 的关键特征。
5. 读取 project 的用途说明。
6. 读取 policy set 可以 enforcement 的目标范围。
7. 判断 policy set 是否直接挂载到 team。
8. 读取 variable set 的 scope。
9. 读取 variable set 支持的变量类别。
10. 根据 workspace variable override 规则，得出最终 `db_write_capacity`。
11. 标记最终变量值来自 workspace variable 还是 variable set。
12. 标记 Vault provider secrets 在 state 中是否为明文风险。
13. 整理 saved plan workflow 的两条 CLI 命令。
14. 读取 HCP Terraform workspace outputs 对应的数据源名称。
15. 读取 run trigger、run task、check block、CLI flags、VCS trigger 的关键判断结果。

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
- `hcp_concepts` 包含 organization、project、workspace。
- `policy_set_direct_team_attachment` 为 `false`。
- `effective_db_write_capacity` 为 `15`，来源为 `workspace_variable`。
- `vault_secrets_plaintext_in_state` 为 `true`。
- `saved_plan_commands` 包含 `terraform plan -out=ec2.plan` 和 `terraform apply ec2.plan`。
- `run_task_stages` 包含 pre-plan、post-plan、pre-apply、post-apply。
- `check_block_failure_behavior` 为 `non_blocking_warning`。

## 6. 约束

- 不要修改 `tests/` 下的验收文件。
- 不要硬编码输出绕过 `jsondecode()` 练习。
- JSON 文件路径必须基于 `path.module` 构造。
- workspace variable 与 variable set key 相同时，workspace variable 具有更高优先级。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
