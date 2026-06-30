# Lab 44：Vault Provider

本实验使用本地 Vault dev server 和 Terraform Vault provider，写入并读取 `training/db_creds`。

```powershell
docker network create tf-vault-lab
docker run -d --rm --name vault-lab-44 --network tf-vault-lab --network-alias vault --cap-add IPC_LOCK -e VAULT_DEV_ROOT_TOKEN_ID=root hashicorp/vault:1.18
docker run --rm --name tf-practice-44 --network tf-vault-lab -v "${PWD}:/workspace" -w /workspace --entrypoint sh hashicorp/terraform:1.11 practice/labs/44/scripts/run-with-vault.sh
docker stop vault-lab-44
docker network rm tf-vault-lab
```

敏感值可能进入 Terraform state，真实环境必须使用远程加密后端和最小权限 token。
