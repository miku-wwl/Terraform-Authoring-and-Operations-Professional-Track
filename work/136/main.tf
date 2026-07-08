# Lab 136 知识点总结：
# - `aws_iam_policy_document` 是数据源，用 HCL 结构生成 IAM policy JSON。
# - 相比手写 JSON，它更容易组合、校验和维护。
# - `statement` 中定义 effect、actions、resources 等策略内容。
# - 生成的 JSON 通过 `.json` 属性传给 `aws_iam_policy.policy`。

# TODO: 使用 data "aws_iam_policy_document" 生成策略，再交给 aws_iam_policy。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# data "aws_iam_policy_document" "read_logs" {
#   statement {
#     sid    = "ReadLogs"
#     effect = "Allow"
#
#     actions = [
#       "logs:DescribeLogGroups",
#       "logs:GetLogEvents"
#     ]
#
#     resources = ["*"]
#   }
# }
#
# resource "aws_iam_policy" "read_logs" {
#   name   = "tf-pro-lab-136-read-logs"
#   policy = data.aws_iam_policy_document.read_logs.json
# }
#
# output "policy_json" {
#   value = data.aws_iam_policy_document.read_logs.json
# }
#
# output "policy_arn" {
#   value = aws_iam_policy.read_logs.arn
# }
