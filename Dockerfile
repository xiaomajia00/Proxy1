# 基于archlinux:latest镜像
FROM archlinux:base-devel

# 更新软件源并安装wget和gnupg
RUN pacman -Syu --noconfirm \
    wget \
    gnupg \
    # 下载Google的公钥并添加到pacman源
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | pacman-key --add - \
    # 添加Google Chrome的稳定版源
    && echo "[google-chrome]" >> /etc/pacman.conf \
    && echo "SigLevel = Optional TrustAll" >> /etc/pacman.conf \
    && echo "Server = http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/pacman.conf \
    # 再次更新软件源并安装Google Chrome
    && pacman -Syu --noconfirm google-chrome-stable

# 下载Microsoft Edge的deb包并安装
RUN wget https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-dev/microsoft-edge-dev_91.0.864.59-1_arm64.deb \
    && pacman -U --noconfirm microsoft-edge-dev_91.0.864.59-1_arm64.deb

# 下载Microsoft Edge Driver并解压到/usr/bin目录
RUN wget https://msedgedriver.azureedge.net/91.0.864.59/edgedriver_linux64.zip \
    && unzip edgedriver_linux64.zip -d /usr/bin

# 声明容器中打开的80端口
EXPOSE 80

# 设置容器启动时的默认命令为启动edge浏览器，并监听80端口
CMD ["microsoft-edge", "--remote-debugging-port=80"]
