$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-113 --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-113 2>$null
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-113-a --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-113-a 2>$null
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-113-b --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-113-b 2>$null
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-113-dev --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-113-dev 2>$null
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-113-prod --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-113-prod 2>$null
Remove-Item -Recurse -Force .terraform,.terraform.lock.hcl,tfplan,aws-config 2>$null,terraform.tfstate,terraform.tfstate.backup

