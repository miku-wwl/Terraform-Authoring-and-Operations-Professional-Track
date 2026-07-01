# 第 150 节任务：Terraform 综合挑战训练方法

## 背景

本题来自第 150 节课程内容，属于综合挑战的理论/准备阶段。目标不是创建 AWS 资源，而是明确后续挑战的解题方法、题型范围和练习节奏。

## 要求

- 理解综合挑战的考试节奏和解题纪律。
- 明确只能依赖官方文档的训练方式。
- 建立先读题、再定位资源、最后验证销毁的流程。

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
- 不要修改 `practice/labs/150/`。
