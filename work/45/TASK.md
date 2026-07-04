# Terraform 实操训练 45：资源行为与 meta-argument

## 1. 背景

本目录是 `work/45` 上机做题环境，来源于 `practice/45.md` 的实验设计。这里不是参考答案目录，你需要在当前目录内完成代码或命令练习。

核心主题：资源行为、创建、销毁、更新、替换、meta-argument

## 2. 任务目标

用 `terraform_data` 模拟 AWS EC2 (`aws_instance`) 的资源行为：创建、销毁、原地更新和替换，并练习常见 meta-argument。

你需要根据题目目标修复起始文件中的 `TODO`，重点练习：

- **TODO 1**：将模拟 EC2 的 AMI 替换信号接到 `var.ami_id`
- **TODO 2**：记录替换策略为 `create_before_destroy`
- **TODO 3**：用 `for_each = local.desired_ec2_instances` 创建模拟 EC2 实例；新增 key 表示 create，删除 key 表示 destroy
- **TODO 4**：在 `lifecycle` 中启用 `create_before_destroy = true`
- **TODO 5**：用 `replace_triggered_by = [terraform_data.ami_rollout]` 表达 AMI rollout 会触发替换

本实验不会创建真实 AWS 资源，也不需要 AWS 凭证；它用 `terraform_data` 让你用 AWS EC2 的语境理解 Terraform 如何通过配置、state 和 meta-argument 推导资源行为。

## 3. 你需要编辑的文件

- `main.tf`：主要练习文件，包含需要你补齐或修复的 Terraform 配置。
- `input/` 或 `scripts/`：如果存在，是本实验需要的输入或辅助脚本。
- `tests/`：验收测试，建议先不要修改，优先让代码满足测试。

## 4. 约束

- 不要修改 `practice/labs/45/`。
- 不要创建真实 AWS 资源。
- Vault 实验只使用本地 dev server，不连接真实 Vault。
- 文档、注释、报告使用中文；命令、参数、文件名可以保留英文。
- 不要把参考实现直接复制进来，先根据测试和题目自己完成。

## 5. 验收命令

请先阅读 `README.md` 中的 Docker 命令进入容器，再执行对应验收流程。

## 6. 预期输出

`terraform test` 返回 `1 passed, 0 failed`，并确认模拟 EC2 实例、AMI 替换字段、tags 原地更新字段和 `lifecycle` 策略都符合预期。

## 7. 常见问题

1. `terraform test` 失败：先读断言错误，它通常会指出缺少哪个条件、参数或输出。
2. `terraform validate` 失败：先检查 HCL 语法、变量名和输出名是否写错。
3. provider 下载失败：重新执行 `terraform init -input=false`。
4. 格式检查失败：运行 `terraform fmt` 后再验证。
5. 想重做实验：删除当前目录下 `.terraform`、`*.tfstate*`、`tfplan`、`plan.json`、`output/` 后重新开始。
