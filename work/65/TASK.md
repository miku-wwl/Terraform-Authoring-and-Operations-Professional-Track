# Terraform 实操训练 65：templatefile 基础

## 1. 背景

本目录是 `work/65` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform `templatefile()` 基础练习。

这个 lab 会把一组 Terraform 值传入模板文件，渲染出文本内容，并用 `local_file` 写到 `output/service.txt`。

## 2. 核心主题

- `templatefile(path, vars)`：读取模板文件，并用 `vars` map 替换模板中的变量。
- 模板变量：`${name}`、`${environment}`、`${owner}` 这类占位符必须由 `vars` 提供。
- `path.module`：定位当前 module 目录，避免依赖执行命令时所在目录。
- 渲染结果复用：同一份渲染文本既可以作为 output，也可以写入文件。

## 3. 任务目标

请在 `main.tf` 中完成四个 TODO：

1. 定义传入模板的 `service_config`，包含 `name`、`environment`、`owner`。
2. 用 `templatefile("${path.module}/template.tftpl", local.service_config)` 渲染模板。
3. 用 `${path.module}/output/service.txt` 构造输出文件路径。
4. 用 `split()` 和 `trimspace()` 得到渲染结果的第一行 preview。

模板文件 `template.tftpl` 已经给出变量占位符。完成后运行 `README.md` 中的命令。

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
- `terraform output service_config` 显示传入模板的三个变量。
- `terraform output rendered_service_config` 显示渲染后的三行文本。
- `terraform output rendered_preview` 显示 `service=payments`。
- apply 后会生成 `output/service.txt`，destroy 后该文件资源会被删除。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要把渲染结果硬编码到 output 中绕过 `templatefile()`。
- 模板中使用的变量名必须和 `service_config` 中的 key 对应。
- 输出路径必须基于 `path.module` 构造。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
