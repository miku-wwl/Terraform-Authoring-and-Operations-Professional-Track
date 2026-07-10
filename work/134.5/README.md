# Lab 134.5：企业环境下的 IAM 认证方式

Lab134 为了练习 Terraform resource，创建了 IAM User、控制台登录密码和长期 Access Key。

真实企业环境通常不会给员工或 CI/CD 长期保存 Access Key，而是使用集中身份、IAM Role 和短期凭据。

## 一、IAM Identity Center / SSO

IAM Identity Center 是企业员工进入 AWS 的统一登录入口，旧资料中经常称为 AWS SSO。

员工使用企业身份系统登录，例如：

- Microsoft Entra ID；
- Okta；
- Google Workspace；
- 企业 Active Directory。

登录过程通常包含密码、MFA 和企业身份验证。登录成功后，员工获得短期 AWS 凭据，而不是长期 access key。

```powershell
aws configure sso
aws sso login --profile company-dev
aws sts get-caller-identity --profile company-dev
```

Terraform 可以使用 SSO profile：

```hcl
provider "aws" {
  region  = "us-east-1"
  profile = "company-dev"
}
```

或者：

```powershell
$env:AWS_PROFILE = "company-dev"
terraform plan
```

SSO 主要解决的问题是：

```text
企业员工如何登录 AWS，以及如何统一管理员工身份。
```

## 二、IAM Role

IAM Role 不是某个具体人的长期账号，而是一组可以被临时扮演的权限集合。

例如：

```text
terraform-deployer
read-only-auditor
security-admin
```

Role 本身没有长期 access key。使用者需要先通过某种身份验证，然后临时扮演 Role。

```text
当前身份
    ↓ AssumeRole
IAM Role
    ↓
临时凭据
```

## 三、AssumeRole

AssumeRole 是通过 AWS STS，把当前身份临时切换成另一个 Role。

同账号和跨账号都可以使用 AssumeRole：

```text
同账号：开发人员 → 生产部署 Role

跨账号：开发账号 → 生产账号 terraform-deployer Role
```

Terraform Provider 中可以这样配置：

```hcl
provider "aws" {
  region  = "us-east-1"
  profile = "company-dev"

  assume_role {
    role_arn     = "arn:aws:iam::222222222222:role/terraform-deployer"
    session_name = "terraform-deploy"
  }
}
```

跨账号 AssumeRole 需要两个方向的授权：

```text
来源身份的 IAM policy
    → 允许 sts:AssumeRole

目标 Role 的 trust policy
    → 信任来源账号或来源身份
```

可以记成：

```text
A 说：我允许自己去扮演 B 的 Role。
B 说：我允许 A 来扮演我的 Role。
```

## 四、OIDC

OIDC 主要用于 CI/CD，不需要在 GitHub Actions、GitLab CI 或其他流水线中保存长期 AWS Secret Key。

典型流程：

```text
CI/CD 平台生成 OIDC 身份令牌
        ↓
AWS 验证 OIDC token
        ↓
AWS STS AssumeRoleWithWebIdentity
        ↓
获得短期 AWS 凭据
        ↓
Terraform plan/apply
```

例如 GitHub Actions 通过 OIDC 获取 AWS Role：

```text
GitHub repository / branch
        ↓
OIDC token
        ↓
AWS IAM OIDC provider
        ↓
terraform-deployer Role
        ↓
Terraform
```

目标 Role 的 trust policy 需要限制：

- 哪个 OIDC provider；
- 哪个组织或仓库；
- 哪个 branch 或 environment；
- 哪些 claims 可以扮演该 Role。

这样即使 GitHub Actions 代码不保存 AWS access key，也可以临时获得部署权限。

## 五、短期凭据

短期凭据一般包含：

```text
Access Key ID
Secret Access Key
Session Token
Expiration
```

它们有明确的过期时间：

```text
登录或 AssumeRole
    → 获得临时凭据
    → 在有效期内使用
    → 自动过期
```

相比长期 Access Key，短期凭据的优点是：

- 泄露后的有效时间更短；
- 可以通过 SSO 或 OIDC 自动获取；
- 不需要把 Secret Key 长期写入代码或 CI 配置；
- 更容易配合最小权限和审计；
- 员工离职或流水线变更时，不必逐个清理长期 key。

## 六、企业 Terraform 的典型组合

员工本地操作：

```text
企业 SSO
    ↓
IAM Identity Center permission set
    ↓
开发账号 Role
    ↓
Terraform
```

跨账号生产部署：

```text
员工 SSO
    ↓
开发账号身份
    ↓ AssumeRole
生产账号 terraform-deployer Role
    ↓
Terraform apply
```

CI/CD 自动部署：

```text
GitHub Actions / GitLab CI
    ↓ OIDC
AWS IAM OIDC provider
    ↓
部署 Role
    ↓
Terraform plan/apply
```

## 七、和 Lab134 的区别

Lab134：

```text
IAM User
├── Console Login Profile
└── Long-term Access Key
```

企业推荐方式：

```text
Human：SSO / IAM Identity Center
Workload：IAM Role
CI/CD：OIDC → IAM Role
跨账号：AssumeRole
认证结果：短期凭据
```

## 核心记忆

```text
SSO：人如何登录 AWS
IAM Role：权限集合
AssumeRole：临时切换到 Role
OIDC：CI/CD 如何不保存长期密钥
短期凭据：降低泄露后的长期风险
```

真实环境中，应避免把长期 AWS Access Key 写入：

```text
Terraform 文件
Git 仓库
CI/CD 变量
Docker image
日志和 output
```
