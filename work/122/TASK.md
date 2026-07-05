# Terraform 实操训练 122：HCP Terraform Workspace 与 VCS Workflow 建模

## 1. 背景

本目录是 `work/122` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 本地数据建模练习。

这个 lab 对应 HCP Terraform workspace 的核心工作流：workspace 可以关联 GitHub 等 VCS repository，HCP Terraform 会从 repository 拉取 Terraform code，然后在 workspace 中执行 plan / apply。workspace 还会维护自己的 variables、state、credentials 和 run 设置。

为了避免真实云账号依赖，本 lab 使用 `data/workspaces.json` 模拟 HCP Terraform 中的组织、项目、workspace、VCS repository、environment variables 和 run 行为。

## 2. 核心主题

- HCP Terraform workspace 与普通目录的区别。
- Version Control Workflow：workspace 关联 GitHub repository 后，由远端 run 读取代码并执行 plan/apply。
- Workspace variables：通过 environment variable 注入 AWS provider 所需配置。
- Sensitive variable：密钥类变量应标记为 sensitive。
- Manual apply：plan 完成后可以手动 confirm/apply，也可以 discard run。
- 用 `jsondecode(file(...))` 读取 workspace mock 数据。
- 用 `for` 表达式、过滤条件和 map 构造完成 workspace 信息整理。

## 3. 任务目标

请在 `main.tf` 中完成九个 TODO：

1. 用 `jsondecode(file("${path.module}/data/workspaces.json"))` 读取并解析 JSON。
2. 从解析后的对象中读取 `organization`。
3. 从解析后的对象中读取 `workspaces` list。
4. 筛选 workflow 为 `vcs` 的 workspace name。
5. 构造 workspace map，key 使用 workspace name。
6. 从 `kplabs-terraform-learning` workspace 中提取所有 environment variable key。
7. 从同一个 workspace 中提取 sensitive environment variable key，并生成 run summary label。

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
- `vcs_workspace_names` 只包含使用 VCS workflow 的 workspace。
- `workspace_repository` 输出 `demo-kplabs-user/kplabs-terraform-learning`。
- `aws_env_variable_keys` 输出 `AWS_ACCESS_KEY_ID`、`AWS_SECRET_ACCESS_KEY`、`AWS_REGION`。
- `sensitive_env_variable_keys` 只包含两个密钥变量。
- `run_summary_labels` 能体现 plan 成功、manual apply 等待确认、最后 discard run 的流程。

## 6. 约束

- 不要连接真实 HCP Terraform、GitHub 或 AWS。
- 不要硬编码最终输出绕过 `jsondecode()` 和 `for` 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- 环境变量必须从 `workspace.variables` 中筛选 `category == "env"` 得出。
- sensitive 变量必须从 `sensitive == true` 得出。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
