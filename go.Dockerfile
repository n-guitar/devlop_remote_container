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

# go
ARG GO_PKG=go1.17.2
ARG ARCH=arm64
# ARG ARCH=amd64
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates openssl \
    && wget --no-check-certificate https://golang.org/dl/$GO_PKG.linux-$ARCH.tar.gz \
    && rm -rf /usr/local/go && tar -C /usr/local -xzf $GO_PKG.linux-$ARCH.tar.gz \
    && rm -f $GO_PKG.linux-$ARCH.tar.gz \
    # 不要なものを削除
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# go getを行う際に必要なsecrets
# Get certificate from "github.com"
RUN openssl s_client -showcerts -connect github.com:443 </dev/null 2>/dev/null|openssl x509 -outform PEM > ${cert_location}/github.crt
# Get certificate from "proxy.golang.org"
RUN openssl s_client -showcerts -connect proxy.golang.org:443 </dev/null 2>/dev/null|openssl x509 -outform PEM >  ${cert_location}/proxy.golang.crt
# Update certificates
RUN update-ca-certificates
ENV PATH=$PATH:/usr/local/go/bin

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
RUN go env -w GOPATH=/home/$USERNAME/go