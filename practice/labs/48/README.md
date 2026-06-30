# Lab 48：`prevent_destroy`

本实验演示 `prevent_destroy` 如何阻止 Terraform 销毁关键资源。由于销毁失败是预期行为，清理实验时需要先从 state 中移除本地模拟资源，再删除本地文件。

```sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform destroy -auto-approve
terraform state rm local_file.critical_config
rm -f output/critical-config.txt
```

`terraform destroy` 应该失败并提示资源包含 `prevent_destroy`。
