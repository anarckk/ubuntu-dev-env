# 使用 Ubuntu 24.04 作为基础镜像
FROM ubuntu:24.04

MAINTAINER anarckk "anarckk@gmail.com"

# 设置非交互式安装以避免提示（仅在构建时使用）
ENV DEBIAN_FRONTEND=noninteractive

# 设置工作目录
WORKDIR /workspace

# 安装基础工具和依赖（合并安装，减少层数）
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    gnupg \
    lsb-release \
    ca-certificates \
    software-properties-common \
    apt-transport-https \
    git \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# 安装 OpenJDK 21
RUN apt-get update && apt-get install -y --no-install-recommends openjdk-21-jdk \
    && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# 安装 Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# 安装 Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce docker-ce-cli containerd.io \
    && rm -rf /var/lib/apt/lists/*

# 安装 Docker Compose Plugin（推荐方式）
RUN apt-get update && apt-get install -y --no-install-recommends docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

# 配置 Docker 守护进程（使用 overlay2 存储驱动）
RUN mkdir -p /etc/docker \
    && echo '{"storage-driver": "overlay2"}' > /etc/docker/daemon.json

# 清理缓存以减少镜像大小
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 安装 code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# 创建 code-server 配置目录和数据目录
RUN mkdir -p /root/.config/code-server && \
    mkdir -p /root/workspace

# 配置 code-server
RUN echo 'bind-addr: 0.0.0.0:8080' > /root/.config/code-server/config.yaml && \
    echo 'auth: password' >> /root/.config/code-server/config.yaml && \
    echo 'password: password123' >> /root/.config/code-server/config.yaml && \
    echo 'cert: false' >> /root/.config/code-server/config.yaml

# 暴露 code-server 端口
EXPOSE 8080

# 验证安装
RUN java -version && node --version && npm --version && docker --version && git --version && code-server --version

# 设置默认命令（启动 code-server）
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "/root/workspace"]