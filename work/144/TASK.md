# Terraform 实操训练 144：HashiCorp 考试预约规则建模

## 1. 背景

本目录是 `work/144` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 本地数据建模练习。

本 lab 根据 HashiCorp 认证考试预约规则视频内容，把考试前需要确认的规则整理成一份本地 JSON mock 数据，然后使用 Terraform 的 `jsondecode()`、object、list、map 和 `for` 表达式输出一份结构化 checklist。

## 2. 核心主题

- `file()`：读取当前 module 下的 JSON 文件。
- `jsondecode()`：把 JSON 字符串转换成 Terraform object。
- object 建模：把证件、系统、行为、预约规则整理成固定结构。
- list 读取：从 JSON 中读取物理空间规则和考试前 checklist。
- map/list 处理：把风险控制项转换成便于阅读的规则标签。

## 3. 任务目标

请在 `main.tf` 中完成九个 TODO：

1. 用 `jsondecode(file("${path.module}/data/exam_rules.json"))` 读取并解析 JSON。
2. 读取考试门户登录方式。
3. 构造 `id_requirement` 对象。
4. 读取系统要求列表。
5. 读取物理空间规则列表。
6. 构造 `behavior_rules` 对象。
7. 读取取消或改期的最少提前小时数。
8. 用 `for` 表达式把风险控制 map 转换成 `key: value` 标签列表。
9. 读取考试前 checklist 列表。

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
- `terraform output portal_login_method` 显示 `GitHub`。
- `terraform output id_requirement` 显示 physical ID、禁止 digital ID、姓名必须匹配、至少提前 3 个工作日申请改名。
- `terraform output system_rules` 显示 Chrome、preflight check、single monitor、关闭通知等系统要求。
- `terraform output physical_space_rules` 显示房间、桌面、噪音和电子设备要求。
- `terraform output behavior_rules` 显示考试过程中不能随意离席、不能读题出声、饮料容器要求等。
- `terraform output risk_control_labels` 显示风险项和对应缓解动作。

## 6. 约束

- 不要硬编码输出绕过 `jsondecode()` 练习。
- JSON 文件路径必须基于 `path.module` 构造。
- 风险控制标签必须通过 `for` 表达式从 `risk_controls` map 生成。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
