# Jenkins

## 1. 简介

Jenkins的Docker镜像（官方的镜像有问题）

## 2. 特性

1. Debian的bullseye
2. OpenJDK 8
3. Maven
4. Git
5. Docker
6. TZ=Asia/Shanghai

## 3. 编译并上传镜像

```sh
docker buildx build --platform linux/arm64,linux/amd64 \
    -t nnzbz/jenkins:2.303.3 \
    --build-arg VERSION=2.303.3 \
    --build-arg MAVEN_VERSION=3.8.4 \
    --build-arg GIT_VERSION=2.9.5 \
    . --push
# latest
docker buildx build --platform linux/arm64,linux/amd64 \
    -t nnzbz/jenkins:latest \
    --build-arg VERSION=2.303.3 \
    --build-arg MAVEN_VERSION=3.8.4 \
    --build-arg GIT_VERSION=2.9.5 \
    . --push
```

## 4. 创建并运行容器

```sh
docker run --rm -it -p20080:8080 --name 容器名称 nnzbz/jenkins
```
