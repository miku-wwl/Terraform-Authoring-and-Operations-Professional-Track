# Terraform 实操训练 94：给 Module 添加变量并由调用方覆盖

## 1. 背景

本目录是 `work/94` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform module 变量练习。

前面的 module 写法如果把 AMI、instance type、region 直接硬编码在 module 里面，调用方就无法根据不同团队、不同环境覆盖这些值。生产环境中，module 通常应该暴露变量，让调用方传入自己的值。

本 lab 使用 `modules/ec2` 作为一个简化的 EC2 module。它不会创建真实 EC2，只会用 `terraform_data` 保存你传入的配置，方便你观察 module input 如何流到 output。

## 2. 核心主题

- 在 child module 中声明 `variable`。
- 在 module 内部用 `var.<name>` 替换硬编码值。
- 在 root module 中通过 `module` block 传入变量值。
- 用 `terraform plan` / `terraform test` 验证调用方的 override 是否生效。

## 3. 任务目标

请完成以下 TODO：

1. 在 `modules/ec2/main.tf` 中，把 hardcoded AMI 改成 `var.ami`。
2. 在 `modules/ec2/main.tf` 中，把 hardcoded instance type 改成 `var.instance_type`。
3. 在 `modules/ec2/main.tf` 中，把 hardcoded region 改成 `var.region`。
4. 在根目录 `main.tf` 的 `module "team_app"` 中传入：
   - `ami = "ami-0123456789abcdef0"`
   - `instance_type = "t2.micro"`
   - `region = "ap-south-1"`

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
- `terraform output team_instance_ami` 显示 `ami-0123456789abcdef0`。
- `terraform output team_instance_type` 显示 `t2.micro`。
- `terraform output team_region` 显示 `ap-south-1`。
- `terraform output team_instance_config` 中的三个值都来自 root module 的 override，而不是 module 内部的 hardcoded fallback。

## 6. 约束

- 不要添加 AWS provider。
- 不要创建真实 `aws_instance`。
- 不要硬编码 output 绕过 module 变量练习。
- root module 必须通过 `module "team_app"` 调用 `./modules/ec2`。
- child module 内部必须使用 `var.ami`、`var.instance_type`、`var.region`。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
