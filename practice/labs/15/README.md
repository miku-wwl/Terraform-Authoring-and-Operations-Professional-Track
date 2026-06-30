# 第 15 节参考实验

本实验训练 Checkov 的 `-f`、`-d`、`--check`、`--skip-check` 用法。示例 Terraform 只用于静态扫描，不要 apply。

扫描单文件：

```powershell
docker run --rm `
  -v "${PWD}/practice/labs/15:/tf" `
  bridgecrew/checkov:latest `
  -f /tf/main.tf --framework terraform --soft-fail --compact
```

只运行 Kubernetes Pod 安全上下文相关检查：

```powershell
docker run --rm `
  -v "${PWD}/practice/labs/15:/tf" `
  bridgecrew/checkov:latest `
  -d /tf --check CKV_K8S_16,CKV_K8S_19 --soft-fail --compact
```

跳过某个检查：

```powershell
docker run --rm `
  -v "${PWD}/practice/labs/15:/tf" `
  bridgecrew/checkov:latest `
  -d /tf --skip-check CKV_K8S_14 --soft-fail --compact
```
