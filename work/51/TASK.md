# Terraform 实操训练 51：map 数据类型

## 1. 背景

本目录是 `work/51` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform map 表达式练习。

这个 lab 不需要云资源，只练 Terraform 基础数据类型。

## 2. 核心主题

- map 字面量：用 `{}` 定义 key/value 集合。
- map 取值：用 `local.tags["owner"]` 按 key 读取值。
- map 长度：用 `length()` 计算键值对数量。
- map keys：用 `keys()` 取得 key list。
- 默认值读取：用 `lookup()` 读取可选 key。
- map 遍历：用 `for` 表达式把 map 转换成 list。

## 3. 任务目标

请在 `main.tf` 中完成六个 TODO：

1. 定义包含 `owner`、`env`、`cost_center` 的 `local.tags` map。
2. 用 `local.tags["owner"]` 得到 `owner_tag`。
3. 用 `length(local.tags)` 得到 `tag_count`。
4. 用 `keys(local.tags)` 得到 `tag_keys`。
5. 用 `lookup(local.tags, "service", "checkout")` 得到 `service_name`。
6. 用 `for` 表达式生成 `tag_labels`。

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
- `terraform output tags` 显示三个 tag 键值对。
- `terraform output owner_tag` 显示 `platform`。
- `terraform output tag_count` 显示 `3`。
- `terraform output tag_keys` 显示排序后的 key list。
- `terraform output service_name` 显示 `checkout`。
- `terraform output tag_labels` 显示三个 `key=value` 标签。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要把 map 改成 list、set 或 object。
- 不要硬编码输出绕过 map 表达式练习。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
