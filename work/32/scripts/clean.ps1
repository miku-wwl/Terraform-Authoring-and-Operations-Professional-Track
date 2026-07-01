Remove-Item -Recurse -Force .terraform -ErrorAction SilentlyContinue
Remove-Item -Force .terraform.lock.hcl, tfplan, terraform.tfstate, terraform.tfstate.backup -ErrorAction SilentlyContinue
Write-Host "Lab 32 清理完成"
