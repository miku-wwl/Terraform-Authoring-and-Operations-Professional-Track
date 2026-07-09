# Lab 78 任务：使用 terraform_remote_state 读取上游输出

## 背景

`network/` 代表上游网络团队，负责把公共 CIDR 等信息写入自己的 S3 remote state。

`consumer/` 代表下游消费方，不能手工复制这些值，而是要通过 `terraform_remote_state` 读取 `network` 暴露的 outputs。

## 知识点总结

- `terraform_remote_state` 是 Terraform 内置 data source。
- 它用 `backend = "s3"` 和 `config = { ... }` 定位另一份 remote state。
- 它主要读取上游 state 里的 `outputs`，例如 `outputs.public_cidr`。
- `consumer/backend.hcl` 和 `data "terraform_remote_state"` 不是一回事：
  - `consumer/backend.hcl`：consumer 自己的 state 存哪里。
  - `terraform_remote_state.network.config`：consumer 去哪里读取 network 的 state outputs。
- 必须先 apply 上游 `network/`，下游 `consumer/` 才能读取到 outputs。

## 任务目标

你需要完成：

- 在 `network/` 中创建一个 `terraform_data` 资源。
- 在 `network/` 中输出 `public_cidr` 和 `network_owner`。
- 在 `consumer/` 中使用 `data "terraform_remote_state" "network"` 读取 network state。
- 在 `consumer/` 中创建一个 `terraform_data` 资源，证明它使用了 remote state 读取到的 CIDR。
- 阅读 `network/backend.hcl` 和 `consumer/backend.hcl`，理解两个项目的 state 是分开存放的。

## 你需要编辑的文件

- `network/main.tf`
- `consumer/main.tf`
- `network/backend.hcl`
- `consumer/backend.hcl`

## 需要使用的文件

- `network/backend.tf`
- `network/backend.hcl.example`
- `consumer/backend.tf`
- `consumer/backend.hcl.example`

## Hint

`consumer/main.tf` 中最关键的是这两段：

```hcl
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-pro-state-localstack"
    key    = "labs/78/network/terraform.tfstate"
    region = "us-east-1"
  }
}
```

以及：

```hcl
allowed_cidr = data.terraform_remote_state.network.outputs.public_cidr
```

第一段负责定位上游 network 的 state，第二段负责读取 network 暴露的 output。

## 禁止事项

- 不要使用真实 AWS。
- 不要手工复制 network 输出到 consumer。
- 不要修改 `practice/labs/78/`。

## 验收标准

- 先 apply `network/`，再 apply `consumer/`。
- `consumer` 使用 `data.terraform_remote_state.network.outputs.public_cidr`。
- LocalStack S3 中存在 `labs/78/network/terraform.tfstate`。
- LocalStack S3 中存在 `labs/78/consumer/terraform.tfstate`。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
