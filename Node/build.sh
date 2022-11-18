# 编译镜像
docker build . -t env_dev_node:1.0.0 -f AMD.Dockerfile

# 删除多余镜像
docker images | grep "none" | awk '{print $3}'| xargs -t -n1 docker rmi