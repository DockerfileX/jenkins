#!/bin/sh
# 去除开头结尾的空白字符
trim() {
    str=""

    if [ $# -gt 0 ]; then
        str="$1"
    fi
    echo "$str" | sed -e 's/^[ \t\r\n]*//g' | sed -e 's/[ \t\r\n]*$//g'
}

# 获取系统标识符：ubuntu、centos、alpine等
getOs() {
    os=$(trim $(cat /etc/os-release 2>/dev/null | grep ^ID= | awk -F= '{print $2}'))

    if [ "$os" = "" ]; then
        os=$(trim $(lsb_release -i 2>/dev/null | awk -F: '{print $2}'))
    fi
    if [ ! "$os" = "" ]; then
        os=$(echo $os | tr '[A-Z]' '[a-z]')
    fi

    echo $os
}

# 具体业务逻辑
os=$(getOs)
case $os in
debian)
    # # 设置时区
    # TZ=Asia/Shanghai
    # DEBIAN_FRONTEND=noninteractive
    # ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime
    # echo ${TZ} > /etc/timezone
    # dpkg-reconfigure --frontend noninteractive tzdata
    # rm -rf /var/lib/apt/lists/*
    # 解决启动报空指针的问题
    apt-get install ttf-dejavu
    # 安装git
    apt-get install git
    # 安装docker
    apt-get update
    apt-get install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    curl -fsSL https://download.docker.com/linux/debian/gpg \
        | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    apt-get install docker-ce docker-ce-cli containerd.io -y
    ;;
ubuntu)
    # # 设置时区
    # ln -sf /usr/share/zoneinfo/Asia/ShangHai /etc/localtime
    # echo "Asia/Shanghai" > /etc/timezone
    # dpkg-reconfigure -f noninteractive tzdata
    # 解决启动报空指针的问题
    apt-get install ttf-dejavu
    # 安装git
    apt-get install git
    # 安装docker
    apt-get update
    apt-get install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null    
    apt-get update
    apt-get install docker-ce docker-ce-cli containerd.io -y
    ;;
centos)
    # # 设置时区
    # TZ=Asia/Shanghai
    # ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
    # echo $TZ > /etc/timezone
    # # 设置编码格式
    # LC_ALL en_US.UTF-8
    # 解决启动报空指针的问题
    yum install dejavu-sans-fonts
    # 安装git
    yum -y remove git
    GIT_ZIP_FILE_NAME=git-${GIT_VERSION}.tar.gz
    curl -fsSL https://mirrors.edge.kernel.org/pub/software/scm/git/${GIT_ZIP_FILE_NAME} -o /tmp/${GIT_ZIP_FILE_NAME}
    tar zxvf /tmp/${GIT_ZIP_FILE_NAME} -C /tmp
    cd /tmp/git-${GIT_VERSION}
    ./configure --prefix=/usr/local
    make
    sudo make install
    rm -f /tmp/${GIT_ZIP_FILE_NAME}
    PATH="/usr/local/git/bin:${PATH}"
    # 安装docker
    yum install -y yum-utils
    yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
    yum install docker-ce docker-ce-cli containerd.io
    systemctl start docker
    systemctl enable docker
    ;;
alpine)
    # # 设置时区
    # apk add tzdata
    # cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    # echo "Asia/Shanghai" > /etc/timezone
    # apk del tzdata
    # 解决启动报空指针的问题
    apk add ttf-dejavu
    # 安装git
    apk add git
    # 安装docker
    apk add docker
    apk add openrc --no-cache
    rc-update add docker boot
    ;;
*)
    echo unknow os $os, exit!
    # return
    ;;
esac
