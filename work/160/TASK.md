# 第 160 节任务：挑战三概览：AWS Provider 集成

## 背景

本题来自第 160 节课程内容，属于综合挑战的理论/准备阶段。目标不是创建 AWS 资源，而是明确后续挑战的解题方法、题型范围和练习节奏。

## 要求

- 理解 AWS provider 在挑战中的位置。
- 识别 profile、alias、default_tags 和 caller identity 的组合。
- 为 161~162 做准备。

## 验收

完成后执行：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
powershell -ExecutionPolicy Bypass -File scripts\verify.ps1
powershell -ExecutionPolicy Bypass -File scripts\clean.ps1
```

## 限制

- 不要启动真实 AWS 资源。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/160/`。
