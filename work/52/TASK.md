# Terraform 实操训练 52：object 数据类型

## 1. 背景

本目录是 `work/52` 上机做题环境，来源于 `practice/52.md` 的实验设计。这里不是参考答案目录，你需要在当前目录内完成数据结构、表达式或模板练习。

核心主题：object 数据类型

## 2. 任务目标

完成本节 Terraform 数据建模练习，让验收测试通过，并理解输出值如何由 list、map、object、for 表达式、CSV、JSON 或 templatefile 得到。

你需要根据测试失败信息修复起始文件中的 `TODO`，让实验通过验收。

## 3. 你需要编辑的文件

- `main.tf`：主要练习文件，包含需要你补齐或修复的 Terraform 表达式。
- `data/`：如果存在，表示实验输入数据，通常不需要先修改。
- `template.tftpl`：如果存在，表示模板渲染练习的一部分。
- `tests/`：验收测试，建议先不要修改，优先让代码满足测试。

## 4. 约束

- 不要修改 `practice/labs/52/`。
- 不要创建真实 AWS 资源。
- 文档、注释、报告使用中文；命令、参数、文件名可以保留英文。
- 不要把参考实现直接复制进来，先根据测试和题目自己完成。

## 5. 验收命令

请先阅读 `README.md` 中的 Docker 命令进入容器，再执行对应验收流程。

## 6. 预期输出

`terraform test` 返回 `1 passed, 0 failed`，并能完成本节要求的 plan/apply/output/destroy 或专项验证。

## 7. 常见问题

1. `terraform test` 失败：先读断言错误，它通常会指出缺少哪个值、字段或表达式结果。
2. `terraform validate` 失败：先检查 HCL 语法、列表/对象括号、逗号和变量名。
3. provider 下载失败：重新执行 `terraform init -input=false`。
4. 格式检查失败：运行 `terraform fmt` 后再验证。
5. 想重做实验：删除当前目录下 `.terraform`、`*.tfstate*`、`tfplan`、`plan.json`、`output/` 后重新开始。