# Terraform 实操训练 99：Moved Block 将旧资源迁移到 Module

## 1. 背景

本目录是 `work/99` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform moved block 迁移练习。

在真实组织里，经常会出现这种情况：早期团队用一个普通 `resource` 直接创建了资源；几个月或几年后，团队开始推广 module，希望以后所有资源都通过标准 module 管理。此时不能直接删除旧 resource 再新建 module，否则 Terraform 可能计划 destroy 旧资源、create 新资源。

`moved` block 的作用是告诉 Terraform：旧 state 地址已经迁移到新地址。这样 Terraform 可以保留同一个真实资源，只把 Terraform state 中的地址从旧配置迁移到 module 内部资源地址。

本 lab 不会真实创建 S3 bucket。我们用 `terraform_data` 模拟一个已经存在的 legacy bucket，以及一个组织内部的 S3 bucket module。你要完成从旧资源地址到 module 内部资源地址的迁移声明。

## 2. 核心主题

- 旧地址：`from` 必须指向旧资源地址，例如 `terraform_data.legacy_bucket`。
- 新地址：`to` 必须指向 module 内部的具体资源地址，例如 `module.s3_bucket.terraform_data.bucket`。
- 不能只写 module 地址：`to = module.s3_bucket` 是错误的，因为 moved block 两边必须都是资源地址，或者两边都为 module 地址。
- 迁移时保持名称一致：module 输入的 bucket 名称应与旧资源名称一致，避免 Terraform 试图创建另一个不同资源。
- 公共 module 可能附带额外配置：真实迁移时要认真审 plan，确认没有意外 destroy 或大范围修改。

## 3. 任务目标

请在 `main.tf` 中完成四个 TODO：

1. 保持 legacy bucket 的原始名称：`kplabs-moved-module-practical-099`。
2. 在 `module "s3_bucket"` 调用里，把 `bucket` 参数设置为 legacy bucket 的同一个名称。
3. 添加 `moved` block，`from` 指向旧资源地址：`terraform_data.legacy_bucket`。
4. 添加 `moved` block，`to` 指向 module 内部具体资源地址：`module.s3_bucket.terraform_data.bucket`。

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
- `terraform output module_bucket_config` 中的 bucket 为 `kplabs-moved-module-practical-099`。
- `main.tf` 中存在 `moved` block。
- `moved.from` 指向 `terraform_data.legacy_bucket`。
- `moved.to` 指向 `module.s3_bucket.terraform_data.bucket`。
- `main.tf` 不应保留 active 的 `resource "terraform_data" "legacy_bucket"` 块。

## 6. 约束

- 不要真实创建 AWS S3 bucket。
- 不要把 `to` 写成 `module.s3_bucket`，必须写到 module 内部具体资源地址。
- 不要把 bucket 名改成另一个新名称；迁移练习的关键是保留旧资源身份。
- 不要恢复 active 的 legacy resource block；迁移后 root module 应通过 module 管理资源。
- 不要把测试期望值硬编码到 output 里绕过 module 调用。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
