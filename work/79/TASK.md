# Lab 79 任务：用 Remote State 串联 Network 与 Security

## 背景

`network/` 代表网络团队，负责产出公共 CIDR 和 owner 信息。

`consumer/` 代表安全团队，必须通过 `terraform_remote_state` 自动读取 network 的 outputs，并基于这些值生成规则说明。

## 任务目标

你需要完成：

- 在 `network/` 中创建一个 `terraform_data` 资源。
- 在 `network/` 中输出 `public_cidr` 和 `network_owner`。
- 在 `consumer/` 中使用 `data "terraform_remote_state" "network"` 读取 network state。
- 在 `consumer/` 中创建一个 `terraform_data` 资源，证明它使用了 remote state 读取到的 CIDR 和 owner。

## 你需要编辑的文件

- `network/main.tf`
- `consumer/main.tf`

## 需要使用的文件

- `network/backend.tf`
- `network/backend.hcl.example`
- `consumer/backend.tf`
- `consumer/backend.hcl.example`

## 禁止事项

- 不要使用真实 AWS。
- 不要手工复制 network 输出到 consumer。
- 不要修改 `practice/labs/79/`。

## 验收标准

- 先 apply `network/`，再 apply `consumer/`。
- `consumer` 使用 `data.terraform_remote_state.network.outputs.public_cidr`。
- `consumer` 使用 `data.terraform_remote_state.network.outputs.network_owner`。
- LocalStack S3 中存在 `labs/79/network/terraform.tfstate`。
- LocalStack S3 中存在 `labs/79/consumer/terraform.tfstate`。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
