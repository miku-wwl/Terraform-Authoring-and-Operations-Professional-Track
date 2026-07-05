# Terraform 实操训练 66：模板处理 map 和循环

## 1. 背景

本目录是 `work/66` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 模板循环练习。

这个 lab 会把一个 service port map 传入 `templatefile()`，模板使用 `%{ for ... }` 遍历 map key，并渲染成多行文本。

## 2. 核心主题

- map 传参：把 Terraform map 作为 `templatefile()` 的变量传入模板。
- `keys()`：从 map 中取出排序后的 key list，作为模板循环顺序。
- 模板循环：在 `.tftpl` 中使用 `%{ for name in names ~}` 和 `%{ endfor ~}`。
- 模板索引：在模板中用 `${services[name]}` 根据 key 读取 map value。
- 渲染结果拆分：用 `trimspace()` 和 `split()` 把渲染结果转回 line list。

## 3. 任务目标

请在 `main.tf` 中完成五个 TODO：

1. 定义 `service_ports` map，包含 `api`、`worker`、`billing` 三个服务端口。
2. 用 `keys(local.service_ports)` 得到排序后的 `service_names`。
3. 用 `templatefile()` 渲染 `template.tftpl`，并传入 `services` 与 `names`。
4. 用 `${path.module}/output/services.txt` 构造输出文件路径。
5. 用 `split("\n", trimspace(local.rendered_services))` 得到渲染行列表。

模板文件 `template.tftpl` 已经给出循环结构。完成后运行 `README.md` 中的命令。

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
- `terraform output service_names` 显示 `api`、`billing`、`worker`。
- `terraform output rendered_services` 显示三行服务端口内容。
- `terraform output rendered_lines` 显示按行拆分后的 list。
- apply 后会生成 `output/services.txt`，destroy 后该文件资源会被删除。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要把模板渲染结果硬编码到 output 中绕过 `templatefile()`。
- 模板循环顺序要来自 `keys(local.service_ports)`，不要手写排序结果。
- 模板中读取端口时使用 `${services[name]}`，不要在模板中硬编码端口。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
