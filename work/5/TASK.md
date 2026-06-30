# 第 5 节上机实验：Terraform 自动化环境 CLI 工作流

## 1. 背景

平台团队正在把 Terraform 从手工执行迁移到 CI/CD。过去工程师在本地运行 `terraform init`、`terraform plan`、`terraform apply`，可以人工输入变量、确认 `yes`、临时读日志；但自动化 runner 没有交互终端，如果命令等待输入，流水线就会卡住。

本实验用 `local_file` 在本地模拟流水线产物，不创建 AWS 资源。你需要把起始代码改造成适合自动化环境运行的 Terraform 配置。

## 2. 任务目标

你需要完成一个本地 Terraform 配置，让它生成两个文件：

- 发布清单：`output/dev-payments-api-release.json`
- 审批记录：`output/dev-payments-api-approval.txt`

同时，你需要让配置中的流水线命令体现这些自动化要求：

- `terraform init -input=false`
- `terraform plan -input=false -no-color -out=tfplan`
- `terraform apply -auto-approve tfplan`
- `apply` 必须使用已经保存并审查过的 plan 文件

## 3. 你需要编辑的文件

- `main.tf`：修复 `local.pipeline_commands` 中不适合 CI/CD 的 Terraform 命令。
- `variables.tf`：补齐变量校验规则，让输入更接近生产环境要求。
- `outputs.tf`：检查输出是否能帮助验证实验结果。
- `templates/approval-note.tftpl`：确认审批记录中清楚展示 plan/apply 命令。

测试文件 `tests/automation_workflow.tftest.hcl` 已经准备好，建议不要先改测试。先让代码满足测试。

## 4. 约束

- 不要创建任何 AWS 资源。
- 不要修改 `practice/labs/5/`，那里是参考实现。
- Terraform 命令必须适合非交互式环境。
- `plan` 必须保存为 `tfplan`。
- `apply` 必须使用保存后的 `tfplan`。
- 文档、注释、输出给人的说明都使用中文；命令、参数、文件名可以保留英文。

## 5. 验收命令

在 Docker 容器内执行：

```sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

最终验证时会使用更严格的格式检查：

```sh
terraform fmt -check
```

## 6. 预期输出

`terraform test` 应返回：

```text
1 passed, 0 failed
```

`terraform plan` 应显示：

```text
Plan: 2 to add, 0 to change, 0 to destroy.
```

`terraform output` 应包含：

```text
generated_files = [
  "./output/dev-payments-api-release.json",
  "./output/dev-payments-api-approval.txt",
]
```

## 7. 常见问题

1. `terraform test` 失败：先看失败断言，它通常会告诉你缺少哪个自动化参数。
2. `terraform plan` 里有颜色码：确认命令文本中包含 `-no-color`。
3. `apply` 没用保存计划：确认命令文本是 `terraform apply -auto-approve tfplan`。
4. 格式检查失败：运行 `terraform fmt` 后再验证。
5. 想重做实验：删除 `work/5/.terraform`、`work/5/output`、`work/5/*.tfstate*`、`work/5/tfplan` 后重新开始。

