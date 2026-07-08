# Terraform 实操训练 98：标准 Module Structure

## 1. 背景

本目录是 `work/98` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform module 结构检查练习。

本节主题来自标准 module 结构：一个可复用 module 至少应该清楚地拆分出 `README.md`、`main.tf`、`variables.tf`、`outputs.tf`。根据需要还可以增加 `versions.tf`、`examples/`、`LICENSE` 等文件。

这个 lab 会让你用 Terraform 本地函数检查 `modules/ec2` 是否符合最小推荐结构，并根据一个 mock 架构文件推导出应该拆分成多个小 module，而不是把 Route53、VPC、EC2、Database、S3、IAM 全部塞进一个巨大 module。

## 2. 核心主题

- 标准 module 最小结构：`README.md`、`main.tf`、`variables.tf`、`outputs.tf`。
- `versions.tf`：常用于集中声明 Terraform 版本和 provider 版本约束。
- `fileset()`：读取 module 目录下的文件列表。
- `setsubtract()`：检查必需文件是否缺失。
- `jsondecode(file(...))`：读取 mock 架构需求。
- module 边界设计：按服务职责拆分 module，避免 monolithic module。

## 3. 任务目标

请在 `main.tf` 中完成七个 TODO：

1. 用 `jsondecode(file("${path.module}/data/module_architecture.json"))` 读取并解析架构 mock 数据。
2. 从解析后的对象中读取 `requested_architecture.services`。
3. 定义标准 module 的最小推荐文件集合：`README.md`、`main.tf`、`variables.tf`、`outputs.tf`。
4. 用 `fileset("${path.module}/modules/ec2", "*")` 检测 `modules/ec2` 目录中的文件。
5. 用 `setsubtract()` 计算 `modules/ec2` 缺失了哪些最小推荐文件。
6. 从 services 中提取去重后的 module boundary，并按字母排序。
7. 构造 module catalog：key 是 module boundary，value 是属于该 boundary 的 service name list。

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
- `terraform output ec2_module_files` 能看到 `README.md`、`main.tf`、`variables.tf`、`outputs.tf`、`versions.tf`。
- `terraform output missing_required_files` 应为空集合。
- `terraform output module_boundaries` 应显示多个职责边界，而不是一个大而全 module。
- `terraform output module_catalog` 能显示每个 module boundary 应管理哪些 service。

## 6. 约束

- 不要删除 `modules/ec2` 下已经准备好的 module 文件。
- 不要把所有服务合并成一个 `all_in_one` 或 `monolith` module。
- 不要硬编码输出绕过 `fileset()`、`jsondecode()` 和 `for` 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
