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
GTAG=release-$ENV-$tag

CPU_ARCH=linux/amd64,linux/arm64

docker buildx create --use --name tests_buildx || true
docker buildx build --build-arg APP_ENV=$ENV --build-arg VERSION=$GTAG --push --platform=$CPU_ARCH -t registry.cn-beijing.aliyuncs.com/coam/webtransport:$VTAG  .

#docker build --build-arg VERSION=$VTAG --platform=$CPU_ARCH -t registry.cn-beijing.aliyuncs.com/coam/webtransport:$VTAG  .
#docker image push registry.cn-beijing.aliyuncs.com/coam/webtransport:$VTAG
#exec docker run --rm -it registry.cn-beijing.aliyuncs.com/coam/webtransport:$VTAG /bin/sh --login
