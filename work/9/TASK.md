# Terraform 实操训练 9：Provider Plugin Cache 概念

## 1. 背景

本目录是 `work/9` 上机做题环境，来源于 `practice/9.md` 的实验设计。这里不是参考答案目录，你需要在当前目录内完成代码或命令练习。

核心主题：provider plugin cache、重复 init、带宽和耗时优化

## 2. 任务目标

生成 `output/plugin-cache-policy.md`。

本题训练的是 provider plugin cache：让多个 Terraform 项目或多次 `terraform init` 复用已经下载过的 provider plugin，减少 CI/CD 初始化耗时和网络带宽。

注意：plugin cache 不是 lock file 的替代品。`.terraform.lock.hcl` 负责锁定 provider 版本和校验和，`TF_PLUGIN_CACHE_DIR` 负责缓存下载包。

## 3. 你需要编辑的文件

- `main.tf`：修复 `local.plugin_cache_dir` 和 `local.cache_commands`。
- `outputs.tf`：检查输出是否能暴露 cache 目录和命令列表。
- `templates/plugin-cache-policy.tftpl`：查看生成的策略文档如何引用 cache 目录和命令列表。
- `tests/plugin_cache.tftest.hcl`：验收测试，建议不要修改，优先让代码满足测试。

你需要完成：

- 把 `plugin_cache_dir` 指向 `.terraform-plugin-cache`。
- 把两条 `terraform init` 改成非交互式命令。
- 保留 `TF_PLUGIN_CACHE_DIR` 的导出命令，让生成的文档能说明如何启用缓存。

## 4. 约束

- 不要修改 `practice/labs/9/`。
- 不要创建真实 AWS 资源。
- 文档、注释、报告使用中文；命令、参数、文件名可以保留英文。
- 不要改变测试文件来绕过验收。
- 不要把 `.terraform-plugin-cache`、`.terraform`、`.terraform.lock.hcl`、`tfplan`、`tfstate` 提交进 Git。

## 5. 验收命令

请先阅读 `README.md` 中的 Docker 命令进入容器，再执行对应验收流程。

## 6. 预期输出

- `terraform test` 返回 `1 passed, 0 failed`。
- `terraform apply` 后生成 `output/plugin-cache-policy.md`。
- `terraform output` 显示 `plugin_cache_dir` 中包含 `.terraform-plugin-cache`。

## 7. 常见问题

1. `terraform test` 失败：先读断言错误，它通常会指出缺少哪个命令、参数或输出。
2. cache 目录不生效：确认当前 shell 里设置了 `TF_PLUGIN_CACHE_DIR`。
3. 仍然重复下载 provider：确认 provider 版本相同，并且 lock file 没有频繁变化。
4. `.terraform.lock.hcl` 和 cache 混淆：lock file 管版本和校验和，cache 管下载包复用。
5. 格式检查失败：运行 `terraform fmt` 后再验证。
6. 想重做实验：删除当前目录下 `.terraform`、`.terraform-plugin-cache`、`*.tfstate*`、`tfplan`、`output/` 后重新开始。
