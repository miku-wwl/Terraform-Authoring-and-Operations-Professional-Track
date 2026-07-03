# Terraform 实操训练 30：从 JSON 中提取指定字段

## 1. 背景

本目录是 `work/30` 上机做题环境，来源于 `practice/30.md` 的实验设计。这里不是参考答案目录，你需要在当前目录内完成代码或命令练习。

核心主题：`jsondecode`、索引访问、对象数组、字段筛选

## 2. 任务目标

输出服务名 `payments`、第一个端口 `8080` 和端口数量。

你需要逐个修复 `main.tf` 中的 3 个 TODO：
- TODO 1：用 `jsondecode(file(...))` 从 `data/catalog.json` 读取服务目录
- TODO 2：用 `for` 表达式筛选 `tier == "backend"` 的服务，提取 `name` 和 `ports` 字段
- TODO 3：通过索引 `[0]` 和 `.ports` 取出第一个 backend 服务的端口列表，正确输出 `backend_ports`

## 3. 你需要编辑的文件

- `main.tf`：主要练习文件，包含 3 个 TODO 需要你补齐。
- `data/`：服务目录 JSON 数据，不需要修改。
- `tests/`：验收测试，优先让代码满足断言，不要先改测试。

## 4. 约束

- 不要修改 `practice/labs/30/`。
- 不要创建真实 AWS 资源。
- 文档、注释、报告使用中文；命令、参数、文件名可以保留英文。
- 不要把参考实现直接复制进来，先根据测试和题目自己完成。

## 5. 验收命令

请先阅读 `README.md` 中的 Docker 命令进入容器，再执行对应验收流程。

## 6. 预期输出

`terraform test` 返回 `1 passed, 0 failed`，并能完成本节要求的 plan/apply/output/destroy 或专项验证。

## 7. 常见问题

1. `terraform test` 失败：先读断言错误，它通常会指出缺少哪个命令、参数或输出。
2. `terraform validate` 失败：先检查 HCL 语法、变量名和输出名是否写错。
3. provider 下载失败：重新执行 `terraform init -input=false`。
4. 格式检查失败：运行 `terraform fmt` 后再验证。
5. 想重做实验：删除当前目录下 `.terraform`、`*.tfstate*`、`tfplan`、`plan.json`、`generated.tf`、`output/` 后重新开始。