# 第 142 节任务：AWS CLI source_profile

## 本节主旨

理解 AWS CLI AssumeRole profile 的凭据链，而不是创建 Terraform 资源：

```text
credentials [base] test/test
             │
             ▼ source_profile = base
config [profile lab-142]
             │ role_arn
             ▼
目标 IAM Role（本 Lab 不实际连接）
```

## config 与 credentials 的职责

| 文件 | Section | 内容 |
|---|---|---|
| `config` | `[profile base]` | region、output 等配置 |
| `config` | `[profile lab-142]` | role_arn、source_profile、region |
| `credentials` | `[base]` | base 的 access key/secret key |

`lab-142` 不需要在 credentials 中再写密钥，因为它通过 `source_profile=base` 获取来源凭据。

## 动手任务

1. 在 `aws-config/config` 完成 base profile 的 region/output。
2. 完成 lab-142 的 region、source_profile 和 role_arn。
3. 在 `aws-config/credentials` 完成 base 的 `test/test` 测试凭据。
4. 不要创建 `[lab-142]` credentials section。
5. 使用 AWS CLI `configure get` 和验证脚本检查本地解析结果。

## source_profile 不等于授权

完整 AssumeRole 至少涉及：

1. AWS CLI 找到 base credentials；
2. base 身份的 permissions policy 允许 `sts:AssumeRole`；
3. 目标 Role trust policy 信任来源主体；
4. AWS CLI 调用 STS 换取短期 credentials。

本 Lab 只验证第 1 步以及配置链的结构，不声称 AssumeRole 已成功。

## 验收标准

- AWS CLI 从隔离文件读取 base region 为 `us-east-1`、output 为 `json`。
- lab-142 的 source_profile 精确为 `base`。
- role_arn 精确指向 LocalStack 模拟账号下的演示 Role。
- credentials 只有 `[base]`，值为 `test/test`。
- 文件中不包含 default、真实 AKIA/ASIA key 或 `[profile ...]` credentials section。
- 验证过程不发出网络请求。

## 限制

- 不读取或修改用户真实 `~/.aws` 文件。
- 不运行 `aws sts assume-role`、`aws s3 ls` 等联网命令。
- 不写入真实 AWS credentials。
- 不修改 `practice/labs/142/`。
