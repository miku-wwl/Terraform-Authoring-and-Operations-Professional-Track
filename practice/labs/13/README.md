# 第 13 节参考实验

本实验训练静态分析工具的价值。Terraform 文件故意包含不合规的 Kubernetes Pod 配置，只用于 Checkov 扫描，不要执行 `terraform apply`。

```powershell
docker run --rm `
  -v "${PWD}/practice/labs/13:/tf" `
  bridgecrew/checkov:latest `
  -d /tf --framework terraform --soft-fail --compact
```
