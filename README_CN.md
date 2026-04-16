# Meo2cpa 安装配置教程

项目地址：`https://github.com/qishiwan16-hub/Meo2cpa`

这份文档只保留安装、配置、启动、停止、重启、更新。

## 一键安装

安装只负责安装，不负责启动。

```bash
bash ./scripts/termux-bootstrap.sh
```

这条命令会自动完成：

- 自动安装 Termux 依赖
- 自动创建运行目录
- 自动生成 [`config.yaml`](config.yaml)（如果不存在）
- 自动构建二进制文件

安装完成后，再单独执行启动命令。

## 一键启动

启动只负责启动，不重复做安装。

```bash
bash ./scripts/termux-start.sh
```

启动前请先确保已经执行过安装命令。

启动后默认访问地址：

- 服务地址：`http://127.0.0.1:8317`
- 管理首页：`http://127.0.0.1:8317/`

## 配置文件

主配置文件：[`config.yaml`](config.yaml)

示例配置文件：[`config.example.yaml`](config.example.yaml)

首次安装后如果还没改配置，直接编辑 [`config.yaml`](config.yaml) 即可。

## 查看状态

```bash
bash ./scripts/termux-status.sh
```

## 停止运行

如果你是前台直接运行程序，停止方式就是 `Ctrl+C`。

如果你是脚本后台启动，执行：

```bash
bash ./scripts/termux-stop.sh
```

## 一键重启

```bash
bash ./scripts/termux-restart.sh
```

## 一键更新

```bash
git pull && cp -n config.example.yaml config.yaml && bash ./scripts/termux-build.sh && bash ./scripts/termux-restart.sh
```

这条命令会自动完成：

- 拉取最新代码
- 如果缺少 [`config.yaml`](config.yaml) 就自动补上
- 重新构建最新版本
- 重启服务

## 最少只记这几条

### 安装

```bash
bash ./scripts/termux-bootstrap.sh
```

### 启动

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
git pull && cp -n config.example.yaml config.yaml && bash ./scripts/termux-build.sh && bash ./scripts/termux-restart.sh
```

## 说明

[`scripts/termux-bootstrap.sh`](scripts/termux-bootstrap.sh) 现在只负责安装。

[`scripts/termux-start.sh`](scripts/termux-start.sh) 现在只负责启动。

这样安装和启动已经完全拆开，不会再混在一条命令里。
