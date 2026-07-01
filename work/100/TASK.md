# 第 100 节任务

## 背景

模块中的多 Provider 配置

## 要求

1. 在 root module 中定义默认 AWS provider 和 alias provider。
2. 通过 module 的 providers map 把 alias provider 传入子模块。
3. 在子模块中声明 configuration_aliases，并让一个资源使用 alias provider。

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/100/`。
