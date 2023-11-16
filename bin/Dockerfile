# https://github.com/nginx-modules/docker-nginx-boringssl/blob/master/mainline/alpine/Dockerfile
#FROM --platform=$BUILDPLATFORM harbor.baijiayun.com/docker-proxy/library/ubuntu:23.10 AS builder
FROM --platform=$BUILDPLATFORM ubuntu:23.10 AS builder

ENV NGINX_VERSION 1.25.3
ENV LIBRESSL_VERSION 3.8.2

ENV HOME /root

WORKDIR /root

#RUN sed -i 's/archive.ubuntu.com/mirrors.cloud.tencent.com/g' /etc/apt/sources.list
#RUN sed -i 's/ports.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN sed -i 's,http://archive.ubuntu.com,http://mirrors.aliyun.com,g' /etc/apt/sources.list
RUN sed -i 's,http://security.ubuntu.com,http://mirrors.aliyun.com,g' /etc/apt/sources.list

# 安装软件依赖包...
# [Ubuntu 中文乱码问题处理](https://cloud.tencent.com/developer/article/1920078)
RUN apt update -y && apt install -y --no-install-recommends apt-utils debconf build-essential software-properties-common vim net-tools iputils-ping telnet lsof wget curl ca-certificates locales tzdata language-pack-zh-hans libpcre3-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8 && locale -a && echo 'export LANG="zh_CN.UTF-8"' >> /etc/profile

RUN wget https://mirrors.aliyun.com/pub/OpenBSD/LibreSSL/libressl-$LIBRESSL_VERSION.tar.gz && tar -zxvf libressl-$LIBRESSL_VERSION.tar.gz
RUN wget https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && tar -zxvf nginx-$NGINX_VERSION.tar.gz

WORKDIR /root/libressl-$LIBRESSL_VERSION
RUN ./configure && make check -j$(nproc) && make install

WORKDIR /root/nginx-$NGINX_VERSION
RUN ./configure \
    --prefix=/root/nginx \
    --with-compat \
    --with-file-aio \
    --with-threads \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_v3_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-stream \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-cc-opt="-I/usr/local/include" \
    --with-ld-opt="-L/usr/local/lib"

RUN make -j$(nproc) && make install

WORKDIR /root/nginx

RUN echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr_local_lib.conf && ldconfig

COPY nginx.conf /root/nginx/conf/nginx.conf
COPY certs /root/nginx/conf/certs
#COPY nginx.vh.no-default.conf /etc/nginx/conf.d/default.conf

LABEL description="NGINX Docker built top of rolling release LibreSSL" \
      maintainer="CorEthan <zyf@iirii.com>" \
      openssl="LibreSSL" \
      nginx="nginx $NGINX_VERSION"

EXPOSE 80 443 443/udp

STOPSIGNAL SIGTERM

CMD ["/root/nginx/sbin/nginx", "-g", "daemon off;"]
