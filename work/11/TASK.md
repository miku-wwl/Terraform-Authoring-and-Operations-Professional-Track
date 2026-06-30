# Terraform 实操训练 11：File System Mirror 概念

## 1. 背景

本目录是 `work/11` 上机做题环境，来源于 `practice/11.md` 的实验设计。这里不是参考答案目录，你需要在当前目录内完成代码或命令练习。

核心主题：file system mirror、离线 provider 安装、`TF_CLI_CONFIG_FILE`

## 2. 任务目标

`terraform init` 从 mirror 安装 `hashicorp/local`，并成功完成本地文件实验。

你需要根据题目目标修复起始文件中的 `TODO`、不完整命令或故意错误配置，让实验通过验收。

## 3. 你需要编辑的文件

- `main.tf`：主要练习文件，包含需要你补齐或修复的 Terraform 配置。
- `outputs.tf`：如果存在，检查输出是否满足测试断言。
- `variables.tf`：如果存在，检查变量、默认值和校验规则。
- `templates/`：如果存在，检查模板是否能渲染出目标内容。
- `tests/`：验收测试，建议先不要修改，优先让代码满足测试。

## 4. 约束

- 不要修改 `practice/labs/11/`。
- 不要创建真实 AWS 资源。
- 文档、注释、报告使用中文；命令、参数、文件名可以保留英文。
- 不要把参考实现直接复制进来，先根据测试和题目自己完成。

## 5. 验收命令

请先阅读 `README.md` 中的 Docker 命令进入容器，再执行对应验收流程。

## 6. 预期输出

`terraform test` 返回 `1 passed, 0 failed`，并能完成 plan/apply/output/destroy。

## 7. 常见问题

1. `terraform test` 失败：先读断言错误，它通常会指出缺少哪个命令、参数或输出。
2. `terraform validate` 失败：先检查 HCL 语法、变量名和输出名是否写错。
3. provider 下载失败：重新执行 `terraform init -input=false`。
4. 格式检查失败：运行 `terraform fmt` 后再验证。
5. 想重做实验：删除当前目录下 `.terraform`、`*.tfstate*`、`tfplan`、`plan.json`、`output/` 后重新开始。