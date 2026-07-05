# Terraform 实操训练 91：Local Path Module Reference

## 1. 背景

本目录是 `work/91` 上机做题环境。这里不是参考答案目录，你需要完成 Terraform 本地模块路径引用练习。

前面你已经见过 Terraform module 的基础结构和简单 EC2 模块。这个 lab 会模拟一个团队目录 `teams/team-a` 调用平台团队维护的本地模块 `modules/ec2`。重点不是创建真实 AWS EC2，而是练习：当 module 和调用方在同一个仓库/工作站里时，应该如何用 local path 写 `source`。

Terraform 的本地 module source 必须以 `./` 或 `../` 开头。路径是相对于“当前写 module block 的目录”计算的，不是相对于仓库根目录随便猜。

## 2. 目录关系

```text
work/91/
├── main.tf                  # root module，用来汇总 team-a 的输出
├── modules/
│   └── ec2/                 # 平台团队维护的本地 EC2 mock module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── teams/
│   └── team-a/
│       ├── module.tf        # 你主要编辑这里
│       └── outputs.tf
└── tests/
    └── local_path_module_reference.tftest.hcl
```

从 `teams/team-a/module.tf` 所在目录出发：

1. `..` 回到 `teams/`
2. 再 `..` 回到 `work/91/`
3. 进入 `modules/ec2/`

所以正确的本地 module source 是：

```hcl
source = "../../modules/ec2"
```

## 3. 核心主题

- `module` block：业务团队通过 module block 调用平台团队提供的模块。
- `source = "../../modules/ec2"`：从 team-a 目录引用上两级的本地模块。
- `./` 与 `../`：Terraform local path module source 必须显式以当前目录或父目录开头。
- module input variables：调用方传入 instance name、AMI、type、team、environment、tags。
- module outputs：child module 把标准化后的 mock EC2 记录暴露给调用方。

## 4. 任务目标

请在 `teams/team-a/module.tf` 中完成五个 TODO：

1. 把 `local.ec2_module_source` 改成正确的本地路径字符串 `../../modules/ec2`。
2. 把 `module "team_a_ec2"` 的 `source` 改成正确的本地路径 `../../modules/ec2`。
3. 补全团队通用标签 `owner = "platform"` 和 `cost_center = "cc-team-a"`。
4. 补全 module input：`instance_name = "team-a-dev-app"`。
5. 补全 module input：`ami_id = "ami-0123456789abcdef0"`。

完成后运行 `README.md` 中的命令。

## 5. 验收方式

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

## 6. 预期结果

- `terraform test` 返回 `1 passed, 0 failed`。
- `terraform output team_a_module_source` 显示 `../../modules/ec2`。
- `terraform output team_a_instance_record` 显示由本地 `modules/ec2` 模块标准化后的 mock EC2 对象。
- mock EC2 对象包含 `instance_name`、`ami_id`、`instance_type`、`team_name`、`environment` 和合并后的 tags。

## 7. 约束

- 不要把 `source` 写成 `modules/ec2`，本地路径必须以 `./` 或 `../` 开头。
- 不要把 `source` 写成从 root module 视角看的 `./modules/ec2`，因为 module block 写在 `teams/team-a/module.tf` 里。
- 不要修改 `modules/ec2/` 下的模块实现来绕过练习。
- 不要硬编码 root output 绕过 module 调用。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
