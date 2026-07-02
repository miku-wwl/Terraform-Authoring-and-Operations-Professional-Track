# Terraform 实操训练 7：`-input=false` 与非交互式失败

## 1. 背景

本目录是 `work/7` 上机做题环境，来源于 `practice/7.md` 的实验设计。这里不是参考答案目录，你需要在当前目录内完成代码或命令练习。

核心主题：`-input=false`、必填变量、CI/CD 快速失败

## 2. 任务目标

生成 `output/ci-artifact.txt`，并且测试确认命令链包含 `-input=false`。

本题训练的是 CI/CD 中的非交互式失败：不要依赖人工输入变量，也不要依赖自动加载的 `terraform.tfvars`。流水线命令必须显式传入必填变量。

## 3. 你需要编辑的文件

- `main.tf`：修复 `local.automation_commands`，把命令改成非交互式命令。
- `variables.tf`：阅读 `artifact_name` 为什么没有默认值，它模拟 CI/CD 必须显式传参。
- `outputs.tf`：检查 `artifact_file` 是否能帮助确认产物路径。
- `tests/input_false.tftest.hcl`：验收测试，建议不要修改，优先让代码满足测试。

你需要在 `main.tf` 中确认命令链包含：

```hcl
"terraform init -input=false"
"terraform plan -input=false -var artifact_name=ci-artifact.txt -out=tfplan"
"terraform apply -auto-approve tfplan"
```

## 4. 约束

- 不要修改 `practice/labs/7/`。
- 不要创建真实 AWS 资源。
- 文档、注释、报告使用中文；命令、参数、文件名可以保留英文。
- 不要依赖 `terraform.tfvars` 自动加载变量；本题要求在 `plan` 命令中显式使用 `-var artifact_name=ci-artifact.txt`。

## 5. 验收命令

请先阅读 `README.md` 中的 Docker 命令进入容器，再执行对应验收流程。

## 6. 预期输出

- `terraform test` 返回 `1 passed, 0 failed`。
- `terraform apply` 后生成 `output/ci-artifact.txt`。
- `terraform output` 显示 `artifact_file = "./output/ci-artifact.txt"`。

## 7. 常见问题

1. `terraform test` 失败：先读断言错误，它通常会指出缺少哪个命令、参数或输出。
2. `terraform test` 通过但没有生成文件：这是正常的，测试使用 `command = plan`，不会执行 apply。
3. `terraform plan` 报 `No value for required variable`：说明没有显式传 `-var artifact_name=ci-artifact.txt`。
4. `terraform destroy` 报缺少变量：destroy 也需要同样传 `-var artifact_name=ci-artifact.txt`。
5. 格式检查失败：运行 `terraform fmt` 后再验证。
6. 想重做实验：删除当前目录下 `.terraform`、`*.tfstate*`、`tfplan`、`output/` 后重新开始。
