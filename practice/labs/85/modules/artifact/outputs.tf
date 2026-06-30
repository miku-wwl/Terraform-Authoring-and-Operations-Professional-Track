output "artifact_path" {
  value = local_file.artifact.filename
}

output "artifact_name" {
  value = var.name
}
