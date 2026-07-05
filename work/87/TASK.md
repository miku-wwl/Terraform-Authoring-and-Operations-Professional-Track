# Terraform 实操训练 87：选择合适的 Terraform Registry Module

## 1. 背景

本目录是 `work/87` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform module 选择逻辑练习。

真实项目里，同一个基础设施对象通常会有很多公开 module 可选，例如 EC2、IAM、VPC 等。不能只看到一个 module 能用就直接引用，更不能随便试一个来源不清、长期不维护、文档缺失的 module。

这个 lab 使用 `data/module_candidates.json` 模拟 Terraform Registry 和 GitHub 上能看到的一组 module 信号，然后用 Terraform 表达式把候选 module 分类出来。

## 2. 核心主题

- `jsondecode(file(...))`：读取 mock module 候选数据。
- `for` 过滤：筛选 EC2 module、trusted module、review required module。
- map 构造：把 trusted module 按 name 建成 map，方便后续引用。
- 条件表达式：把 module 标记成 `trusted`、`review`、`usable`。
- `try()`：从候选列表中安全选择推荐 module，避免空列表直接报错。

## 3. 任务目标

请在 `main.tf` 中完成七个 TODO：

1. 用 `jsondecode(file("${path.module}/data/module_candidates.json"))` 读取并解析 JSON。
2. 从解析后的对象中读取 `modules` list。
3. 筛选所有 `service == "ec2"` 的 module name。
4. 筛选 trusted module，并构造按 name 索引的 map。
5. 筛选需要 avoid 或手工 source review 的 module name。
6. 生成每个 module 的质量标签，格式为 `module_name:trusted|review|usable`。
7. 从 trusted EC2 module 中选择推荐 module name。

## 4. 判断规则

本 lab 采用下面的简化规则。真实工作中还要结合公司安全要求、provider 版本、license、内部平台标准等一起看。

### trusted module

同时满足：

- `downloads >= 100000`
- `contributors >= 5`
- `open_issues <= 10`
- `has_documentation == true`
- `version_count >= 3`
- `source_review_required == false`

### review required module

满足任意一个：

- `source_review_required == true`
- `contributors <= 1`
- `has_documentation == false`
- `version_count <= 1`
- `downloads < 10000`

### usable module

既不是 trusted，也不是 review required 的 module。

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
- `terraform output ec2_module_names` 显示四个 EC2 module。
- `terraform output trusted_module_names` 显示两个 trusted module。
- `terraform output review_required_module_names` 显示三个需要 review/avoid 的 module。
- `terraform output module_quality_labels` 显示六个 module 的分类标签。
- `terraform output recommended_ec2_module_name` 推荐 `terraform-aws-modules/ec2-instance/aws`。

## 7. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要硬编码输出绕过 JSON 数据和 `for` 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- trusted/review 判断必须按照本任务给出的规则实现。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
