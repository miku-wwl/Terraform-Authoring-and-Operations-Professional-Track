# 第 157 节做题环境：挑战二概览：模块重构

这是你的上机做题目录。请编辑当前目录，不要修改 `practice/labs/157/` 中的参考实现。

本节是理论/准备型 lab，不需要启动 LocalStack，也不需要执行 Terraform 命令。你只需要运行脚本生成检查清单、阅读任务要求，然后执行验证脚本确认环境结构正确。

## 1. 进入实验目录

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\157
```

## 2. 开始做题

```powershell
powershell -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
powershell -ExecutionPolicy Bypass -File scripts\verify.ps1
powershell -ExecutionPolicy Bypass -File scripts\clean.ps1
```

## 3. 下一步

完成本节后，继续进入后续实操型 lab。实操型 lab 才需要启动 LocalStack，并运行 `terraform init`、`terraform plan`、`terraform apply` 和 `terraform destroy`。
