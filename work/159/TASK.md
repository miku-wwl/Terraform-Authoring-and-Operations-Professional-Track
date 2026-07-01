# 第 159 节任务：挑战二解法二：模块重构后的输出与状态映射

## 背景

本题来自第 159 节课程内容，目标是把综合挑战中的关键动作转换成可运行、可验证、可销毁的练习。

## 要求

- 完成 `挑战二解法二：模块重构后的输出与状态映射` 对应的 Terraform 练习。
- 在 LocalStack 或本地 provider 中完成 plan/apply/verify/destroy。
- 理解本节与真实 AWS 行为之间的边界。

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

理论型 lab 使用脚本验收，不需要 Terraform。

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/159/`。
