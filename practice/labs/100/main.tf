module "buckets" {
  source = "./modules/buckets"
  providers = {
    aws      = aws
    aws.prod = aws.prod
  }
}

output "bucket_names" { value = module.buckets.bucket_names }
