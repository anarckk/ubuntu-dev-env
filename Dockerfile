# 使用 Ubuntu 24.04 作为基础镜像
FROM ubuntu:24.04

MAINTAINER anarckk "anarckk@gmail.com"

# 设置非交互式安装以避免提示（仅在构建时使用）
ENV DEBIAN_FRONTEND=noninteractive

# 设置中文环境
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8

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
    vim \
    nano \
    htop \
    tree \
    unzip \
    zip \
    jq \
    tmux \
    telnet \
    language-pack-zh-hans \
    language-pack-zh-hans-base \
    locales \
    && locale-gen zh_CN.UTF-8

# 安装 OpenJDK 21
RUN apt-get update && apt-get install -y --no-install-recommends openjdk-21-jdk \
    && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# 安装 Gradle
RUN wget -O /tmp/gradle.zip https://services.gradle.org/distributions/gradle-8.7-bin.zip \
    && mkdir -p /opt/gradle \
    && unzip -d /opt/gradle /tmp/gradle.zip \
    && rm /tmp/gradle.zip \
    && ln -s /opt/gradle/gradle-8.7/bin/gradle /usr/bin/gradle

# 安装 Maven
RUN wget -O /tmp/maven.tar.gz https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.tar.gz \
    && tar -xzf /tmp/maven.tar.gz -C /opt \
    && rm /tmp/maven.tar.gz \
    && ln -s /opt/apache-maven-3.9.11/bin/mvn /usr/bin/mvn

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
RUN java -version && \
    gradle --version && \
    mvn --version && \
    node --version && \
    npm --version && \
    docker --version && \
    git --version && \
    code-server --version && \
    tmux -V && \
    telnet --version

# 设置默认命令（启动 code-server）
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "/root/workspace"]

# 添加常用开发工具命令说明
# 以下是一些常用的开发命令，可以在容器内使用：

# Java 开发相关：
#   javac - 编译Java文件
#   java - 运行Java程序
#   jar - 打包Java应用

# Gradle 命令：
#   gradle build - 构建项目
#   gradle test - 运行测试
#   gradle clean - 清理构建文件

# Maven 命令：
#   mvn compile - 编译项目
#   mvn test - 运行测试
#   mvn package - 打包项目

# Node.js 命令：
#   npm install - 安装依赖
#   npm run dev - 运行开发服务器
#   node app.js - 运行Node.js应用

# Docker 命令：
#   docker ps - 查看运行中的容器
#   docker images - 查看镜像
#   docker-compose up -d - 启动Docker Compose服务

# 系统工具：
#   htop - 系统监控
#   vim/nano - 文本编辑
#   tree - 目录结构展示
#   jq - JSON数据处理
#   tmux - 终端复用器
#   telnet - 网络连接测试工具

# Git 命令：
#   git clone - 克隆仓库
#   git status - 查看状态
#   git add . && git commit -m "message" - 提交代码
#   git push - 推送代码到远程仓库