# Lab 32 知识点总结：
# - data source 用来读取 provider 当前可见的信息，不负责创建、修改或删除资源。
# - data block 写法是 data "<DATA_SOURCE_TYPE>" "<LOCAL_NAME>" { ... }；
#   类型和返回属性要查 provider 文档的 Data Sources。
# - resource 和 data source 都来自 provider，但用途、参数和返回属性可能不同。
# - data source 通常在 plan 阶段读取；如果依赖本次 apply 才确定的值，可能推迟到 apply。
# - 已由当前 Terraform resource 管理的资源，通常优先直接引用 resource 属性；
#   data source 更适合读取外部已有资源、当前 provider 身份、region、AMI、VPC 等信息。

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
