# 第 106 节参考实现

本目录是第 106 节的已验证参考实现，主题是：AWS CLI config 与 credentials 文件。

## 本地验证

    $env:AWS_ACCESS_KEY_ID="test"
    $env:AWS_SECRET_ACCESS_KEY="test"
    $env:AWS_DEFAULT_REGION="us-east-1"
    $env:LOCALSTACK_ENDPOINT="http://localhost:4566"
    $env:TF_VAR_localstack_endpoint="http://localhost:4566"
    powershell -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
    powershell -ExecutionPolicy Bypass -File scripts\verify.ps1
    powershell -ExecutionPolicy Bypass -File scripts\clean.ps1

## 说明

该目录用于验证题目设计，不是上机做题目录。实际练习请使用 work/106/。
