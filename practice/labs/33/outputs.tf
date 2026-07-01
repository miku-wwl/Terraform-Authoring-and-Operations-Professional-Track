output "production_instance_id" {
  description = "通过精确 tag filter 匹配到的单台生产实例"
  value       = data.aws_instance.production.id
}

output "all_lab_instance_ids" {
  description = "通过 aws_instances 匹配到的全部实验实例"
  value       = data.aws_instances.all_lab.ids
}

output "all_lab_instance_count" {
  description = "实验实例数量"
  value       = length(data.aws_instances.all_lab.ids)
}
