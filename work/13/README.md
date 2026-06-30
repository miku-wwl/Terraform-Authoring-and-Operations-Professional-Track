# 第 13 节做题环境

这是你的上机做题目录。请编辑当前目录下的文件，不要修改 practice/labs/13/ 中的参考实现。

进入 Checkov 容器执行扫描：

```powershell
docker run -it --rm --name tf-work-13-checkov `
  -v "${PWD}/work/13:/tf" `
  bridgecrew/checkov:latest `
  -d /tf --framework terraform --soft-fail --compact
```

如果需要在 Terraform 容器中查看文件或运行格式化检查：

```powershell
docker run -it --rm --name tf-work-13 `
  -v "${PWD}/work/13:/workspace" `
  -w /workspace `
  --entrypoint sh `
  hashicorp/terraform:1.11
```

本实验重点是静态扫描，不要求执行 `terraform apply`。