# Terraform 实操训练 85：Module 调用与 EC2 蓝图封装

## 1. 背景

本目录是 `work/85` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform module 调用练习。

视频中演示的是在 Terraform Registry 里查找 AWS EC2 module，通过 `module` block 调用已有模块，然后执行 `terraform init` 下载 module 代码和 provider。真实环境中，这类 module 可以减少重复代码，并把组织的标准化、安全基线和最佳实践封装起来。

这个 lab 不会创建真实 AWS EC2，避免账号、凭据和费用问题。我们用 `modules/ec2_instance_blueprint` 这个本地模块模拟 EC2 instance 的配置输出，重点训练 module 的调用方式。

## 2. 核心主题

- `module` block：调用一个 Terraform module。
- `source`：指定 module 来源，本 lab 使用本地路径，真实项目也可以使用 Terraform Registry 地址。
- module input variables：把 root module 的 local 值传入 child module。
- module outputs：通过 `module.<name>.<output>` 读取 child module 的输出。
- module 抽象：root module 只关心输入和输出，不直接关心内部实现。
- 成本意识：真实 EC2 module 可以 `apply`，但测试结束后必须 `destroy`。

## 3. 任务目标

请在 `main.tf` 中完成六个 TODO：

1. 设置 EC2 蓝图名称为 `training-web-01`。
2. 设置模拟 AMI ID 为 `ami-0123456789abcdef0`。
3. 设置 instance type 为 `t3.micro`。
4. 明确关闭 public IP：`enable_public_ip = false`。
5. 构造标准 tags map，包含：
   - `Environment = "dev"`
   - `Owner = "platform"`
   - `ManagedBy = "terraform"`
6. 把 root module 的 `ec2_instance_config` output 改为读取 `module.ec2_instance.instance_config`。

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
- `terraform output ec2_instance_config` 显示由 child module 统一生成的 EC2 蓝图对象。
- 输出中的 name 为 `training-web-01`。
- 输出中的 AMI ID 为 `ami-0123456789abcdef0`。
- 输出中的 instance type 为 `t3.micro`。
- 输出中的 public IP 为 `false`。
- 输出中的 tags 包含 `Environment`、`Owner`、`ManagedBy` 三个标准标签。

## 6. 约束

- 不要修改 `modules/` 下的 child module 实现。
- 不要硬编码 output 绕过 `module.ec2_instance.instance_config`。
- 本 lab 不要求真实 AWS credentials。
- 本 lab 不创建真实 EC2 instance。
- 如果你把这个思路迁移到真实 Registry AWS EC2 module，必须先确认 region、AMI、instance type、成本和销毁流程。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
