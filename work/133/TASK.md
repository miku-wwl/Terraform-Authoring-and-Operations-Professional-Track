# 第 133 节任务：aws_subnet / aws_subnets 数据源

## 背景

本题来自第 133 节课程内容，目标是把 `aws_subnet / aws_subnets 数据源` 转换成可运行、可验证、可销毁的 Terraform 练习。

## 要求

- 创建一个 VPC 与两个子网作为查询目标。
- 使用 aws_subnets 按 vpc-id 查询子网集合。
- 使用 aws_subnet 读取单个子网的 cidr_block。

## 验收

完成后执行：

```powershell
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
powershell -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/133/`。
