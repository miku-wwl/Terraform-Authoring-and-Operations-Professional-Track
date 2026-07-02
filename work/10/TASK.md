# Terraform 实操训练 10：Plugin Cache 实践落地

## 1. 背景

本目录是 `work/10` 上机做题环境，来源于 `practice/10.md` 的实验设计。这里不是参考答案目录，你需要在当前目录内完成代码或命令练习。

核心主题：Terraform CLI 配置文件、`TF_PLUGIN_CACHE_DIR`、dependency lock file

## 2. 任务目标

生成 `output/terraformrc-plugin-cache.example`。

本题是 Lab9 的进阶。Lab9 主要练 `TF_PLUGIN_CACHE_DIR` 环境变量；Lab10 练 Terraform CLI 配置文件，也就是 `.terraformrc` 或 `terraform.rc` 里的 `plugin_cache_dir`。

你需要把一份 Terraform CLI 配置示例生成出来，并说明 plugin cache 和 `.terraform.lock.hcl` 的关系。

关键点：

- `plugin_cache_dir` 写在 Terraform CLI 配置文件里，不写在普通业务模块的 `main.tf` 资源块里。
- `TF_CLI_CONFIG_FILE` 可以指定本次 Terraform 命令使用哪个 CLI 配置文件。
- `.terraform.lock.hcl` 负责 provider 版本和校验和，plugin cache 只负责下载包复用。
- `plugin_cache_may_break_dependency_lock_file` 是兼容性开关，不应该在团队规范里默认开启。

## 3. 你需要编辑的文件

- `main.tf`：完成 3 个 TODO，生成正确的 Terraform CLI 配置示例和落地步骤。
- `outputs.tf`：查看测试会读取哪些输出。
- `tests/plugin_cache_practical.tftest.hcl`：验收测试，建议不要修改，优先让代码满足测试。

你需要完成：

- 把 `plugin_cache_dir` 设置为 `/workspace/.terraform-plugin-cache`。
- 不要默认启用 `plugin_cache_may_break_dependency_lock_file = true`。
- 把步骤里的 TODO 改成：`保留 .terraform.lock.hcl 以稳定 provider 校验和`。

## 4. 约束

- 不要修改 `practice/labs/10/`。
- 不要创建真实 AWS 资源。
- 文档、注释、报告使用中文；命令、参数、文件名可以保留英文。
- 不要修改测试来绕过验收。
- 不要提交 `.terraform`、`.terraform-plugin-cache`、`.terraform.lock.hcl`、`tfplan`、`terraform.tfstate*`、`output/`。

## 5. 验收命令

请先阅读 `README.md` 中的 Docker 命令进入容器，再执行对应验收流程。

## 6. 预期输出

- `terraform test` 返回 `1 passed, 0 failed`。
- `terraform apply` 后生成 `output/terraformrc-plugin-cache.example`。
- 输出内容中包含 `plugin_cache_dir = "/workspace/.terraform-plugin-cache"`。
- `implementation_steps` 中说明保留 `.terraform.lock.hcl` 的原因。

## 7. 常见问题

1. `terraform test` 失败：先读断言错误，它通常会指出缺少哪个命令、参数或输出。
2. 不知道 `plugin_cache_dir` 写在哪里：它写在 CLI 配置文件里，不是 Terraform resource 参数。
3. `TF_PLUGIN_CACHE_DIR` 和 `plugin_cache_dir` 混淆：前者是环境变量方式，后者是 CLI 配置文件方式。
4. `.terraform.lock.hcl` 和 cache 混淆：lock file 管版本和校验和，cache 管下载包复用。
5. 格式检查失败：运行 `terraform fmt` 后再验证。
6. 想重做实验：删除当前目录下 `.terraform`、`.terraform-plugin-cache`、`*.tfstate*`、`tfplan`、`output/` 后重新开始。
