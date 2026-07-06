# Terraform 实操训练 73：使用 LocalStack S3 实践 Backend 与 Remote State

## 1. 背景

本目录是 `work/73` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform backend 与 remote state 练习。

Backend 决定 Terraform state 存放在哪里。默认情况下 Terraform 使用本地 `terraform.tfstate`，但团队协作时通常会把 state 放到远端 backend，例如 S3。真实 AWS 会带来账号、权限和费用问题，所以本 lab 使用 LocalStack 仿真 S3，在本机实践 S3 backend 的配置方式。

本 lab 分三部分：

- `bootstrap/`：已完成的小根模块，用 LocalStack AWS provider 创建 S3 state bucket。
- `main.tf`：你要完成的 starter，把当前 root module 的 Terraform state 存到 LocalStack S3 backend，并通过 AWS provider 在 LocalStack 里创建一个 S3 bucket/object。
- `consumer/`：已完成的小根模块，用 `terraform_remote_state` 从 LocalStack S3 backend 读取 `main.tf` 产生的输出。

## 2. 核心主题

- `terraform { backend "s3" { ... } }`：把 state 存到 S3 兼容 backend。
- LocalStack S3 endpoint：`http://localhost:4566`。
- S3 backend 与 AWS provider 是两套配置：backend 负责 state 存储，provider 负责资源管理。
- S3 path-style access：LocalStack 常用 `force_path_style` / `s3_use_path_style`。
- `terraform_remote_state`：另一个 root module 读取远端 state 的输出。
- Bootstrap 顺序：state bucket 必须先存在，主 root module 才能初始化 S3 backend。

## 3. 前置条件

你需要确保 LocalStack 已经在本机运行，并且 `http://localhost:4566` 可访问。本仓库不负责启动 Docker，因为你的 Docker 环境可能在另一个系统账户中。

如果你要自行启动，可参考：

```powershell
docker run --rm -it -p 4566:4566 -e SERVICES=s3 localstack/localstack
```

## 4. 任务目标

请在 `main.tf` 中完成七个 TODO：

1. 在 `backend "s3"` 中设置 state bucket：`tfstate-lab73`。
2. 在 `backend "s3"` 中设置 state key：`lab73/terraform.tfstate`。
3. 在 `backend "s3"` 中设置 region：`us-east-1`。
4. 在 `backend "s3"` 中设置 LocalStack endpoint、测试凭据和 S3 path-style 相关开关。
5. 配置 AWS provider，使它也连接到 LocalStack S3。
6. 在 locals 中记录 backend 配置，供输出和测试审计。
7. 设置应用 bucket 名称和本 lab 的总结信息。

## 5. 预期关键值

主配置完成后应使用这些值：

```hcl
localstack_endpoint = "http://localhost:4566"
backend_region      = "us-east-1"
state_bucket_name   = "tfstate-lab73"
state_key           = "lab73/terraform.tfstate"
application_bucket_name = "lab73-app-state-demo"
```

`backend_lesson_summary` 应说明 state 存在：

```hcl
"s3://tfstate-lab73/lab73/terraform.tfstate"
```

## 6. 验收方式

先创建 LocalStack 里的 state bucket：

```powershell
cd work/73/bootstrap
terraform init -input=false
terraform apply -auto-approve
```

然后回到主 lab，完成 `main.tf` 的 TODO 后初始化 S3 backend：

```powershell
cd ..
terraform init -reconfigure -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
```

最后验证另一个 root module 能读取 remote state：

```powershell
cd consumer
terraform init -input=false
terraform apply -auto-approve
terraform output
```

清理顺序建议：

```powershell
cd ..
terraform destroy -auto-approve
cd bootstrap
terraform destroy -auto-approve
```

## 7. 预期结果

- `terraform test` 返回 `1 passed, 0 failed`。
- 主 lab 的 state 存储在 LocalStack S3：`s3://tfstate-lab73/lab73/terraform.tfstate`。
- 主 lab 创建应用 bucket：`lab73-app-state-demo`。
- 主 lab 创建对象：`backend/remote-state.txt`。
- `consumer/` 能通过 `terraform_remote_state` 读取主 lab 的输出。

## 8. 约束

- 不要把本 lab 改回本地 backend。
- 不要使用真实 AWS endpoint 或真实 AWS 凭据。
- `bootstrap/` 只负责创建 backend bucket，不应存放主 lab 的业务资源。
- 主 lab 的 S3 backend 和 AWS provider 都必须指向 `http://localhost:4566`。
- backend 负责 Terraform state；provider 负责管理 S3 bucket/object 资源，不要混淆两者。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
