# Lab 134 知识点总结：
# - aws_iam_user 创建 IAM 身份主体；用户本身不自动拥有控制台密码、Access Key 或业务权限。
# - aws_iam_user_login_profile 为 IAM User 创建控制台登录密码，不用于 AWS CLI、SDK 或 API 认证。
# - aws_iam_access_key 创建长期编程凭据；id 是 Access Key ID，secret 是 Secret Access Key。
# - 通过 aws_iam_user.operator.name 引用用户名，会同时传值并建立隐式依赖，避免三个 API 被错误地并行调用。
# - password_reset_required = true 表示用户首次使用生成密码登录后必须修改密码。
# - sensitive = true 只会隐藏 CLI/UI 的常规显示，不会加密 Terraform state，也不会阻止有权读取 state 的人取得秘密。
# - 不使用 PGP 时，生成的控制台密码和 Access Key Secret 会以明文进入 state；本实验只允许在一次性 LocalStack 中观察该行为。
# - PGP 可以保护凭据的传递形式，但密钥分发、轮换和撤销仍需单独设计。
# - 真实企业环境应优先使用 IAM Identity Center、角色和短期凭据，避免为人员或工作负载创建长期 Access Key。
# - LocalStack 能验证 Terraform 资源、依赖、state 和销毁闭环，但不能验证真实 AWS 的 IAM policy、MFA 或登录体验。
#
# aws_iam_user.operator 已提供作为实验起点。请依次完成 TODO 1～3；每个 TODO 都有完整答案级 Hint。

resource "aws_iam_user" "operator" {
  name = "tf-pro-lab-134-operator"

  tags = {
    Course = "terraform-pro"
    Lab    = "134"
  }
}

# TODO 1：为 operator 创建控制台登录配置，并要求首次登录时修改密码。
# 关键点：user 必须引用 aws_iam_user.operator.name，不要再次手写用户名。
# 答案级 Hint：完整答案如下，取消注释即可：
#
resource "aws_iam_user_login_profile" "operator" {
  user                    = aws_iam_user.operator.name
  password_length         = 20
  password_reset_required = true
}

# TODO 2：为同一个 operator 创建一组长期 API Access Key。
# 关键点：这里是在 LocalStack 中识别资源与 state 行为，不代表生产环境推荐长期密钥。
# 答案级 Hint：完整答案如下，取消注释即可：
#
resource "aws_iam_access_key" "operator" {
  user   = aws_iam_user.operator.name
  status = "Active"
}

# TODO 3：输出可验证信息，并正确标记真正的秘密。
# Access Key ID 是标识符，不是秘密；Secret Access Key 和生成密码才是秘密。
# sensitive 只隐藏常规输出，秘密仍然存在于 Terraform state 中。
# 答案级 Hint：完整答案如下，取消注释即可：
#
output "iam_user_name" {
  description = "IAM user managed by this lab."
  value       = aws_iam_user.operator.name
}

output "password_reset_required" {
  description = "Whether the generated console password must be changed at first sign-in."
  value       = aws_iam_user_login_profile.operator.password_reset_required
}

output "access_key_id" {
  description = "Access Key ID; this identifies the credential but is not the secret half."
  value       = aws_iam_access_key.operator.id
}

output "access_key_status" {
  description = "Current status of the IAM user access key."
  value       = aws_iam_access_key.operator.status
}

output "access_key_secret" {
  description = "Secret Access Key generated only for the disposable LocalStack exercise."
  value       = aws_iam_access_key.operator.secret
  sensitive   = true
}

output "generated_console_password" {
  description = "Generated console password; plaintext state storage is acceptable only in this disposable sandbox."
  value       = aws_iam_user_login_profile.operator.password
  sensitive   = true
}
