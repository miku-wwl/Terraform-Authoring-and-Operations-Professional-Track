module "storage" {
  source      = "./modules/s3_bucket"
  bucket_name = "tf-pro-159-storage"
}

locals {
  refactor_map = {
    old_address  = "aws_s3_bucket.challenge"
    new_address  = "module.storage.aws_s3_bucket.this"
    state_action = "use moved block or terraform state mv when state already exists"
  }
}

output "bucket_name" {
  value = module.storage.bucket_name
}

output "refactor_map" {
  value = local.refactor_map
}
