# Terraform 实操训练 125：模拟 HCP Terraform Variable Sets

## 1. 背景

HCP Terraform 的 Variable Set 用于集中维护可复用变量，并将它们应用到所有 workspace、指定 project，或单个 workspace。

本 lab 不连接真实 HCP Terraform。你需要读取 `data/mock.json`，使用 Terraform 表达式模拟 Variable Set 的 scope、变量分类以及 workspace override 优先级。

## 2. 核心主题

- Global scope：适用于当前及未来的所有 workspace。
- Project scope：只适用于属于指定 project 的 workspace。
- Workspace scope：只适用于指定 workspace。
- Variable category：区分 `terraform` 变量和 `env` 环境变量。
- Override precedence：workspace 中的同名变量覆盖 Variable Set 提供的值。
- Sensitive metadata：识别被标记为 sensitive 的变量。

## 3. 数据模型

`data/mock.json` 包含：

- 三个 workspace：`checkout-api`、`catalog-api`、`analytics`。
- 一个 global Variable Set。
- 一个只应用于 `commerce` project 的 Variable Set。
- 一个只应用于 `checkout-api` 的 Variable Set。
- 每个 workspace 自己的 workspace variables。

默认处理 `checkout-api`。测试还会把 `workspace_name` 改成 `analytics`，检查 scope 是否正确。

## 4. 任务目标

请在 `main.tf` 中完成十个 TODO：

1. 使用 `jsondecode(file(...))` 读取 mock 数据。
2. 根据 `var.workspace_name` 找到当前 workspace。
3. 筛选适用于当前 workspace 的 Variable Sets。
4. 展开所有适用 Variable Set 中的变量，并保留来源名称。
5. 将 Variable Set 变量转换成按 key 索引的 object。
6. 读取当前 workspace 自己定义的变量。
7. 将 workspace variables 转换成按 key 索引的 object。
8. 使用 `merge()` 生成最终有效变量，确保 workspace variable 优先。
9. 找出被 workspace 覆盖的同名 key。
10. 按 `terraform`、`env` 和 `sensitive` 分类输出最终变量。

## 5. 验收方式

```sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
```

测试包含两个 run：

- 默认 `checkout-api`：应继承 global、project 和 workspace 三层 Variable Set，并覆盖两个同名变量。
- `analytics`：应只继承 global Variable Set，并用 workspace 变量覆盖 `AWS_REGION`。

## 6. 预期结果

完成后：

- `terraform test` 返回 `2 passed, 0 failed`。
- `checkout-api` 的适用 Variable Set 为 `global-aws`、`commerce-database`、`checkout-features`。
- `checkout-api` 的 `db_write_capacity` 最终值为 `15`。
- `checkout-api` 的 `APP_LOG_LEVEL` 最终值为 `debug`。
- `analytics` 不应继承 `commerce-database` 或 `checkout-features`。
- sensitive key 应为 `AWS_ACCESS_KEY_ID`。

## 7. 约束

- 不要修改 `tests/` 来绕过测试。
- 不要硬编码最终输出。
- JSON 路径必须基于 `path.module`。
- Variable Set applicability 必须根据 scope 动态计算。
- workspace override 必须通过 `merge(variable_set_map, workspace_variable_map)` 或等价逻辑实现。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
