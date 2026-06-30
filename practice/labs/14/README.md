# 第 14 节参考实验

本实验用容器化方式验证 Checkov 可用性，相当于把安装步骤封装进工具镜像。

```powershell
docker run --rm bridgecrew/checkov:latest --version
```

Terraform 侧验证：

```sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
```

