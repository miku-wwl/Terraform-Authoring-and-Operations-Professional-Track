# Terraform 实操训练 148：Terraform Professional 高频场景速查建模

## 1. 背景

本目录是 `work/148` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform Professional 考试高频场景的数据处理练习。

本节来自考试重点指针汇总：modules、moved block、lifecycle、provider alias、configuration aliases、data sources、S3 remote state、IAM、AWS provider credentials、default tags、文件 decode、for_each、S3 force_destroy、security group rules、import block、`-generate-config-out` 和 generated config 冲突处理。

这个 lab 不连接 AWS，也不真的执行 import。你需要把 `data/exam_pointers.json` 里的考试场景 mock 数据解码出来，再用 Terraform 表达式整理成可验证的速查索引。

## 2. 核心主题

- `jsondecode(file(...))`：读取考试场景 JSON mock 数据。
- `{ for ... : key => value }`：把 topic list 转成按 id 索引的 map。
- `for` + `if`：筛选高优先级 topic、模块重构 topic、需要 filter 的 data source。
- `contains()`：判断 topic skills 是否包含 `moved_block`。
- provider alias workflow：按 JSON 中的顺序输出 root module 与 child module 的协作步骤。
- import workflow：为不同 AWS resource type 生成 import ID 类型速查表。
- generated config conflict：识别 `terraform plan -generate-config-out` 后需要人工清理的冲突参数。

## 3. 任务目标

请在 `main.tf` 中完成八个 TODO：

1. 用 `jsondecode(file("${path.module}/data/exam_pointers.json"))` 读取并解析 JSON。
2. 从解析后的对象中读取 `topics` list。
3. 构造 `topic_map`，key 为 topic id。
4. 找出 priority 大于等于 5 的 topic id。
5. 找出包含 `moved_block` skill 的 module refactor topic id。
6. 按顺序输出 provider alias workflow action。
7. 找出需要 filter 的 AWS data source name。
8. 构造 import ID 类型速查表，并找出 generated config 中有 conflicting arguments 的资源。

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
- `terraform output high_priority_topic_ids` 显示考试高优先级 topic。
- `terraform output module_refactor_topic_ids` 显示两个 moved block 模块重构场景。
- `terraform output provider_alias_workflow_actions` 显示 provider alias / configuration aliases 的完整传递顺序。
- `terraform output data_sources_requiring_filters` 显示 `aws_ami` 和 `aws_subnet`。
- `terraform output import_id_by_resource` 显示 EC2、IAM policy、security group 对应的 import ID 类型。
- `terraform output resources_with_generated_config_conflicts` 显示需要清理 generated config 冲突参数的资源。

## 6. 约束

- 不要硬编码输出绕过 JSON decode 和 for 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- 高优先级 topic 使用 `topic.priority >= 5` 判断。
- 模块重构 topic 使用 `topic.category == "modules"` 并结合 `contains(topic.skills, "moved_block")` 判断。
- 筛选 data source 时使用 `source.requires_filters`。
- import address 推荐使用 `"${target.resource_type}.${target.resource_name}"` 拼接。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
