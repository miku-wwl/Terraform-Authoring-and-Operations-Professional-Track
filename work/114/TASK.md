# Terraform 实操训练 114：Dependency Lock File 与 provider 版本锁定

## 1. 背景

本目录是 `work/114` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform dependency lock file 的数据建模练习。

Terraform provider plugin 和 Terraform CLI 本身有独立的发布周期。第一次 `terraform init` 选择到某个 provider 版本后，Terraform 会把选中的 provider 版本和 checksum 写入 dependency lock file，也就是 `.terraform.lock.hcl`。

这个 lab 不会真的下载 AWS provider，而是用 `data/dependency-lock.json` 模拟一次 provider 版本锁定场景，帮助你理解：

- `.terraform.lock.hcl` 记录 provider dependency 的最终选择版本。
- 版本约束可以允许一个范围，但 lock file 会固定一次实际选中的版本。
- 当想重新选择、升级或降级 provider 版本时，应使用 `terraform init -upgrade`。
- lock file 当前跟踪 provider dependency，不负责记住 remote module 的版本选择。
- lock file 里还会保存 checksum/hash，用于校验下载到的 provider package。

## 2. 核心主题

- `file()`：读取当前 module 下的 JSON 文件内容。
- `jsondecode()`：把 JSON 字符串转换成 Terraform object/list/map。
- map 构造：把 provider list 转成按 source 或 local name 索引的 map。
- `for` 过滤：筛选需要 `terraform init -upgrade` 才能重新选择版本的 provider。
- 嵌套 `for` + `flatten()`：展开 provider checksum 标签。
- dependency lock file 的 scope：provider 会被锁定，remote module version selection 不会被 lock file 记住。

## 3. 任务目标

请在 `main.tf` 中完成七个 TODO：

1. 用 `jsondecode(file("${path.module}/data/dependency-lock.json"))` 读取并解析 JSON。
2. 从解析后的对象中读取 `providers` list。
3. 构造 `locked_provider_versions_by_source` map，key 为 provider `source`，value 为 `locked_version`。
4. 构造 `provider_constraints_by_name` map，key 为 provider `local_name`，value 为 `constraint`。
5. 筛选 `providers_requiring_upgrade`，只保留 `requires_upgrade_to_change == true` 的 provider local name。
6. 用嵌套 `for` 和 `flatten()` 生成 checksum 标签，格式为 `local_name:hash`。
7. 构造 `lock_file_scope` object，体现 lock file 名称、provider 是否被跟踪、remote module 是否被跟踪，以及普通 init / 重新选择依赖的命令。

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
- `terraform output lock_file_name` 显示 `.terraform.lock.hcl`。
- `terraform output locked_provider_versions_by_source` 显示三个 provider 被锁定的版本。
- `terraform output provider_constraints_by_name` 显示三个 provider 的版本约束。
- `terraform output providers_requiring_upgrade` 只显示 `aws`。
- `terraform output checksum_labels` 显示所有 provider checksum 的扁平标签。
- `terraform output lock_file_scope` 显示 provider 被 lock file 跟踪，而 remote module 不被 lock file 跟踪。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要硬编码输出绕过 `jsondecode()` 和 `for` 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- 筛选需要升级的 provider 时使用 `provider.requires_upgrade_to_change == true`。
- 判断 provider/remote module 是否被 lock file 跟踪时，基于数据文件中的 `tracked_by_lock_file` 字段。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
