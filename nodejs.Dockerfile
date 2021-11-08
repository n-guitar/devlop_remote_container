FROM ubuntu:21.10

# 基本セットアップ
RUN apt-get update \
    && apt-get install -y --no-install-recommends tzdata sudo curl wget \
    # 開発ツール ここに追加していく
    && apt-get install -y --no-install-recommends git bash-completion \
    # 不要なものを削除
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 基本変数
ENV TZ Asia/Tokyo
ENV LANG=ja_JP.UTF-8

# nodejs
ARG NODEJS_PKG=16
RUN curl -k https://deb.nodesource.com/setup_$NODEJS_PKG.x | sudo bash - \
    && apt-get install -y --no-install-recommends nodejs \
    # 不要なものを削除
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# root以外のユーザ
ARG USERNAME=develop
ARG GROUPNAME=develop
ARG UID=1000
ARG GID=1000
ARG PASSWORD=develop
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME
ADD .bashrc /home/$USERNAME