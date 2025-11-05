# Ubuntu 开发环境

一个基于 Docker 的 Ubuntu 开发环境，预装了常用的开发工具和 code-server，提供完整的云端开发体验。

dockerhub：https://hub.docker.com/r/anarckk/ubuntu-dev-env

github: https://github.com/anarckk/ubuntu-dev-env

## Docker Hub 部署

本项目已部署到 Docker Hub，可以直接拉取使用：

```bash
docker pull anarckk/ubuntu-dev-env:latest
```

## 项目概述

这个项目提供了一个完整的 Ubuntu 开发环境 Docker 镜像，包含了现代开发所需的核心工具链。通过 code-server，您可以在浏览器中访问完整的 VS Code 开发环境。

## 功能特性

- 🐳 **基于 Docker** - 使用 Ubuntu 24.04 作为基础镜像
- ☕ **Java 开发** - 预装 OpenJDK 21
- 🟢 **Node.js 开发** - 预装 Node.js 18 和 npm
- 🐋 **容器化工具** - 预装 Docker 和 Docker Compose
- 💻 **Web IDE** - 集成 code-server (VS Code in browser)
- 🔧 **开发工具** - 包含 Git、curl、wget 等常用工具

## 预装软件

- **操作系统**: Ubuntu 24.04
- **Java**: OpenJDK 21
- **Node.js**: 18.x LTS
- **Docker**: 最新稳定版
- **Docker Compose**: 最新插件版
- **code-server**: 最新版
- **开发工具**: Git, curl, wget, SSH client 等

## 快速开始

### 方式一：直接使用 Docker Hub 镜像（推荐）

```bash
# 拉取最新镜像
docker pull anarckk/ubuntu-dev-env:latest

# 运行开发环境
docker run -d \
  --name ubuntu-dev-env \
  -p 8080:8080 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd)/workspace:/root/workspace \
  anarckk/ubuntu-dev-env:latest
```

### 方式二：本地构建镜像

```bash
# 使用构建脚本
./build.sh

# 或手动构建
docker build -t anarckk/ubuntu-dev-env:latest .

# 运行容器
docker run -d \
  --name ubuntu-dev-env \
  -p 8080:8080 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd)/workspace:/root/workspace \
  anarckk/ubuntu-dev-env:latest
```

### 访问开发环境

1. 在浏览器中打开 `http://localhost:8080`
2. 使用以下凭据登录：
   - **密码**: `password123`

## 配置说明

### code-server 配置

code-server 已预配置：
- 绑定地址: `0.0.0.0:8080`
- 认证方式: 密码认证
- 默认密码: `password123`
- 工作目录: `/root/workspace`

### 环境变量

- `JAVA_HOME`: `/usr/lib/jvm/java-21-openjdk-amd64`
- `PATH`: 包含 Java 和系统路径

## 使用示例

### Java 开发

```bash
# 在容器内编译和运行 Java 程序
javac HelloWorld.java
java HelloWorld
```

### Node.js 开发

```bash
# 在容器内运行 Node.js 应用
node app.js
npm install
npm start
```

### Docker 开发

```bash
# 在容器内构建和运行其他 Docker 镜像
docker build -t my-app .
docker run my-app
```

## 目录结构

```
ubuntu-dev-env/
├── Dockerfile          # Docker 镜像构建文件
├── build.sh           # 构建脚本
└── README.md          # 项目说明文档
```

## 开发建议

### Docker in Docker

要使用容器内的 Docker，需要挂载 Docker socket：

```bash
-v /var/run/docker.sock:/var/run/docker.sock
```

### 自定义配置

要修改 code-server 配置，可以在运行容器后编辑：

```bash
docker exec -it ubuntu-dev-env bash
vi /root/.config/code-server/config.yaml
```

## 安全注意事项

⚠️ **重要安全提示**:

- 默认密码 `password123` 仅用于演示，生产环境请务必修改
- 避免在公共网络中使用默认密码
- 考虑使用更安全的认证方式
- 定期更新镜像以获取安全补丁

## 故障排除

### 端口冲突

如果 8080 端口被占用，可以映射到其他端口：

```bash
-p 8081:8080
```

### 权限问题

确保挂载的目录有适当的读写权限。

### 连接问题

检查防火墙设置，确保端口 8080 可访问。

## 许可证

本项目采用 MIT 许可证。

## 联系方式

- 维护者: anarckk
- 邮箱: anarckk@gmail.com