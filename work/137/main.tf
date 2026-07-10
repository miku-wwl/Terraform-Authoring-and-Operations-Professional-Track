# Lab 137 知识点总结：
# - IAM Role 是可被可信主体临时扮演的身份，不像 IAM User 那样拥有长期密码或 Access Key。
# - 每个普通 IAM Role 都必须有 trust policy，也叫 assume role policy；它回答“谁能扮演角色”。
# - permissions policy 回答“扮演成功后能做什么”；trust policy 本身不会授予 S3、EC2 等业务权限。
# - Role trust policy 是附着在 Role 上的 resource-based policy，必须包含 Principal。
# - EC2 的 service principal 是 ec2.amazonaws.com；不要用 Principal="*" 放宽信任边界。
# - sts:AssumeRole 是信任策略允许的角色会话动作，不等于给角色授予 STS 管理权限。
# - aws_iam_policy_document 用 principals block 生成 JSON 中的 Principal 对象。
# - assume_role_policy 直接接收 JSON 字符串，因此可引用 data source 的 `.json` 建立依赖。
# - HCL 的 actions/identifiers 是 list；单元素在最终 JSON 中可能规范化成字符串，IAM 语义等价。
# - EC2 Role 真正挂到实例上通常还需要 Instance Profile，并且创建实例的人需要 iam:PassRole；这些不属于本 Lab。
# - LocalStack 能验证 Role 和 trust JSON 的创建/销毁，但不能证明真实 EC2 能取得临时凭据或权限策略有效。
#
# 请依次完成 TODO 1～3；每个 TODO 都有完整答案级 Hint。

# TODO 1：用 aws_iam_policy_document 创建只信任 EC2 服务的 trust policy。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# data "aws_iam_policy_document" "ec2_trust" {
#   statement {
#     sid     = "AllowEC2AssumeRole"
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]
#
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }

# TODO 2：创建 IAM Role，并把生成的 trust JSON 传给 assume_role_policy。
# 本 Lab 故意不创建 permissions policy，用来突出“可被 assume”不等于“拥有业务权限”。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# resource "aws_iam_role" "ec2" {
#   name               = "tf-pro-lab-137-ec2-role"
#   description        = "Disposable LocalStack role trusted only by the EC2 service principal."
#   assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
#
#   tags = {
#     Course = "terraform-pro"
#     Lab    = "137"
#   }
# }

# TODO 3：输出 Role 身份和 Role 实际保存的 trust policy 语义。
# 使用 jsondecode 比较 Principal/Action，而不是比较 JSON 空格和 key 顺序。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# output "role_identity" {
#   description = "Identity of the LocalStack IAM role."
#   value = {
#     name = aws_iam_role.ec2.name
#     arn  = aws_iam_role.ec2.arn
#   }
# }
#
# output "trust_policy_document" {
#   description = "Trust policy stored on the role, decoded for semantic inspection."
#   value       = jsondecode(aws_iam_role.ec2.assume_role_policy)
# }
