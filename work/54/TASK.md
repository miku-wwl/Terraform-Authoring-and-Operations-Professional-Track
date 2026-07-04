# Terraform 实操训练 54：嵌套类型

## 1. 背景

本目录是 `work/54` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 嵌套类型表达式练习。

这个 lab 不需要云资源，只练 Terraform 基础数据类型和表达式组合。

## 2. 核心主题

- map(object)：用 map 保存多个环境对象。
- 嵌套属性读取：从 map 中取 object，再读取 object 属性。
- 嵌套 list 读取：从 object 内部的 list 中读取可用区。
- 嵌套 map/object 读取：从 object 内部的 tags 中读取 owner。
- map keys：读取环境名集合。
- map(object) 遍历：用 `for` 表达式从嵌套结构生成标签。

## 3. 任务目标

请在 `main.tf` 中完成八个 TODO：

1. 定义包含 `dev`、`prod` 两个对象的 `local.environments` map(object)。
2. 用 `length(local.environments)` 得到 `environment_count`。
3. 用 `local.environments.prod.replicas` 得到 `prod_replicas`。
4. 用 `local.environments.prod.region` 得到 `prod_region`。
5. 用 `local.environments.prod.zones[0]` 得到 `prod_primary_zone`。
6. 用 `local.environments.prod.tags.owner` 得到 `prod_owner`。
7. 用 `keys(local.environments)` 得到 `environment_names`。
8. 用 `for` 表达式生成 `environment_region_labels`。

TODO 下方已经写了自验证提示。完成后运行 `README.md` 中的命令。

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
- `terraform output environments` 显示两个嵌套 environment object。
- `terraform output environment_count` 显示 `2`。
- `terraform output prod_replicas` 显示 `3`。
- `terraform output prod_region` 显示 `ap-southeast-2`。
- `terraform output prod_primary_zone` 显示 `az-a`。
- `terraform output prod_owner` 显示 `platform`。
- `terraform output environment_names` 显示 `dev`、`prod`。
- `terraform output environment_region_labels` 显示两个 `environment:region` 标签。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要把嵌套结构拆成多个互不相关的 locals 来绕过嵌套类型练习。
- 不要硬编码输出绕过 map(object)、嵌套属性读取和 `for` 表达式练习。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
