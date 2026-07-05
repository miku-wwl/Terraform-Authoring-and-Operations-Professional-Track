# Terraform 实操训练 86：引用 Terraform Module 前的输入与结构判断

## 1. 背景

本目录是 `work/86` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform module 元数据处理练习。

这一节的重点不是“复制 module block 就完事”，而是理解：

- 有些 module 只要引用后 `terraform init` / `terraform plan` 就能形成资源计划。
- 有些 module 必须由调用方提供环境相关输入，例如 `subnet_ids`、`cluster_name`、`name`。
- 不同 module 的仓库结构不一样，有的根目录就是完整 module，有的根目录只是集合入口，真正可用的功能在 `//modules/...` 子模块路径下。
- module 行为和要求可能随版本变化，因此必须读文档，而不是盲目假设所有 module 都一样。

本 lab 使用 `data/module-catalog.json` 模拟几个 module 文档摘要：EC2、EKS、IAM root module、IAM user submodule。

## 2. 核心主题

- `file()`：读取当前 module 下的 JSON 文件内容。
- `jsondecode()`：把 module catalog JSON 转换成 Terraform 值。
- `for` 过滤：找出可以直接 plan/apply 的 module。
- map 构造：把 module name 映射到 required inputs、expected plan adds。
- 输入完整性检查：计算每个 module 还缺少哪些 required inputs。
- 子模块路径识别：识别 `//modules/...` 这种 source 写法。

## 3. 任务目标

请在 `main.tf` 中完成七个 TODO：

1. 用 `jsondecode(file("${path.module}/data/module-catalog.json"))` 读取并解析 JSON。
2. 从解析后的对象中读取 `modules` list。
3. 从解析后的对象中读取 `provided_inputs` map。
4. 找出可以直接创建资源计划的 module name。
5. 构造需要调用方输入的 module map：`module name => required_inputs`。
6. 计算每个 module 缺失的 required inputs，只保留确实缺输入的 module。
7. 找出子模块 source，并构造 `module name => expected_plan_adds` 的计划摘要 map。

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
- `terraform output direct_apply_module_names` 只显示 `ec2_instance`。
- `terraform output modules_requiring_inputs` 显示 EKS 和 IAM user 需要调用方输入。
- `terraform output missing_inputs_by_module` 显示 EKS 缺 `cluster_name`，IAM user 缺 `name`。
- `terraform output submodule_sources` 显示 IAM user 的 `//modules/iam-user` source。
- `terraform output container_module_names` 显示 IAM root module 是聚合型入口。
- `terraform output plan_adds_by_module` 显示每个 module 的模拟 plan add 数量。

## 6. 约束

- 不要硬编码输出绕过 `jsondecode()` 和 `for` 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- 判断“需要输入”的依据是 `length(module.required_inputs) > 0`。
- 判断“缺失输入”时，应比较 `required_inputs` 和 `provided_inputs` 中已有 key。
- 判断“子模块 source”的依据是 `module.module_path != "root"`。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
