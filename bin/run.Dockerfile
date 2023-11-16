#FROM --platform=$BUILDPLATFORM harbor.baijiayun.com/docker-proxy/library/ubuntu:23.10 AS builder
FROM --platform=$BUILDPLATFORM ubuntu:23.10 AS builder

ENV NGINX_VERSION 1.25.3
ENV LIBRESSL_VERSION 3.8.2

ENV HOME /root

WORKDIR /root

#echo "nameserver 8.8.8.8" > /etc/resolv.conf
#echo "nameserver 114.114.114.114" >> /etc/resolv.conf

#RUN sed -i 's/ports.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN sed -i 's,http://archive.ubuntu.com,http://mirrors.aliyun.com,g' /etc/apt/sources.list
RUN sed -i 's,http://security.ubuntu.com,http://mirrors.aliyun.com,g' /etc/apt/sources.list

#RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
#RUN sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
#RUN sed -i 's/.*security.*//g' /etc/apt/sources.list

RUN apt update -y && apt install -y --no-install-recommends apt-utils debconf build-essential software-properties-common vim net-tools iputils-ping telnet lsof wget curl ca-certificates locales tzdata language-pack-zh-hans libpcre3-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*
#RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
#RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8 && locale -a && echo 'export LANG="zh_CN.UTF-8"' >> /etc/profile
