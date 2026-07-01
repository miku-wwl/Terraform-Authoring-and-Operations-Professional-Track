module "iam_user" {
  source     = "./modules/iam"
  user_count = 3
}

moved {
  from = module.iam_user.aws_iam_user.this
  to   = module.iam_user.aws_iam_user.this[1]
}

output "user_names" {
  value = module.iam_user.user_names
}
