# 第 142 节做题环境：AWS CLI source_profile 配置

这是你的上机做题目录。请编辑当前目录，不要修改 `practice/labs/142/` 中的参考实现。

本实验只练 AWS CLI 本地配置文件，不需要启动真实 AWS 资源。不要使用真实 AWS 账号。

## 知识点总结

- `credentials` 文件保存基础访问密钥。
- `config` 文件保存 profile 的 region、output、role_arn、source_profile 等配置。
- `source_profile = base` 表示当前 profile 先使用 base profile 的凭证作为来源。
- `role_arn` 表示当前 profile 准备基于来源凭证去 assume 哪个 role。

## 1. 进入实验目录

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\142
```

## 2. 开始做题

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\check-sandbox.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
Get-Content aws-config\config
Get-Content aws-config\credentials
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\clean.ps1
```

## 3. 关键配置

`aws-config/config` 里重点看：

```ini
[profile lab-142]
region = us-east-1
source_profile = base
role_arn = arn:aws:iam::000000000000:role/tf-pro-lab-142-demo
```

`aws-config/credentials` 里重点看：

```ini
[base]
aws_access_key_id = test
aws_secret_access_key = test
```

## 4. Linux 方式

```sh
bash scripts/check-sandbox.sh
bash scripts/bootstrap.sh
cat aws-config/config
cat aws-config/credentials
bash scripts/verify.sh
bash scripts/clean.sh
```
