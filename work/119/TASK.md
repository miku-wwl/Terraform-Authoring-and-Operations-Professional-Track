# Terraform 实操训练 119：HCP Terraform 账号与组织初始化信息建模

## 1. 背景

本目录是 `work/119` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 HCP Terraform 账号注册与组织初始化信息建模练习。

本节视频的重点是：HCP Terraform 是托管服务，入口是 `app.terraform.io`；第一次使用时需要创建免费账号，填写 username、email、password，完成邮箱验证，然后创建第一个 organization。

真实注册动作应该在浏览器里完成，不应该把真实密码写进 Terraform 代码。本 lab 只使用 mock 数据和非真实邮箱，训练你把注册流程、账号身份和 organization 命名规则建模成可验证的 Terraform 输出。

## 2. 核心主题

- HCP Terraform hosted service：使用 `https://app.terraform.io` 作为入口。
- Account bootstrap：username、email、password 是注册账号的核心输入。
- Email verification：账号创建后需要完成邮箱确认。
- Organization bootstrap：邮箱确认后创建第一个 organization。
- 安全边界：不要把真实 password 作为 Terraform output 输出。
- `jsondecode(file(...))`：读取本地 mock 注册流程数据。
- 字符串处理：用 `lower()`、`replace()` 生成 organization slug。

## 3. 任务目标

请在 `main.tf` 中完成七个 TODO：

1. 用 `jsondecode(file("${path.module}/data/hcp_signup.json"))` 读取并解析 mock 数据。
2. 从 mock 数据中读取 HCP Terraform portal URL。
3. 从 mock 数据中读取注册账号需要的字段列表。
4. 配置非真实练习账号身份：
   - username：`lab119-user`
   - email：`student+lab119@example.com`
5. 从 mock 数据中读取邮箱验证要求。
6. 配置第一个 organization：
   - organization name：`lab119-learning-org`
   - organization slug：由 organization name 转成小写，并把空格替换成连字符。
7. 生成 onboarding checklist，顺序必须是：
   - `Open https://app.terraform.io`
   - `Create account with username/email/password`
   - `Verify email address`
   - `Create first organization lab119-learning-org`

完成后运行 `README.md` 中的命令。

## 4. 验收方式

基础检查：

```sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
```

可选观察输出：

```sh
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

## 5. 预期结果

- `terraform test` 返回 `1 passed, 0 failed`。
- `terraform output portal_url` 显示 `https://app.terraform.io`。
- `terraform output account_fields` 显示 `username`、`email`、`password`。
- `terraform output account_identity` 只显示 username 和 email，不显示 password。
- `terraform output email_verification_required` 显示 `true`。
- `terraform output organization_name` 显示 `lab119-learning-org`。
- `terraform output organization_slug` 显示 `lab119-learning-org`。
- `terraform output onboarding_checklist` 显示四个账号/组织初始化步骤。

## 6. 约束

- 不要把真实 HCP Terraform 账号、真实邮箱、真实密码写进本 lab。
- 不要输出 password。
- 不要硬编码 portal URL 和 account fields，必须从 `data/hcp_signup.json` 读取。
- JSON 文件路径必须基于 `path.module` 构造。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
