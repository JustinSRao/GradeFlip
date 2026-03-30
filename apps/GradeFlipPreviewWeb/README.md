# GradeFlipPreviewWeb

This is a Windows-runnable local preview harness for GradeFlip.

Purpose:

- exercise offline interactions from a browser on Windows
- verify deck editing and study behavior without Apple runtimes
- verify online and AI shell integration states without live service credentials
- complement shared Swift package tests

Non-goals:

- replacing the native Apple app
- proving iPhone, iPad, or macOS runtime correctness
- shipping to end users

Launch from the project root:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\start-preview-web.ps1
```
