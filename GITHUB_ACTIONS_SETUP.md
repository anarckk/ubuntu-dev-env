# GitHub Actions Docker Hub 自动部署配置说明

## 概述

此文档说明如何配置 GitHub Actions 来自动构建 Docker 镜像并推送到 Docker Hub，同时自动更新 Docker Hub 上的 README 描述。

## 配置步骤

### 1. 创建 Docker Hub 访问令牌

1. 登录 [Docker Hub](https://hub.docker.com)
2. 点击右上角头像，选择 "Account Settings"
3. 在左侧菜单选择 "Security"
4. 点击 "New Access Token"
5. 输入令牌名称（例如：`github-actions-ubuntu-dev-env`）
6. 选择访问权限（建议选择 "Read, Write, Delete"）
7. 点击 "Generate" 创建令牌
8. **重要**：立即复制生成的令牌并妥善保存，因为之后无法再次查看

### 2. 配置 GitHub Secrets

在 GitHub 仓库中配置以下 secrets：

1. 进入您的 GitHub 仓库
2. 点击 "Settings" 标签
3. 在左侧菜单选择 "Secrets and variables" → "Actions"
4. 点击 "New repository secret" 添加以下两个 secret：

#### 必需配置的 Secrets：

- **`DOCKERHUB_USERNAME`**：您的 Docker Hub 用户名（例如：`anarckk`）
- **`DOCKERHUB_TOKEN`**：您在步骤1中创建的访问令牌

### 3. 工作流触发条件

配置的工作流会在以下情况下自动运行：

- **推送代码到 main 分支**：自动构建并推送到 Docker Hub
- **创建 Pull Request 到 main 分支**：仅构建测试，不推送
- **手动触发**：可以通过 GitHub Actions 界面手动运行

## 工作流功能说明

### 自动构建功能

1. **多架构支持**：使用 Docker Buildx 构建多平台镜像
2. **智能标签**：自动生成版本标签、分支标签和提交哈希标签
3. **缓存优化**：使用 GitHub Actions 缓存加速构建过程

### 自动更新 Docker Hub 描述

工作流会自动：
1. 使用 Docker Hub API 获取 bearer token
2. 将 README.md 内容上传为 Docker Hub 的完整描述

## 故障排除

### 常见问题

1. **认证失败**
   - 检查 Docker Hub 用户名和令牌是否正确
   - 确认令牌具有足够的权限

2. **构建失败**
   - 检查 Dockerfile 语法是否正确
   - 确认所有依赖包可用

3. **README 上传失败**
   - 检查 README.md 文件是否存在
   - 确认 Docker Hub 仓库已存在
   - 确认 jq 工具可用（在 Ubuntu runner 中默认安装）

4. **Bearer token 获取失败**
   - 检查 Docker Hub API 端点是否可访问
   - 确认个人访问令牌有效

### 手动测试

您可以通过以下命令手动测试 Docker 构建：

```bash
# 本地构建测试
docker build -t anarckk/ubuntu-dev-env:test .

# 本地运行测试
docker run -it --rm anarckk/ubuntu-dev-env:test bash
```

## 安全注意事项

- 不要将 Docker Hub 令牌硬编码在代码中
- 定期轮换访问令牌
- 使用最小权限原则配置令牌权限
- 监控 GitHub Actions 的运行日志

## 相关链接

- [Docker Hub 文档](https://docs.docker.com/docker-hub/)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Docker Buildx 文档](https://docs.docker.com/buildx/working-with-buildx/)