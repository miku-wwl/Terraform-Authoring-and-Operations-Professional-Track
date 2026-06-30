# 第 44 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 practice/labs/44/ 中的参考实现。

本实验需要一个本地 Vault dev server。请在仓库根目录执行：

```powershell
docker network create tf-vault-work
docker run -d --rm --name vault-work-44 --network tf-vault-work --network-alias vault --cap-add IPC_LOCK -e VAULT_DEV_ROOT_TOKEN_ID=root hashicorp/vault:1.18
docker run --rm --name tf-work-44 --network tf-vault-work -v "${PWD}/work/44:/workspace" -w /workspace --entrypoint sh hashicorp/terraform:1.11 scripts/run-with-vault.sh
docker stop vault-work-44
docker network rm tf-vault-work
```

如果脚本失败，请先执行清理命令，再重新开始。不要连接真实 Vault 或写入真实密钥。