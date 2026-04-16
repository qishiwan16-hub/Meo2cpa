# cpa 安装教程

## 项目简介

[`cpa`](Meo2cpa/README.md) 是当前工作区中的项目根目录说明文档入口，实际服务端项目代码位于 [`Meo2cpa/`](Meo2cpa/)。

项目仓库地址：`https://github.com/qishiwan16-hub/cpa`

如果你要运行服务，核心入口程序是 [`Meo2cpa/cmd/server/main.go`](Meo2cpa/cmd/server/main.go)，默认配置模板是 [`Meo2cpa/config.example.yaml`](Meo2cpa/config.example.yaml)。

---

## 安装方式概览

当前项目适合以下三种安装/运行方式：

1. 直接在本机通过 Go 源码构建运行
2. 使用 Docker 单容器运行
3. 在 Android Termux 环境中本地部署

如果你只是想快速启动，优先使用“源码运行”或“Docker 运行”。

---

## 方式一：源码安装运行（推荐）

### 1. 环境要求

请先安装以下基础环境：

- `Git`
- `Go 1.26` 或更高版本

可参考项目中的构建配置 [`Meo2cpa/Dockerfile`](Meo2cpa/Dockerfile)，当前镜像构建使用的是 `golang:1.26-alpine`。

### 2. 克隆项目

```bash
git clone https://github.com/qishiwan16-hub/cpa.git
cd cpa/Meo2cpa
```

### 3. 准备配置文件

将模板复制为正式配置：

```bash
cp config.example.yaml config.yaml
```

Windows PowerShell 可使用：

```powershell
Copy-Item .\config.example.yaml .\config.yaml
```

建议至少修改以下配置项，配置来源见 [`Meo2cpa/config.example.yaml`](Meo2cpa/config.example.yaml)：

- `host`
- `port`
- `auth-dir`
- `api-keys`
- `remote-management.secret-key`
- `remote-management.allow-remote`
- `logging-to-file`

### 4. 下载依赖并构建

```bash
go mod download
go build -o meo2cpa ./cmd/server
```

### 5. 启动服务

```bash
go run ./cmd/server
```

或者运行已编译二进制：

```bash
./meo2cpa
```

Windows 下：

```powershell
.\meo2cpa.exe
```

### 6. 验证是否启动成功

服务默认监听配置文件中的端口，模板默认端口为 `8317`。启动后可访问：

- 首页：`http://127.0.0.1:8317/`
- 管理接口：`http://127.0.0.1:8317/v0/management/...`

如果启用了管理功能，请确保已经正确设置 [`remote-management.secret-key`](Meo2cpa/config.example.yaml) 对应项。

---

## 方式二：Docker 安装运行

项目已提供 [`Meo2cpa/Dockerfile`](Meo2cpa/Dockerfile) 和 [`Meo2cpa/docker-compose.yml`](Meo2cpa/docker-compose.yml)。

### 1. 进入项目目录

```bash
cd cpa/Meo2cpa
```

### 2. 准备配置与数据目录

确保以下内容存在：

- [`config.yaml`](Meo2cpa/config.example.yaml)（由 `config.example.yaml` 复制得到）
- `auths/`
- `logs/`

示例：

```bash
cp config.example.yaml config.yaml
mkdir -p auths logs
```

### 3. 使用 Docker Compose 启动

```bash
docker compose up -d
```

根据 [`Meo2cpa/docker-compose.yml`](Meo2cpa/docker-compose.yml)，默认会：

- 暴露端口 `8317`
- 将本地 `config.yaml` 挂载到容器内 `/Meo2cpa/config.yaml`
- 将本地 `auths` 挂载到容器内 `/root/.meo2cpa`
- 将本地 `logs` 挂载到容器内 `/Meo2cpa/logs`

### 4. 查看日志

```bash
docker compose logs -f
```

### 5. 停止服务

```bash
docker compose down
```

---

## 方式三：Termux 安装运行

如果你在 Android 手机上部署，可直接参考 [`Meo2cpa/docs/termux-deploy.md`](Meo2cpa/docs/termux-deploy.md)。

这里给出简化步骤：

### 1. 安装依赖

```bash
pkg update && pkg upgrade
pkg install golang git curl jq termux-api termux-services
```

### 2. 克隆项目并进入目录

```bash
git clone https://github.com/qishiwan16-hub/cpa.git
cd cpa/Meo2cpa
```

### 3. 初始化目录

```bash
bash ./scripts/termux-bootstrap.sh
```

### 4. 一键启动

```bash
bash ./scripts/termux-start.sh
```

[`Meo2cpa/scripts/termux-start.sh`](Meo2cpa/scripts/termux-start.sh) 现在会自动完成以下准备工作：

- 自动执行 [`Meo2cpa/scripts/termux-bootstrap.sh`](Meo2cpa/scripts/termux-bootstrap.sh) 初始化目录
- 如果缺少 [`config.yaml`](Meo2cpa/config.example.yaml)，自动从 [`Meo2cpa/config.example.yaml`](Meo2cpa/config.example.yaml) 复制生成
- 如果缺少可执行二进制，自动调用 [`Meo2cpa/scripts/termux-build.sh`](Meo2cpa/scripts/termux-build.sh) 进行构建
- 自动创建 `auths`、`logs`、`run`、`panel`、`tmp` 目录

也就是说，在依赖已安装完成后，可以直接使用一个命令完成前期准备并启动：

```bash
bash ./scripts/termux-start.sh
```

### 5. 状态检查

```bash
bash ./scripts/termux-status.sh
```

更多细节请阅读 [`Meo2cpa/docs/termux-deploy.md`](Meo2cpa/docs/termux-deploy.md)。

---

## 常见初始化建议

首次安装后，建议优先完成以下操作：

1. 修改 [`config.yaml`](Meo2cpa/config.example.yaml) 中的基础监听配置
2. 设置 `api-keys`
3. 设置管理密钥 `remote-management.secret-key`
4. 根据你的部署环境调整 `auth-dir`
5. 如需本地调试，先将 `host` 设置为 `127.0.0.1`
6. 如需局域网访问，再改为 `0.0.0.0`

---

## 相关文件说明

- 项目主目录：[`Meo2cpa/`](Meo2cpa/)
- 启动入口：[`Meo2cpa/cmd/server/main.go`](Meo2cpa/cmd/server/main.go)
- 配置模板：[`Meo2cpa/config.example.yaml`](Meo2cpa/config.example.yaml)
- Docker 配置：[`Meo2cpa/docker-compose.yml`](Meo2cpa/docker-compose.yml)
- Docker 镜像构建：[`Meo2cpa/Dockerfile`](Meo2cpa/Dockerfile)
- Termux 部署文档：[`Meo2cpa/docs/termux-deploy.md`](Meo2cpa/docs/termux-deploy.md)
- 项目详细说明：[`Meo2cpa/README.md`](Meo2cpa/README.md)

---

## 补充说明

当前这个根目录 [`README.md`](README.md) 主要面向中文安装说明；更完整的项目功能介绍、SDK 文档入口和多语言说明位于 [`Meo2cpa/README.md`](Meo2cpa/README.md)、[`Meo2cpa/README_CN.md`](Meo2cpa/README_CN.md)、[`Meo2cpa/README_JA.md`](Meo2cpa/README_JA.md)。
