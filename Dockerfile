# 基于alpine:latest镜像
FROM alpine:latest

# 更新软件源并安装wget和gnupg
RUN apk update && apk add \
    wget \
    gnupg 

# 下载Google Chrome的稳定版deb包并安装
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apk add --allow-untrusted google-chrome-stable_current_amd64.deb

# 下载Microsoft Edge的deb包并安装
RUN wget https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-dev/microsoft-edge-dev_91.0.864.59-1_arm64.deb \
    && apk add --allow-untrusted microsoft-edge-dev_91.0.864.59-1_arm64.deb

# 下载Microsoft Edge Driver并解压到/usr/bin目录
RUN wget https://msedgedriver.azureedge.net/91.0.864.59/edgedriver_linux64.zip \
    && unzip edgedriver_linux64.zip -d /usr/bin

# 声明容器中打开的80端口
EXPOSE 80

# 设置容器启动时的默认命令为启动edge浏览器，并监听80端口
CMD ["microsoft-edge", "--remote-debugging-port=80"]
