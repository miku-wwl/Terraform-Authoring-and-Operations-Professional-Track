$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-state-localstack/labs/79/ --recursive 2>$null
Remove-Item -Recurse -Force network\.terraform,network\.terraform.lock.hcl,network\tfplan,consumer\.terraform,consumer\.terraform.lock.hcl,consumer\tfplan 2>$null
