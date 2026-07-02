# 第 9 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 practice/labs/9/ 中的参考实现。

进入 Docker：

```powershell
docker run -it --rm --name tf-work-9 `
  -v "${PWD}/work/9:/workspace" `
  -w /workspace `
  --entrypoint sh `
  hashicorp/terraform:1.11
```

容器内执行：

```sh
mkdir -p .terraform-plugin-cache
export TF_PLUGIN_CACHE_DIR=/workspace/.terraform-plugin-cache
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

最终验证时会使用 `terraform fmt -check`。

说明：

- 本题的核心是 provider plugin cache。
- `TF_PLUGIN_CACHE_DIR` 是 Terraform CLI 读取的环境变量，用来指定 provider plugin 缓存目录。
- cache 可以减少重复下载，但不能替代 `.terraform.lock.hcl`。
- `terraform test` 只验证文档化的 cache 目录和命令，不会证明网络下载真的被复用；真实复用效果需要观察第二次 `terraform init` 的日志。
