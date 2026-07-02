# 第 10 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 practice/labs/10/ 中的参考实现。

进入 Docker：

```powershell
docker run -it --rm --name tf-work-10 `
  -v "${PWD}/work/10:/workspace" `
  -w /workspace `
  --entrypoint sh `
  hashicorp/terraform:1.11
```

容器内执行：

```sh
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

## 本节重点

Lab9 练的是环境变量方式：

```sh
export TF_PLUGIN_CACHE_DIR=/workspace/.terraform-plugin-cache
```

Lab10 练的是 Terraform CLI 配置文件方式。你要生成的文件类似：

```hcl
plugin_cache_dir = "/workspace/.terraform-plugin-cache"
```

真实使用时，可以把它保存成 `terraform.rc`，然后让 Terraform CLI 读取它：

```sh
mkdir -p .terraform-plugin-cache
cat > terraform.rc <<'EOF'
plugin_cache_dir = "/workspace/.terraform-plugin-cache"
EOF
export TF_CLI_CONFIG_FILE=/workspace/terraform.rc
terraform init -input=false
```

注意：

- `plugin_cache_dir` 不写在普通业务模块的 `main.tf` 里，而是写在 `.terraformrc` 或 `terraform.rc` 这类 CLI 配置文件里。
- `TF_CLI_CONFIG_FILE` 用来指定 CLI 配置文件位置。
- `.terraform.lock.hcl` 仍然负责 provider 版本和校验和，plugin cache 不能替代它。
- `.terraform-plugin-cache` 是本地缓存目录，不要提交到 Git。
