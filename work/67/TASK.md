# Terraform 实操训练 67：JSON mock 数据与 for 表达式

## 1. 背景

本目录是 `work/67` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform JSON mock 数据处理练习。

这个 lab 会从 `data/mock.json` 读取一组应用数据，用 `jsondecode()` 转成 Terraform 值，然后用 `for` 表达式做过滤、映射和嵌套展开。

## 2. 核心主题

- `file()`：读取当前 module 下的 JSON 文件内容。
- `jsondecode()`：把 JSON 字符串转换成 Terraform object、list、string、number、bool 等值。
- `for` 过滤：用 `if` 子句筛选符合条件的对象。
- map 构造：用 `{ for app in ... : app.name => app }` 把 list 转成 map。
- 嵌套 `for`：遍历 app list 和每个 app 的 port list，生成 flat label list。

## 3. 任务目标

请在 `main.tf` 中完成六个 TODO：

1. 用 `jsondecode(file("${path.module}/data/mock.json"))` 读取并解析 JSON。
2. 从解析后的对象中读取 `apps` list。
3. 用 `for` 表达式筛选 backend app name。
4. 用 `for` 表达式构造 enabled app map。
5. 用 `for` 表达式生成 `app:owner` 标签。
6. 用嵌套 `for` 和 `flatten()` 生成 `app:port` 标签。

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
- `terraform output apps` 显示从 JSON 解码出的四个 app 对象。
- `terraform output backend_app_names` 显示三个 backend app。
- `terraform output enabled_apps_by_name` 显示按 name 索引的 enabled app map。
- `terraform output app_owner_labels` 显示四个 `app:owner` 标签。
- `terraform output app_port_labels` 显示五个 `app:port` 标签。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要硬编码输出绕过 `jsondecode()` 和 `for` 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- 过滤 backend app 时使用 `app.tier == "backend"`。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
