# Lab 114：Dependency Lock File

本节允许并要求你打开当前目录里的 `.terraform.lock.hcl`。其他 Lab 不需要照做。

不要一开始就连续运行所有命令。请按照 `TASK.md` 的四个阶段操作：

1. 保持 `main.tf` 中的版本为 `2.5.2`，运行普通 `terraform init`，打开锁文件观察。
2. 把版本改成 `2.5.3`，再次运行普通 `terraform init`，阅读预期的冲突错误。
3. 运行 `terraform init -upgrade`，再次打开锁文件比较变化。
4. 最后运行格式、校验和测试命令完成验收。

常用命令：

```powershell
cd work/114
terraform init -input=false
terraform init -upgrade -input=false
terraform fmt
terraform validate
terraform test
```

这个 Lab 没有资源，因此不需要运行 `terraform apply` 或 `terraform destroy`。

> 训练仓库通常忽略各 Lab 自动生成的锁文件，但 `work/114/.terraform.lock.hcl` 是本节的学习材料，已单独允许进入 Git。真实项目的 root module 通常也应提交锁文件。
