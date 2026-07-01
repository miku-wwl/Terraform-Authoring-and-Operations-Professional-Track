$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-110 --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-110 2>$null
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-110-a --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-110-a 2>$null
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-110-b --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-110-b 2>$null
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-110-dev --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-110-dev 2>$null
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-110-prod --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-110-prod 2>$null
Remove-Item -Recurse -Force .terraform,.terraform.lock.hcl,tfplan,aws-config 2>$null,terraform.tfstate,terraform.tfstate.backup

