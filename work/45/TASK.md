# Terraform 实操训练 45：AWS EC2 资源行为与 meta-argument

## 1. 背景

本目录是 `work/45` 上机做题环境。你需要在当前目录内完成 Terraform 配置，不要修改 `practice/labs/45/` 中的参考实现。

核心主题：资源行为、创建、销毁、更新、替换、meta-argument、LocalStack。

## 2. 任务目标

使用 LocalStack 模拟 AWS EC2 API，通过真实 `aws_instance` 练习 Terraform 如何处理资源创建、销毁、普通更新和替换。

你需要修复 `main.tf` 中的 TODO：

- **TODO 1**：用 `for_each = var.desired_ec2_instances` 管理模拟 EC2 实例集合
- **TODO 2**：让 `aws_instance.web` 使用 `var.ami_id`
- **TODO 3**：让 `aws_instance.web` 使用 `var.instance_type`
- **TODO 4**：在 `lifecycle` 中启用 `create_before_destroy = true`
- **TODO 5**：用 `replace_triggered_by = [terraform_data.ami_rollout]` 表达 AMI rollout 触发替换

本实验只连接本地 LocalStack，不访问真实 AWS，不需要真实 AWS 凭证。

## 3. 你需要编辑的文件

- `main.tf`：完成 `aws_instance` 的 TODO 和 lifecycle meta-argument。
- `variables.tf`：阅读输入变量，理解 AMI、instance type 和实例集合。
- `outputs.tf`：阅读输出，理解验收脚本会检查哪些行为。
- `scripts/`：用于检查 LocalStack、验证结果和清理残留资源，通常不需要修改。
- `tests/`：验收测试，优先让代码满足测试，不要先改测试。

## 4. 禁止事项

- 不要连接真实 AWS。
- 不要写入真实 AWS Access Key / Secret Key。
- 不要修改 `practice/labs/45/`。
- 不要把 LocalStack 的结果说成等价于生产 AWS；它只用于本地训练 Terraform Provider 调用路径。

## 5. 验收标准

完成 TODO 后：

- `terraform fmt -check` 通过
- `terraform validate` 通过
- `terraform test` 返回 `1 passed, 0 failed`
- `terraform apply` 后，LocalStack 中可以查询到 tag `Project=tf-lab-45` 的 EC2 实例
- `scripts/verify.ps1` / `scripts/verify.sh` 能确认替换计划体现 `create_before_destroy`

## 6. 建议执行顺序

1. 启动 LocalStack。
2. 设置假 AWS 凭证和 `LOCALSTACK_ENDPOINT`。
3. 执行 `scripts/check-sandbox.*`。
4. 完成 `main.tf` 中的 TODO。
5. 执行 `terraform init`、`fmt`、`validate`、`test`。
6. 执行 `plan/apply/output/verify/destroy/clean`。

## 7. 预期输出

完成后，`terraform output` 应包含：

- `instance_ids.web`
- `instance_ami_ids.web = "ami-0123456789abcdef0"`
- `instance_types.web = "t3.micro"`
- `instance_names.web = "tf-lab-45-web"`

## 8. 常见问题

1. LocalStack 连接失败：确认容器已启动，并且 `http://localhost:4566` 可访问。
2. Provider 尝试访问真实 AWS：确认 `provider.tf` 中 endpoint 指向 LocalStack。
3. `terraform test` 失败且 `created_instances` 为空：通常是 `for_each` 仍然是 `{}`。
4. 替换计划没有体现 `create_before_destroy`：检查 lifecycle 中的 TODO 4 和 TODO 5。
5. 残留实例影响验证：执行 `terraform destroy -auto-approve` 后再运行 `scripts/clean.*`。
