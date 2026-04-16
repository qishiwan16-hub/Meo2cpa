# Meo2cpa 安装配置教程

项目地址：`https://github.com/qishiwan16-hub/Meo2cpa`

这份文档只保留安装、配置、启动、更新。

## 一键安装

在项目根目录执行：

```bash
bash ./scripts/termux-start.sh
```

这条命令会自动完成以下事情：

- 自动创建运行目录
- 自动复制 [`config.example.yaml`](config.example.yaml) 为 [`config.yaml`](config.yaml)（如果还没有配置文件）
- 自动准备运行所需目录
- 自动检测二进制
- 自动构建并启动服务

启动后默认访问地址：

- 服务地址：`http://127.0.0.1:8317`
- 管理首页：`http://127.0.0.1:8317/`

## 一键配置

首次安装后，只需要改一个文件：[`config.yaml`](config.yaml)

如果 [`config.yaml`](config.yaml) 不存在，执行安装命令后会自动生成。

你需要至少补好以下内容之一：

- 你的 OAuth 账号登录配置
- 你的 API Key 配置
- 你的上游服务配置

如果只是先跑起来，可以先用自动生成的 [`config.yaml`](config.yaml)，后面再改。

## 一键启动

```bash
bash ./scripts/termux-start.sh
```

如果已经在运行，再执行也不会重复启动。

## 查看运行状态

```bash
bash ./scripts/termux-status.sh
```

## 停止运行

前台运行时：直接按 `Ctrl+C`

如果你是通过脚本后台启动的，可以执行：

```bash
bash ./scripts/termux-stop.sh
```

## 一键重启

```bash
bash ./scripts/termux-restart.sh
```

## 一键更新

```bash
git pull && cp -n config.example.yaml config.yaml && bash ./scripts/termux-start.sh
```

这条命令会自动完成：

- 拉取最新代码
- 如果本地没有 [`config.yaml`](config.yaml)，自动补一个
- 自动重新启动最新版服务

如果你希望更新后强制重启一次，执行：

```bash
git pull && cp -n config.example.yaml config.yaml && bash ./scripts/termux-restart.sh
```

## 最少命令清单

只记这 4 条就够了：

### 安装 / 启动

```bash
bash ./scripts/termux-start.sh
```

### 状态

```bash
bash ./scripts/termux-status.sh
```

### 停止

```bash
bash ./scripts/termux-stop.sh
```

### 更新

```bash
git pull && cp -n config.example.yaml config.yaml && bash ./scripts/termux-restart.sh
```

## 配置文件说明

主配置文件：[`config.yaml`](config.yaml)

示例配置文件：[`config.example.yaml`](config.example.yaml)

认证数据目录：[`auths/`](auths)

如果你已经完成过登录或配置，更新时不要删除这些文件。

## 常见说明

### 为什么我只想输一条命令？

因为 [`scripts/termux-start.sh`](scripts/termux-start.sh) 已经做了自动初始化、自动补配置、自动构建、自动启动。

### 为什么停止要写 `Ctrl+C`？

因为前台运行程序最直接的停止方式就是 `Ctrl+C`。

### 更新会不会覆盖我的配置？

上面的更新命令使用的是 `cp -n`，只有当 [`config.yaml`](config.yaml) 不存在时才会补配置，不会直接覆盖你现有配置。
