# Meo2cpa 安装配置教程

项目地址：`https://github.com/qishiwan16-hub/Meo2cpa`

你说得对，上一版默认你已经把仓库拉到本地了，这一步漏了。

这次改成从 **完全没装** 开始写。

## 第 1 步：先把项目下载到本地

如果你本地还没有项目，先执行：

```bash
pkg install -y git && git clone https://github.com/qishiwan16-hub/Meo2cpa.git && cd Meo2cpa
```

这一步做的事情只有两件：

- 安装 [`git`](README.md)
- 把项目拉到本地目录 [`Meo2cpa/`](README.md)

## 第 2 步：一键安装

进入项目目录后执行：

```bash
bash ./scripts/termux-bootstrap.sh
```

这条命令只负责安装，不负责启动。

它会自动完成：

- 安装 Termux 依赖
- 创建运行目录
- 生成 [`config.yaml`](config.yaml)（如果不存在）
- 构建二进制文件

## 第 3 步：改配置

安装完成后，只需要改这个文件：[`config.yaml`](config.yaml)

你至少要补一个可用项：

- OAuth 登录配置
- API Key
- 上游服务配置

## 第 4 步：一键启动

```bash
bash ./scripts/termux-start.sh
```

这条命令现在只负责启动，并且是**前台运行**。

启动后默认访问地址：

- 服务地址：`http://127.0.0.1:8317`
- 管理首页：`http://127.0.0.1:8317/`

## 停止运行

启动后直接按 `Ctrl+C`，项目就会立即停止。

## 一键重启

先按 `Ctrl+C` 停掉当前进程，再重新执行：

```bash
bash ./scripts/termux-start.sh
```

## 一键更新

先进入项目目录，再执行：

```bash
git pull && cp -n config.example.yaml config.yaml && bash ./scripts/termux-build.sh
```

这条命令会自动完成：

- 拉取最新代码
- 如果本地没有 [`config.yaml`](config.yaml) 就自动补一个
- 重新构建

更新完成后，手动执行 [`scripts/termux-start.sh`](scripts/termux-start.sh) 启动，停止时直接按 `Ctrl+C`。

## 真正最少命令

### 没安装过

```bash
pkg install -y git && git clone https://github.com/qishiwan16-hub/Meo2cpa.git && cd Meo2cpa && bash ./scripts/termux-bootstrap.sh
```

### 已经安装过，只启动

```bash
cd Meo2cpa && bash ./scripts/termux-start.sh
```

### 更新

```bash
cd Meo2cpa && git pull && cp -n config.example.yaml config.yaml && bash ./scripts/termux-build.sh
```

## 现在的规则很简单

- [`scripts/termux-bootstrap.sh`](scripts/termux-bootstrap.sh)：只负责安装
- [`scripts/termux-start.sh`](scripts/termux-start.sh)：只负责前台启动
- 停止运行：`Ctrl+C`

这次文档已经把“仓库还没拉下来”这一步补上了。
