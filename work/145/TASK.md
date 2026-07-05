# Terraform 实操训练 145：Terraform Professional 考试预约流程建模

## 1. 背景

本目录是 `work/145` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 数据处理练习。

本节对应 Terraform Professional 考试预约流程：从官方 HashiCorp 页面进入考试平台，使用 GitHub 登录，确认姓名与政府 ID 一致，做系统兼容性检查，选择考试、预约日期时间、处理 accommodation、支付或使用 voucher，并在考试当天提前进入完成监考检查。

为了避免真实访问考试平台，本 lab 使用 `data/terraform-professional-booking.json` 作为 mock 数据。

## 2. 核心主题

- `file()`：读取当前 module 下的 mock JSON 文件。
- `jsondecode()`：把考试平台、考试、accommodation、预约步骤转换成 Terraform 值。
- `one()`：从考试列表中选出唯一的 professional exam。
- `for` 表达式：提取步骤名称、兼容性检查项、支付方式。
- `if` 过滤：筛选有额外时间的 accommodation。
- map 构造：把 booking steps 和 payment options 转换成按 key 索引的 map。
- 基于数据计算：把 240 分钟基础时长和 30 分钟 extra time 合成 270 分钟。

## 3. 任务目标

请在 `main.tf` 中完成十四个 TODO：

1. 用 `jsondecode(file("${path.module}/data/terraform-professional-booking.json"))` 读取并解析 mock 数据。
2. 从解析结果中读取 `portal`。
3. 从解析结果中读取 `exams` list。
4. 从解析结果中读取 `system_compatibility_checks` list。
5. 从解析结果中读取 `accommodations` list。
6. 从解析结果中读取 `booking_steps` list。
7. 从解析结果中读取 `payment_options` list。
8. 从解析结果中读取 `exam_day` object。
9. 用 `one()` 和 `for` 筛选出 `level == "professional"` 的考试对象。
10. 用 `for` 表达式输出所有 booking step 名称。
11. 构造按 `order` 索引的 booking step map。
12. 筛选 `extra_minutes > 0` 的 accommodation 名称。
13. 计算 professional exam 加 extra time 后的总时长。
14. 构造支付方式 map，并判断是否满足考试日准备要求。

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
- `terraform output login_provider` 显示 `GitHub`。
- `terraform output professional_exam_name` 显示 Terraform Professional 考试名称。
- `terraform output professional_base_duration_minutes` 显示 `240`。
- `terraform output professional_duration_with_extra_time_minutes` 显示 `270`。
- `terraform output extra_time_accommodation_names` 只包含英语非第一语言 extra time。
- `terraform output booking_step_names` 按预约流程顺序显示 11 个步骤。
- `terraform output exam_day_ready` 显示 `true`。

## 6. 约束

- 不要硬编码输出绕过 `jsondecode()` 和 `for` 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- professional exam 必须从 `local.exams` 中筛选出来，不要手写一个 professional exam 对象。
- extra time accommodation 必须通过 `accommodation.extra_minutes > 0` 筛选。
- booking step map 的 key 使用 `tostring(step.order)`，避免 number key 与 string key 混淆。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
