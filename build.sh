# ########### 构建开发环境镜像 ###########
# # 获取基础镜像
# env=$(cat .env | grep DOCKER_BASE_IMAGE=)
# docer_base_image=${env#*DOCKER_BASE_IMAGE=}
# # 获取运行环境镜像名字
# env=$(cat .env | grep DOCKER_ENV_IMAGE=)
# docker_env_image=${env#*DOCKER_ENV_IMAGE=}
# # 构建镜像
# docker build . -t ${docer_base_image} -f ../../development_base/base.Dockerfile
# arch=$(arch)
# if [ $arch == "arm64" ]; then
#   echo "#################### 架构为 ${arch}，使用 arm64.Dockerfile 构建 ####################\n"
#   docker build . -t ${docker_env_image} -f ./arm64.Dockerfile
# else
#   echo "#################### 架构为 ${arch}，使用 amd64.Dockerfile 构建 ####################\n"
#   docker build . -t ${docker_env_image} -f ./amd64.Dockerfile
# fi

# TODO: 如果需要的话，开发为更加智能的脚本


# 编译镜像，这里直接使用 latest 标签，也不用维护版本号了，维护一个版本就够了
docker build . -t env_dev_base:latest -f Base.Dockerfile

# 删除多余镜像
docker images | grep "none" | awk '{print $3}'| xargs -t -n1 docker rmi
