# Terraform 实操训练 81：Terraform test 文件与 run block 基础

## 1. 背景

本目录是 `work/81` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform test 基础工作流练习。

这个 lab 会从 `data/terraform-test-workflow.json` 读取一组 Terraform test 相关的 mock 数据，用 `jsondecode()` 转成 Terraform 值，然后用 `for` 表达式识别哪些测试文件会被 Terraform 自动发现、哪些 run block 是 plan 阶段、哪些是 apply 阶段。

## 2. 核心主题

- Terraform test 文件扩展名：`.tftest.hcl` 和 `.tftest.json`。
- test 文件位置：root module 目录或 root module 下的 `tests/` 目录。
- `run` block：每个 test 文件可以包含一个或多个 `run` block。
- `command = plan`：让测试停留在 plan 阶段，不创建真实资源。
- 默认行为：未显式指定 `command` 时，`terraform test` 默认执行 apply 风格的测试。
- 不合规文件名或目录名：例如 `demo.tf`、`tests_wrong/demo.tftest.hcl` 不会按预期被发现。

## 3. 任务目标

请在 `main.tf` 中完成八个 TODO：

1. 用 `jsondecode(file("${path.module}/data/terraform-test-workflow.json"))` 读取并解析 JSON。
2. 从解析后的对象中读取 `candidate_files` list。
3. 从解析后的对象中读取 `run_blocks` list。
4. 筛选 Terraform test 会自动发现的测试文件名。
5. 筛选因为扩展名或目录错误而不会被发现的文件名。
6. 筛选显式 `command = plan` 的 run block 名称。
7. 筛选默认 apply 行为的 run block 名称。
8. 构造 test file summary map，key 为文件名，value 保留 `location`、`extension`、`discovered`。

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
- `terraform output valid_test_file_names` 显示三个会被发现的测试文件。
- `terraform output ignored_test_file_names` 显示三个不会被发现的文件。
- `terraform output plan_stage_run_names` 显示两个 plan 阶段 run block。
- `terraform output apply_stage_run_names` 显示两个默认 apply 阶段 run block。
- `terraform output test_file_summary_by_name` 显示按文件名索引的测试文件摘要。

## 6. 约束

- 不要硬编码最终输出绕过 `jsondecode()` 和 `for` 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- 筛选 discovered 文件时，必须使用 JSON 中的 `discovered` 字段。
- 筛选 plan 阶段 run block 时，必须使用 `run.command == "plan"`。
- 筛选默认 apply 阶段 run block 时，必须使用 `run.command == "apply"`。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
