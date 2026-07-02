# 第 11 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 practice/labs/11/ 中的参考实现。

进入 Docker：

```powershell
docker run -it --rm --name tf-work-11 `
  -v "${PWD}/work/11:/workspace" `
  -w /workspace `
  --entrypoint sh `
  hashicorp/terraform:1.11
```

容器内执行：

```sh
terraform providers mirror /workspace/mirror
rm -rf .terraform .terraform.lock.hcl
TF_CLI_CONFIG_FILE=/workspace/terraform-cli.rc terraform init -input=false
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

Lab11 练的是 file system mirror，不是 plugin cache。

先生成 mirror：

```sh
terraform providers mirror /workspace/mirror
```

再通过 CLI 配置文件指定 provider 安装来源：

```hcl
provider_installation {
  filesystem_mirror {
    path    = "/workspace/mirror"
    include = ["registry.terraform.io/hashicorp/*"]
  }

  direct {
    exclude = ["registry.terraform.io/hashicorp/*"]
  }
}
```

最后让 Terraform CLI 使用这份配置：

```sh
TF_CLI_CONFIG_FILE=/workspace/terraform-cli.rc terraform init -input=false
```

注意：

- `mirror/` 是 provider 镜像目录，不要提交到 Git。
- `.terraform.lock.hcl` 在真实生产项目中通常应该提交；本训练仓库为了避免每个 `work/N` 都产生 lock 文件，统一忽略。
- file system mirror 控制 provider 从哪里安装，lock file 控制 provider 版本和校验和。
- 如果在 init 日志里看到 mirror provider 显示 `unauthenticated`，先不要误判为失败；生产中应通过受控发布、checksum、扫描和权限来保证 mirror 内容可信。
