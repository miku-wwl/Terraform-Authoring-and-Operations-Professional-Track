# 第 139 节任务：Launch Template 基础配置

## 背景

本题来自第 139 节课程内容，目标是把 `Launch Template 基础配置` 转换成可运行、可验证、可销毁的 Terraform 练习。

## 知识点总结

- Launch Template 是 EC2 启动配置模板。
- 常见字段包括 `image_id`、`instance_type`、`tag_specifications`。
- `tag_specifications` 里的 tag 会应用到模板启动出来的实例。

## 要求

- 创建 launch template。
- 配置 AMI、实例类型和标签规格。
- 输出 launch template id。

## Hint

完整示例见 `main.tf` 中的注释答案；标签规格核心如下：

```hcl
tag_specifications {
  resource_type = "instance"
  tags = {
    Name = "tf-pro-lab-139"
  }
}
```

## 验收

完成后执行：

```powershell
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/139/`。
