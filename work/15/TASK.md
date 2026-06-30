# Terraform 实操训练 15：Checkov 扫描选项

## 1. 背景

本目录是 `work/15` 上机做题环境，来源于 `practice/15.md` 的实验设计。这里不是参考答案目录，你需要在当前目录内完成代码或命令练习。

核心主题：Checkov `-f`、`-d`、`--check`、`--skip-check`

## 2. 任务目标

Checkov 能识别 Kubernetes Pod 的不安全配置，并展示如何缩小或跳过规则范围。

你需要根据题目目标修复起始文件中的 `TODO`、不完整命令或故意错误配置，让实验通过验收。

## 3. 你需要编辑的文件

- `main.tf`：主要练习文件，包含需要你补齐或修复的 Terraform 配置。
- `outputs.tf`：如果存在，检查输出是否满足测试断言。
- `variables.tf`：如果存在，检查变量、默认值和校验规则。
- `templates/`：如果存在，检查模板是否能渲染出目标内容。
- `tests/`：验收测试，建议先不要修改，优先让代码满足测试。

## 4. 约束

- 不要修改 `practice/labs/15/`。
- 不要创建真实 AWS 资源。
- 文档、注释、报告使用中文；命令、参数、文件名可以保留英文。
- 不要把参考实现直接复制进来，先根据测试和题目自己完成。

## 5. 验收命令

请先阅读 `README.md` 中的 Docker 命令进入容器，再执行对应验收流程。

## 6. 预期输出

Checkov 扫描命令返回结果，并能看到与本节目标相关的检查输出。

## 7. 常见问题

1. `terraform test` 失败：先读断言错误，它通常会指出缺少哪个命令、参数或输出。
2. `terraform validate` 失败：先检查 HCL 语法、变量名和输出名是否写错。
3. provider 下载失败：重新执行 `terraform init -input=false`。
4. 格式检查失败：运行 `terraform fmt` 后再验证。
5. 想重做实验：删除当前目录下 `.terraform`、`*.tfstate*`、`tfplan`、`plan.json`、`output/` 后重新开始。