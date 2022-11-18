# 编译基础镜像
docker build . -t env_dev_base:latest -f ../Base.Dockerfile

# 编译镜像
docker build . -t env_dev_node:latest -f AMD.Dockerfile

# 删除多余镜像
docker images | grep "none" | awk '{print $3}'| xargs -t -n1 docker rmi