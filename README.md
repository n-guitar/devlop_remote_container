# devlop_remote_container

-   vscode リモートコンテナ用の Dockerfile の例
-   ubuntu ベースで環境を用意

## vscode-remote-container

-   https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers

| ファイル名          | 内容                                                       |
| ------------------- | ---------------------------------------------------------- |
| template.Dockerfile | ベースの Dockeerfile                                       |
| java.Dockerfile     | java 開発用<br>java-11-amazon-corretto-jdk、tomcat9 を利用 |
| python.Dockerfile     | python 開発用<br>python3.9.0,pip3を利用|
| django.Dockerfile     | django 開発用<br>python3.10.0,pip3,django3.2.8(TLS)を利用|
| go.Dockerfile     | golang 開発用<br>go1.17.2を利用|
| nodejs.Dockerfile     | nodejs 開発用<br>nodejs 16.13.0を利用|
