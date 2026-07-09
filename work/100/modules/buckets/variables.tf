# 子模块不应该把 bucket 名称写死。
# root module 通过 module 参数把业务输入传进来。
variable "bucket_names" {
  description = "Bucket names to create with the default and alias AWS providers."

  type = object({
    dev  = string
    prod = string
  })
}
