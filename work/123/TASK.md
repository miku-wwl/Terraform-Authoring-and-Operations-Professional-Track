# Terraform 实操训练 123：HCP Terraform CLI-driven Workflow 基础

## 1. 背景

本目录是 `work/123` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 HCP Terraform CLI-driven workflow 的配置练习。

HCP Terraform workspace 常见 workflow 包括：

- Version control workflow：从 Git repository 拉取代码并触发 run。
- CLI-driven workflow：代码留在本地目录，通过 Terraform CLI 发起远端 run。
- API-driven workflow：通过 API 集成触发 run。

本节重点是 CLI-driven workflow：本地工作目录通过 `terraform { cloud { ... } }` 链接到 HCP Terraform organization 和 workspace。你在本地运行 `terraform plan`、`terraform apply`、`terraform destroy`，但 plan/apply/destroy 的实际执行发生在 HCP Terraform workspace 中，输出会 streamed 回本地 CLI。

## 2. 核心主题

- `terraform { cloud { ... } }`：把本地 working directory 链接到 HCP Terraform。
- `organization`：指定 HCP Terraform organization。
- `workspaces { name = ... }`：指定要绑定的 workspace。
- 本地 CLI 发起 run：`terraform plan`、`terraform apply -auto-approve`、`terraform destroy -auto-approve`。
- 远端执行：run 在 HCP Terraform 中执行，不是在本地机器直接执行。
- Provider credentials：远端 run 需要 workspace variables 中配置云厂商凭据；只在本地配置 AWS key 并不能让远端 run 自动拿到凭据。

## 3. 任务目标

请完成下面七个 TODO：

1. 在 `hcp/cli_workflow.tf` 的 `cloud` block 中设置 organization：

   ```hcl
   organization = "my-kplabs-org"
   ```

2. 在同一个 `cloud` block 中设置 workspace：

   ```hcl
   workspaces {
     name = "remote-operation-workspace"
   }
   ```

3. 在 `provider "aws"` 中设置 region：

   ```hcl
   region = "us-east-1"
   ```

4. 在 `aws_security_group.allow_tls` 中设置资源 name：

   ```hcl
   name = "allow_tls"
   ```

5. 在 `commands/cli_driven_workflow.sh` 中保留初始化命令：

   ```sh
   terraform init -input=false
   ```

6. 在 `commands/cli_driven_workflow.sh` 中补全 plan/apply/destroy：

   ```sh
   terraform plan
   terraform apply -auto-approve
   terraform destroy -auto-approve
   ```

7. 理解这个关键点：如果真实连接 HCP Terraform，AWS 凭据应配置在 HCP Terraform workspace variables 中，而不是只依赖本地 laptop 的环境变量。

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
- `output.cloud_block_is_present` 为 `true`。
- `output.organization_is_configured` 为 `true`。
- `output.workspace_is_configured` 为 `true`。
- `output.aws_region_is_configured` 为 `true`。
- `output.security_group_is_named_allow_tls` 为 `true`。
- `output.cli_commands_are_ready` 为 `true`。

## 6. 约束

- 不要修改 `tests/` 下的测试文件。
- 不要把 `hcp/cli_workflow.tf` 移到根目录；否则可能触发真实 cloud backend 初始化。
- `organization` 必须使用 `my-kplabs-org`。
- workspace name 必须使用 `remote-operation-workspace`。
- AWS region 必须使用 `us-east-1`。
- Security Group 的 Terraform resource address 必须保持 `aws_security_group.allow_tls`。
- 命令文件必须保留 `terraform init -input=false`，并补全 plan/apply/destroy。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
