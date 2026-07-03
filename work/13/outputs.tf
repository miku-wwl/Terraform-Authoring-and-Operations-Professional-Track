output "security_findings" {
  description = "Checkov 静态扫描发现的安全风险。"
  value       = local.security_findings
}
