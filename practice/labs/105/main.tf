module "iam" {
  source = "./modules/iam"
}

module "storage" {
  source = "./modules/storage"
}

moved {
  from = aws_iam_user.platform
  to   = module.iam.aws_iam_user.platform
}

moved {
  from = aws_s3_bucket.audit
  to   = module.storage.aws_s3_bucket.audit
}

output "module_resources" {
  value = {
    user   = module.iam.user_name
    bucket = module.storage.bucket_name
  }
}
