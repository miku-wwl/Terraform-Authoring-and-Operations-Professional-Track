# Module iam 知识点总结：
# - 这个子模块接管原来 root module 中的 IAM user。
# - moved block 写在 root module 中，但 to 地址会指向这里的 module.iam.aws_iam_user.platform。
# - 子模块通过 output 暴露 user_name，供 root module 继续引用。

# TODO: IAM 子模块。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_iam_user" "platform" {
#   name = "tf-pro-lab-105-platform"
# }
#
# output "user_name" {
#   value = aws_iam_user.platform.name
# }
