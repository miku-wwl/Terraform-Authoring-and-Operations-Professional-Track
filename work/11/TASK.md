# Terraform 实操训练 11：File System Mirror 概念

## 1. 背景

本目录是 `work/11` 上机做题环境，来源于 `practice/11.md` 的实验设计。这里不是参考答案目录，你需要在当前目录内完成代码或命令练习。

核心主题：file system mirror、离线 provider 安装、`TF_CLI_CONFIG_FILE`

## 2. 任务目标

`terraform init` 从 mirror 安装 `hashicorp/local`，并成功完成本地文件实验。

本题训练 file system mirror。它和 Lab9/Lab10 的 plugin cache 不一样：

- plugin cache 主要是为了减少重复下载。
- file system mirror 是为了让 Terraform 在离线、内网或受控网络环境中从本地目录安装 provider。

你需要先生成 mirror 目录，再配置 `terraform-cli.rc`，最后通过 `TF_CLI_CONFIG_FILE` 让 `terraform init` 从 mirror 安装 provider。

## 3. 你需要编辑的文件

- `terraform-cli.rc`：完成 `filesystem_mirror.path`，并理解 `direct.exclude` 的作用。
- `main.tf`：修复输出说明文件名。
- `outputs.tf`：查看测试会读取哪些输出。
- `tests/filesystem_mirror.tftest.hcl`：验收测试，建议不要修改，优先让代码满足测试。

你需要完成：

- 把 `terraform-cli.rc` 里的 mirror 路径改成 `/workspace/mirror`。
- 保留 `include = ["registry.terraform.io/hashicorp/*"]`。
- 保留 `direct.exclude`，避免 HashiCorp provider 回退到公网直接安装。
- 把 `main.tf` 的输出文件名改成 `output/filesystem-mirror-note.txt`。

## 4. 约束

- 不要修改 `practice/labs/11/`。
- 不要创建真实 AWS 资源。
- 文档、注释、报告使用中文；命令、参数、文件名可以保留英文。
- 不要修改测试来绕过验收。
- 不要提交 `.terraform`、`.terraform.lock.hcl`、`mirror/`、`tfplan`、`terraform.tfstate*`、`output/`。

## 5. 验收命令

请先阅读 `README.md` 中的 Docker 命令进入容器，再执行对应验收流程。

## 6. 预期输出

- `terraform test` 返回 `1 passed, 0 failed`。
- `terraform apply` 后生成 `output/filesystem-mirror-note.txt`。
- `terraform init` 可以在 `TF_CLI_CONFIG_FILE=/workspace/terraform-cli.rc` 下从 `/workspace/mirror` 安装 provider。

## 7. 常见问题

1. `terraform test` 失败：先读断言错误，它通常会指出缺少哪个命令、参数或输出。
2. mirror 目录为空：先执行 `terraform providers mirror /workspace/mirror`。
3. `terraform init` 仍然访问公网：确认 `TF_CLI_CONFIG_FILE=/workspace/terraform-cli.rc` 是否生效。
4. mirror 路径无效：注意 Docker 容器内路径是 `/workspace/mirror`，不是 Windows 宿主机路径。
5. 出现 `unauthenticated`：file system mirror 场景常见，生产中要靠 mirror 发布流程、checksum、lock file 和扫描保证可信。
6. 格式检查失败：运行 `terraform fmt` 后再验证。
7. 想重做实验：删除当前目录下 `.terraform`、`mirror/`、`*.tfstate*`、`tfplan`、`output/` 后重新开始。
