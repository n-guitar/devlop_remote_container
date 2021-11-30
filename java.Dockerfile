FROM ubuntu:21.10
# FROM --platform=linux/amd64 ubuntu:21.10

# 基本セットアップ
RUN apt-get update \
    && apt-get install -y --no-install-recommends tzdata sudo curl wget \
    # 開発ツール ここに追加していく
    && apt-get install -y --no-install-recommends git bash-completion ca-certificates
# java用
RUN  apt-get install -y --no-install-recommends software-properties-common java-common gpg-agent maven \
    && add-apt-repository 'deb https://apt.corretto.aws stable main' \
    && curl https://apt.corretto.aws/corretto.key | sudo apt-key add - \
    && apt-get update \
    && apt-get install -y java-11-amazon-corretto-jdk \
    && wget http://archive.apache.org/dist/tomcat/tomcat-9/v9.0.54/bin/apache-tomcat-9.0.54.tar.gz \
    && tar -xf apache-tomcat-9.0.54.tar.gz \
    && rm -f apache-tomcat-9.0.54.tar.gz \
    && mkdir -p /usr/share/tomcat9 \
    && mv apache-tomcat-9.0.54 /usr/share/tomcat9/9.0.54 \
    # 不要なものを削除
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 基本変数
ENV TZ Asia/Tokyo
ENV LANG=ja_JP.UTF-8

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
# java開発用
RUN chown -R 1000:1000 /usr/share/tomcat9/9.0.54
EXPOSE 8080

USER $USERNAME
ADD .bashrc /home/$USERNAME