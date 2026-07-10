# Lab 142：AWS CLI source_profile

本实验只练 AWS CLI 的本地 profile 解析，不运行 Terraform、不启动 LocalStack、不访问 AWS API，也不会真正 AssumeRole。

你会直接编辑：

- `aws-config/config`：region、output、role_arn、source_profile；
- `aws-config/credentials`：base profile 的 LocalStack 测试凭据。

## 1. 进入目录并隔离 AWS CLI

```powershell
cd D:\workshop\Codex\Terraform-Authoring-and-Operations-Professional-Track\work\142
Set-ExecutionPolicy -Scope Process Bypass -Force
& .\scripts\bootstrap.ps1
& .\scripts\check-sandbox.ps1
```

bootstrap 只把 AWS CLI 指向当前 Lab 文件，不写答案：

```text
AWS_CONFIG_FILE=work/142/aws-config/config
AWS_SHARED_CREDENTIALS_FILE=work/142/aws-config/credentials
AWS_EC2_METADATA_DISABLED=true
```

因此不会读取你真实的 `~/.aws/config` 或 `~/.aws/credentials`。

## 2. 边学边练

打开 `aws-config/config` 和 `aws-config/credentials`。每个 TODO 上方都有完整答案级 Hint。

先完成 base profile：

```ini
[profile base]     # config 文件的命名方式
[base]             # credentials 文件的命名方式
```

注意：credentials 文件不能写成 `[profile base]`。

再完成 `lab-142`：

```text
lab-142 ── source_profile=base ──► base 的 test/test 凭据
       └─ role_arn ──────────────► 准备调用 STS AssumeRole
```

本实验只解析这条链，不执行 STS。

## 3. 用 AWS CLI 本地解析验收

```powershell
aws configure get region --profile base
aws configure get source_profile --profile lab-142
aws configure get role_arn --profile lab-142
& .\scripts\verify.ps1
```

验证脚本还会确认 credentials 中只有 `base`，没有给 `lab-142` 重复存长期密钥。

## 4. 清理当前进程隔离变量

```powershell
& .\scripts\clean.ps1
```

清理脚本不会删除 starter 文件，只移除当前 PowerShell 进程中的 AWS 路径变量。

## Linux

```sh
cd work/142
. ./scripts/bootstrap.sh
sh scripts/check-sandbox.sh
sh scripts/verify.sh
. ./scripts/clean.sh
```

## 实验边界

`source_profile` 只选择“拿哪组来源凭据去尝试 AssumeRole”。真正成功还要求来源身份允许 `sts:AssumeRole`，目标 Role trust policy 信任来源主体，并且 STS endpoint 可达。本实验不验证这些远端条件。
