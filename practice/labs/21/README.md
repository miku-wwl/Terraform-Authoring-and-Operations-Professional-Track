# Lab 21：Resource targeting 基础

本实验使用两个 `local_file` 资源模拟同一目录中的多资源配置。你将看到常规 `plan` 会覆盖全部资源，而 `-target` 可以限制本次操作的资源地址。

```sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -target=local_file.release_note -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

`-target` 适合故障恢复和少数运维场景，不应作为日常部署策略。
