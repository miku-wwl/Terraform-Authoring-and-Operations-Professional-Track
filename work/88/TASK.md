# Terraform 实操训练 88：组织内部 Terraform module 基础目录结构

## 1. 背景

本目录是 `work/88` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform module 基础目录结构建模练习。

很多组织不会完全依赖 Terraform Registry 上的公共 module，而是会维护自己的内部 module。原因通常是：公共 module 的维护节奏由外部团队决定，而企业内部经常有更细的安全、命名、标签、网络、权限和可配置项要求。

这个 lab 会从 `data/module-structure.json` 读取一个简化的组织内部 module 仓库结构，用 `jsondecode()` 转成 Terraform 值，然后用 `for` 表达式整理 module 目录、team 目录和 team 到 module 的引用关系。

## 2. 核心主题

- 内部 module 仓库的基础结构：`modules/` 和 `teams/`。
- `modules/<module-name>`：每个子目录代表一个可复用 module，例如 `ec2`、`security-group`。
- `teams/<team-name>`：每个团队目录可以按需要引用内部 module。
- module source 相对路径：团队目录后续可以通过类似 `../../modules/ec2` 的方式引用内部 module。
- `jsondecode()` + `for` 表达式：把目录规划数据转换成 Terraform 输出，便于测试和验证。

## 3. 任务目标

请在 `main.tf` 中完成十二个 TODO：

1. 用 `jsondecode(file("${path.module}/data/module-structure.json"))` 读取并解析 JSON。
2. 从解析后的对象中读取 `root_folders` list。
3. 从解析后的对象中读取 `modules` list。
4. 从解析后的对象中读取 `teams` list。
5. 从解析后的对象中读取 `references` list。
6. 用 `for` 表达式生成 module 路径 list。
7. 用 `for` 表达式生成 team 路径 list。
8. 用 `for` 表达式生成 module name list 和 team name list。
9. 用 map 构造生成每个 team 对应的 module source。
10. 用 `concat()` 拼出完整基础结构路径 list。
11. 构造每个 team 计划引用的 module name map。
12. 读取组织内部 module policy object。

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
- `terraform output root_folders` 显示 `modules` 和 `teams`。
- `terraform output module_paths` 显示 `modules/ec2` 和 `modules/security-group`。
- `terraform output team_paths` 显示 `teams/team-a` 和 `teams/team-b`。
- `terraform output team_source_by_team` 显示每个 team 后续应引用的内部 module source。
- `terraform output base_structure_paths` 显示完整基础目录结构。

## 6. 约束

- 不要硬编码最终输出绕过 `jsondecode()` 和 `for` 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- module 目录必须来自 JSON 中的 `modules[*].path`。
- team 目录必须来自 JSON 中的 `teams[*].path`。
- team 到 module 的 source 映射必须来自 JSON 中的 `references`。
- 这一节只做基础结构建模，不要求真的创建 AWS EC2、Security Group，也不要求真正调用 module。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
