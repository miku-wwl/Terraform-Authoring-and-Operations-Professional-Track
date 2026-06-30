# 第 17 节参考实验

本实验训练 code level scan 与 plan level scan 的区别。示例使用 Kubernetes provider 生成本地 plan，不执行 apply，不需要 Kubernetes 集群。

```sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan -var 'host_network_enabled=true'
terraform show -json tfplan > plan.json
```

扫描源码：

```powershell
docker run --rm `
  -v "${PWD}/practice/labs/17:/tf" `
  bridgecrew/checkov:latest `
  -d /tf --framework terraform --check CKV_K8S_19 --soft-fail --compact
```

扫描 plan JSON：

```powershell
docker run --rm `
  -v "${PWD}/practice/labs/17:/tf" `
  bridgecrew/checkov:latest `
  -f /tf/plan.json --framework terraform_plan --check CKV_K8S_19 --soft-fail --compact
```
