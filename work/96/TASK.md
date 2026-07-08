# Terraform 实操训练 96：Module Outputs 与跨资源引用

## 1. 背景

本目录是 `work/96` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform module output 练习。

前面你已经创建了一个本地 EC2 module，并学习了如何通过变量让调用方传入 AMI、instance type、region。现在的问题是：root module 里还有别的资源需要使用 child module 创建出来的结果，例如把 Elastic IP 关联到 EC2 instance。

在 Terraform 里，调用方不能直接读取 child module 内部的 resource 属性。你需要先在 child module 中声明 `output`，然后在 root module 中通过 `module.<module_name>.<output_name>` 引用它。

为了避免真实 AWS 凭据依赖，本 lab 使用 `terraform_data` 模拟 EC2 instance 和 Elastic IP association，不会创建真实云资源。

## 2. 核心主题

- child module output：在 `modules/ec2` 中用 `output` 暴露调用方需要的值。
- module output reference：在 root module 中使用 `module.web_ec2.instance_id`。
- 跨资源协作：用 module 输出的 instance ID 作为 Elastic IP association 的输入。
- 封装边界：root module 不应该直接访问 child module 内部 resource，只能消费 child module 暴露的 output。

## 3. 任务目标

请完成两个文件中的 TODO：

### `modules/ec2/main.tf`

1. 把 `output "instance_id"` 的值改成 `terraform_data.ec2_instance.output.id`。
2. 保留 `output "instance_config"`，方便调用方观察 module 返回的完整模拟实例配置。

### `main.tf`

3. 在 `terraform_data.elastic_ip_association` 中，把 `instance` 改成 `module.web_ec2.instance_id`。
4. 保持 `module "web_ec2"` 的 source 为 `./modules/ec2`。
5. 不要在 root module 中硬编码 instance ID 来绕过 module output 练习。

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
- `terraform output module_instance_id` 显示 `i-0abc1234module96`。
- `terraform output elastic_ip_association` 显示 Elastic IP 已关联到 module 输出的 instance ID。
- `terraform output associated_instance_id` 与 `module_instance_id` 一致。

## 6. 约束

- 不要添加 AWS provider。
- 不要创建真实 `aws_instance` 或 `aws_eip`。
- 不要硬编码 output 绕过 module output 练习。
- root module 必须通过 `module "web_ec2"` 调用 `./modules/ec2`。
- child module 必须通过 `output "instance_id"` 暴露 instance ID。
- root module 必须通过 `module.web_ec2.instance_id` 消费该 output。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
