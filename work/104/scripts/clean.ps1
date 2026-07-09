$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$buckets = @(
  "tf-pro-lab-104-bucket-0",
  "tf-pro-lab-104-bucket-1",
  "tf-pro-lab-104-bucket-2"
)

foreach ($bucket in $buckets) {
  aws --endpoint-url=$endpoint s3 rm "s3://$bucket" --recursive 2>$null
  aws --endpoint-url=$endpoint s3api delete-bucket --bucket $bucket 2>$null
}
Remove-Item -Recurse -Force .terraform, .terraform.lock.hcl, tfplan, aws-config, terraform.tfstate, terraform.tfstate.backup -ErrorAction SilentlyContinue
Write-Host "第 104 节本地文件已清理。"

