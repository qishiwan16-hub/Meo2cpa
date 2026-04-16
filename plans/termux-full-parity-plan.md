# Meo2cpa Termux 全功能一致性改造计划

## 项目目标

将 [`CLIProxyAPI`](CLIProxyAPI) 作为基础，改造为名为 [`Meo2cpa`](CLIProxyAPI) 的项目，使其能够在安卓手机的 Termux 环境中本地部署运行，并实现与其他部署方式完全一致的功能能力。

## 范围定义

必须在 Termux 上完整支持以下能力：

- 所有现有 provider 的 OAuth 登录与认证刷新
- 完整 [`Management API`](CLIProxyAPI/internal/api/server.go:631)
- 完整 [`TUI`](CLIProxyAPI/cmd/server/main.go:95) 与 [`--standalone`](CLIProxyAPI/cmd/server/main.go:96)
- 后台运行、状态管理、开机启动、异常恢复
- 管理面板下载与自动更新 [`StartAutoUpdater()`](CLIProxyAPI/internal/managementasset/updater.go:58)
- 配置热更新、认证文件存储、日志、usage 等现有运行能力

## Done Definition

只有同时满足以下条件，才视为完成：

- Termux 上可编译并启动主程序
- 所有 provider 登录链路可用
- 管理 API 与面板可用且可自动更新
- TUI 在 Termux 终端中完整可操作
- 后台守护、重启、状态查看、日志查看可用
- 配置、auth、日志、热更新行为与其他部署一致
- 已补齐文档、脚本、配置模板与测试验证记录

## 改造工作包

### 1. 平台抽象层

目标：让 Termux 成为一等平台，而不是 Linux 降级分支。

任务：
- 新增平台探测模块
- 抽象 Termux 环境识别、目录策略、运行能力探测
- 统一浏览器能力、后台能力、路径能力探测接口

建议文件：
- `internal/platform/termux.go`
- `internal/platform/runtime.go`
- `internal/platform/browser.go`

### 2. 浏览器与 OAuth 兼容层

目标：所有 provider 的 OAuth 在 Termux 上达到正式可用标准。

任务：
- 改造 [`internal/browser/browser.go`](CLIProxyAPI/internal/browser/browser.go:23)
- 优先支持 `termux-open-url`
- 支持 Android `am start`
- 保留普通 Linux 与其他平台兼容逻辑
- 逐个验证 Gemini、Claude、Codex、iFlow、Antigravity、Kimi 登录流
- 统一本地回调、手动回调、管理 API 发起 OAuth 的处理方式

重点文件：
- [`internal/browser/browser.go`](CLIProxyAPI/internal/browser/browser.go:23)
- [`internal/auth/gemini/gemini_auth.go`](CLIProxyAPI/internal/auth/gemini/gemini_auth.go:206)
- [`internal/auth/claude/oauth_server.go`](CLIProxyAPI/internal/auth/claude/oauth_server.go:66)
- [`internal/auth/codex/oauth_server.go`](CLIProxyAPI/internal/auth/codex/oauth_server.go:63)
- [`internal/auth/iflow/oauth_server.go`](CLIProxyAPI/internal/auth/iflow/oauth_server.go:43)
- [`internal/api/handlers/management/auth_files.go`](CLIProxyAPI/internal/api/handlers/management/auth_files.go:132)

### 3. Termux 运维模型

目标：让 Termux 部署具备与服务器部署一致的运维体验。

任务：
- 增加启动、停止、重启、状态查询脚本
- 增加日志查看与 PID 管理
- 设计开机自启方案
- 设计异常恢复与后台保活方案
- 明确正式部署目录结构

建议文件：
- `scripts/termux-bootstrap.sh`
- `scripts/termux-start.sh`
- `scripts/termux-stop.sh`
- `scripts/termux-restart.sh`
- `scripts/termux-status.sh`

### 4. TUI 与管理面板一致性

目标：让移动终端下的交互功能与其他平台保持一致。

任务：
- 验证并修复 TUI 在 Termux 小屏终端中的可操作性
- 验证 [`internal/tui`](CLIProxyAPI/internal/tui) 各功能页签
- 验证 [`StartAutoUpdater()`](CLIProxyAPI/internal/managementasset/updater.go:58) 在 Termux 上持续工作
- 验证管理面板静态文件下载、更新、访问与联动操作

重点范围：
- `internal/tui/app.go`
- `internal/tui/auth_tab.go`
- `internal/tui/config_tab.go`
- `internal/tui/logs_tab.go`
- `internal/tui/oauth_tab.go`
- `internal/tui/usage_tab.go`
- [`internal/managementasset/updater.go`](CLIProxyAPI/internal/managementasset/updater.go:58)

### 5. 文档、模板与验证

目标：让 Meo2cpa 具备正式交付条件。

任务：
- 输出 Termux 部署文档
- 输出 Termux 示例配置
- 输出一致性验收矩阵
- 增加平台验证记录与回归测试说明

建议文件：
- `docs/termux-deploy.md`
- `examples/config.termux.yaml`
- `plans/termux-validation-matrix.md`

## 推荐实施顺序

- 第一阶段：构建与平台探测
- 第二阶段：浏览器与 OAuth 打通
- 第三阶段：后台运行与管理能力对齐
- 第四阶段：TUI 与管理面板验证修复
- 第五阶段：文档、模板、验收矩阵与收尾

## 风险清单

### 高风险

- [`go.mod`](CLIProxyAPI/go.mod:3) 所要求的 Go 版本在 Termux 上的可获得性
- 安卓浏览器对 localhost 回调的兼容差异
- 不同 provider 对移动端 OAuth 回调链路的兼容差异
- 安卓后台进程保活与开机自启稳定性

### 中风险

- TUI 在软键盘与小屏终端中的交互体验
- 自动更新在移动网络环境中的稳定性
- 剪贴板、浏览器、系统命令等辅助能力在 Termux 上的行为差异

### 低风险

- 主 HTTP 服务与 Management API 核心逻辑
- 配置热更新、日志、auth 文件机制

## 验收矩阵

### 构建与运行
- [ ] Termux 上完成构建
- [ ] 主服务可启动
- [ ] 配置文件可加载
- [ ] 热更新可工作

### Provider
- [ ] Gemini OAuth 可用
- [ ] Claude OAuth 可用
- [ ] Codex OAuth 可用
- [ ] iFlow OAuth 可用
- [ ] Antigravity OAuth 可用
- [ ] Kimi 登录流可用

### 管理能力
- [ ] Management API 全量可用
- [ ] 管理面板可访问
- [ ] 管理面板自动下载可用
- [ ] 管理面板自动更新可用
- [ ] auth 文件上传下载删除可用

### TUI
- [ ] `--tui` 可正常运行
- [ ] `--standalone` 可正常运行
- [ ] 主要页签完整可操作

### 运维
- [ ] 可后台运行
- [ ] 可查询状态
- [ ] 可停止和重启
- [ ] 可开机启动
- [ ] 异常恢复可用

## 结论

Meo2cpa 的目标应定义为：

> 在不改变核心产品能力模型的前提下，将 [`CLIProxyAPI`](CLIProxyAPI) 系统性升级为一个对 Termux 安卓本地部署正式一等支持的版本，实现与其他部署方式完全一致的功能、交互与运维能力。
