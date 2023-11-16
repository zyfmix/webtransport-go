#!/usr/bin/env bash
set -xe

# 脚本路径
sc_dir="$(
  cd "$(dirname "$0")" >/dev/null 2>&1 || exit
  pwd -P
)"

# 去掉路径后缀
rs_path=${sc_dir/webtransport-gos*/webtransport-gos}

# 编译环境
ENV=${1:-"local"}

([ "$ENV" != "local" ] && [ "$ENV" != "dev" ] && [ "$ENV" != "test" ] && [ "$ENV" != "beta" ] && [ "$ENV" != "prod" ] && [ "$ENV" != "private" ]) && echo "参数[1: $1]不合法!" && exit

tag=$(git log -1 --pretty=format:"%h")

VTAG=release-$ENV

docker run --rm --name=webtransport --mount type=bind,source="$(pwd)"/nginx.conf,target=/root/nginx/conf/nginx.conf,readonly -p 8000:80 -p 8443:443 -p 8443:443/udp --add-host brtc-pslocal.baijiayun.com:172.27.12.108 -it registry.cn-beijing.aliyuncs.com/coam/webtransport:$VTAG
#docker run --rm --name=webtransport --mount type=bind,source="$(pwd)"/nginx.conf,target=/root/nginx/conf/nginx.conf,readonly -p 8000:80 -p 8443:443 -p 8443:443/udp --add-host brtc-pslocal.baijiayun.com:172.27.12.108 -it registry.cn-beijing.aliyuncs.com/coam/webtransport:$VTAG /bin/bash
