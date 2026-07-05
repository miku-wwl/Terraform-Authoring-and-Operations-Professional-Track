# Terraform 实操训练 143：Terraform Professional 认证课程与考试蓝图建模

## 1. 背景

本目录是 `work/143` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform Professional 认证课程导论的数据建模练习。

课程导论强调：Terraform Associate 更偏基础概念和 MCQ，而 Terraform Authoring and Operations Professional 是更深入的、偏实操的 lab-based 认证。考试会通过远程 Linux workstation 给出多个场景和挑战，要求候选人用 Terraform 解决实际问题。课程内容按官方 exam blueprint 的主要 domain 组织，同时额外提供 AWS integration practicals 和 exam preparation 章节。

本 lab 不会连接云账号，也不会调用 HCP Terraform。它把考试信息、domain、前置要求、课程章节和 provider 支持抽象成 `data/course_overview.json`，要求你用 Terraform 本地表达式完成解析、筛选、映射和摘要输出。

## 2. 核心主题

- Terraform Professional：高级配置 authoring、Terraform workflow、模块、provider、HCP Terraform 等深度主题。
- Lab-based exam：四小时、online proctored、远程 Linux workstation、以实践挑战为主。
- Prerequisites：Terraform 基础、推荐 Associate 或等效知识、Linux CLI、YAML/JSON/CSV 基础。
- Exam domains：六个官方主 domain；HCP Terraform domain 更偏 MCQ，其余 domain 更偏 lab challenge。
- Cloud provider：当前课程与考试实操以 AWS provider 为主；未来云 provider 支持变化时，核心 blueprint 仍然类似。
- Terraform 数据处理：`jsondecode()`、`file()`、`for` 表达式、map 构造、list 过滤、`one()`、`contains()`。

## 3. 任务目标

请在 `main.tf` 中完成十个 TODO：

1. 用 `jsondecode(file("${path.module}/data/course_overview.json"))` 读取并解析 mock 数据。
2. 从解析后的对象中读取 `exam` object。
3. 构造 `primary_domain_titles`，按顺序列出六个官方主 domain title。
4. 构造 `lab_based_domain_titles`，筛选 assessment 为 `lab` 的主 domain title。
5. 构造 `mcq_domain_titles`，筛选 assessment 为 `mcq` 的主 domain title。
6. 构造 `prerequisite_names`，列出所有 prerequisite name。
7. 构造 `required_file_formats`，只保留 type 为 `file_format` 的 prerequisite name。
8. 构造 `course_sections_by_number`，把课程章节按 section number 转成 map。
9. 构造 `cloud_provider_summary`，总结当前 supported provider、future provider 和 provider-change 规则。
10. 构造 `professional_exam_summary`，总结 exam level、format、duration、remote workstation OS、main challenge style。

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
- `terraform output primary_domain_titles` 显示六个官方主 domain。
- `terraform output lab_based_domain_titles` 排除 HCP Terraform domain。
- `terraform output mcq_domain_titles` 只显示 HCP Terraform domain。
- `terraform output required_file_formats` 显示 YAML、JSON、CSV。
- `terraform output course_sections_by_number` 包含 7 = AWS Integration Practicals，8 = Exam Preparation。
- `terraform output professional_exam_summary` 显示 professional、lab-based、4 hours、linux、scenario challenges 等关键信息。

## 6. 约束

- 不要硬编码输出绕过 `jsondecode()`、`for` 表达式和筛选练习。
- JSON 文件路径必须基于 `path.module` 构造。
- 本 lab 只是对课程导论和考试蓝图做本地数据建模，不代表实时认证政策或实时考试页面。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
