# Terraform 实操训练 83：Terraform test 根级属性

## 1. 背景

本目录是 `work/83` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform test 根级属性练习。

这个 lab 会让你在 `.tftest.hcl` 文件里练习三个重点：

- 根级 `provider` block：测试文件可以定义自己的 provider 配置。
- 根级 `variables` block：测试文件可以覆盖主配置里的 input variable 默认值。
- 多个 `run` block：一个 test 文件中可以包含多个独立测试步骤。

## 2. 核心主题

- `.tftest.hcl`：Terraform test 的测试文件格式。
- `provider`：测试文件根级 provider block。
- `variables`：测试文件根级变量覆盖，注意这里是复数 `variables`。
- `run`：一个测试文件可以包含多个 run block。
- `assert`：每个 run block 可以包含自己的断言。

## 3. 任务目标

请在 `tests/root_level_attributes.tftest.hcl` 中完成四个 TODO：

1. 保留并理解根级 `provider "local" {}`，它表示 test 文件也可以声明 provider。
2. 在根级 `variables` block 中，把 `firewall_name` 覆盖成 `test-firewall`。
3. 在根级 `variables` block 中，把 `environment` 覆盖成 `test`。
4. 在根级 `variables` block 中，把 `region_label` 覆盖成 `ap-south-1`。

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

- `terraform test` 返回 `2 passed, 0 failed`。
- 第一个 run block 验证 test 文件根级 `variables` 覆盖了主配置默认值。
- 第二个 run block 验证多个 run block 会共享根级 `variables`。
- 输出中的 `resource_label` 应为 `test:ap-south-1:test-firewall`。

## 6. 约束

- 不要删除 `provider "local" {}`。
- 注意 test 文件里是 `variables`，不是普通 `.tf` 文件里的 `variable`。
- 不要修改断言来绕过练习。
- 不要硬编码 `main.tf` 输出绕过变量覆盖练习。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
