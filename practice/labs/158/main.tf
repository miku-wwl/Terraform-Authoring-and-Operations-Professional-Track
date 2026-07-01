module "artifact_bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = "tf-pro-158-artifacts"
}

module "operator" {
  source    = "./modules/iam_user"
  user_name = "tf-pro-158-operator"
}

output "bucket_name" {
  value = module.artifact_bucket.bucket_name
}

output "operator_name" {
  value = module.operator.user_name
}
