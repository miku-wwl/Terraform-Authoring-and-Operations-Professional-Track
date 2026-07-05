# Terraform 实操训练 73：Terraform Backend 与 Remote State 概念建模

## 1. 背景

本目录是 `work/73` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform backend 概念建模练习。

Backend 决定 Terraform state 存放在哪里。默认情况下，Terraform 使用 `local` backend，把 state 写到当前目录的 `terraform.tfstate` 文件。单人小项目可以这样做，但团队协作时，state 通常应放到中心化 backend，例如 S3、Consul、Kubernetes、HTTP、etcd 等。

这个 lab 不会真的创建 AWS S3 backend，也不会要求云账号。你要通过 `data/backend-catalog.json` 建模不同 backend 的特性，然后用 Terraform 表达式筛选出适合团队协作、需要凭据、支持锁定的 backend。

## 2. 核心主题

- Backend 的职责：决定 Terraform state 存储位置。
- Local backend：默认行为，state 存在本机 `terraform.tfstate`。
- Remote backend：把 state 放到中心化远端服务，更适合团队协作。
- Remote state 的额外要求：访问凭据、权限控制、state locking。
- `jsondecode(file(...))`：从 JSON 文件读取 backend catalog。
- `for` 表达式：把 list 转 map，并按条件筛选 backend。

## 3. 任务目标

请在 `main.tf` 中完成六个 TODO：

1. 用 `jsondecode(file("${path.module}/data/backend-catalog.json"))` 读取 backend catalog。
2. 把 backend list 转成按 backend name 索引的 map。
3. 筛选所有 remote backend name。
4. 筛选适合团队协作的 backend：必须是 remote，并且支持 locking。
5. 筛选所有需要访问凭据的 backend name。
6. 构造 AWS 团队推荐 backend 对象，选择 `s3`，并输出 state 存储位置和锁定说明。

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
- `terraform output backend_catalog` 显示六个 backend 条目。
- `terraform output backends_by_name` 显示按 name 索引的 backend map。
- `terraform output remote_backend_names` 显示除 `local` 以外的 remote backend。
- `terraform output collaboration_ready_backend_names` 显示支持 locking 的 remote backend。
- `terraform output credential_required_backend_names` 显示需要访问凭据的 backend。
- `terraform output aws_team_backend_recommendation` 推荐 `s3` 作为 AWS 团队 remote state backend。

## 6. 约束

- 不要硬编码测试期望值绕过 `jsondecode()` 和 `for` 表达式练习。
- JSON 文件路径必须基于 `path.module` 构造。
- `backends_by_name` 必须用 backend 的 `name` 作为 map key。
- 团队协作 backend 必须同时满足 `kind == "remote"` 和 `supports_locking == true`。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
