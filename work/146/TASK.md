# Terraform 实操训练 146：Terraform Professional 考试环境导航建模

## 1. 背景

本目录是 `work/146` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 表达式练习。

这个 lab 会用 `data/exam_environment.json` 模拟 Terraform Professional 考试环境信息。你需要用 `jsondecode()`、`for` 表达式、过滤、map 构造和简单时间预算计算，把考试环境中的关键导航规则整理成可验证输出。

这个练习不会连接真实考试平台，也不会模拟真实考试题目。它只训练你把考试环境信息结构化：考试流程、MCQ 与 lab 的时间分配、lab 场景链接、右侧栏凭据/资源信息、允许和拒绝访问的资源、以及验证命令的重要性。

## 2. 核心主题

- `jsondecode(file(...))`：读取并解析本地 JSON mock 数据。
- list 过滤：区分 exam stage、lab scenario、allowed/denied resource。
- map 构造：按 scenario id 建立导航摘要。
- `contains()`：判断某个 lab 场景是否提供 VS Code、CLI、validation 链接。
- 简单算术：把 4 小时考试换算成分钟，并按策略分配 MCQ、lab、review 时间。

## 3. 任务目标

请在 `main.tf` 中完成八个 TODO：

1. 读取并解析 `data/exam_environment.json`。
2. 从 JSON 中读取考试总时长小时数，并换算成分钟。
3. 从 JSON 中读取 `exam_flow.stages`。
4. 输出所有考试 stage 的 name。
5. 只筛选出 `type == "lab"` 的 stage name。
6. 为每个 lab scenario 构造导航摘要，确认是否有 VS Code、CLI、validation command。
7. 从 resource policy 中分别筛选 allowed 和 denied resource name。
8. 根据 `strategy.time_split_percent` 计算 MCQ、lab、review 的分钟预算。

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
- `terraform output exam_duration_minutes` 显示 `240`。
- `terraform output stage_names` 显示从 pre exam 到 post exam survey 的完整流程。
- `terraform output lab_stage_names` 只显示 lab 场景 stage。
- `terraform output scenario_navigation_summary` 能按 scenario id 判断是否提供 VS Code、CLI 和 validation command。
- `terraform output allowed_resource_names` 与 `denied_resource_names` 能正确分类允许/拒绝访问的资源。
- `terraform output time_budget_minutes` 能给出 MCQ、lab、review 的分钟预算。

## 6. 约束

- 不要硬编码最终输出绕过 JSON 解析。
- JSON 文件路径必须基于 `path.module` 构造。
- lab 场景筛选必须使用 `type == "lab"`。
- 判断链接是否存在时使用 `contains()`。
- 时间预算必须从 `exam_duration_minutes` 和 JSON 中的百分比计算得到。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
