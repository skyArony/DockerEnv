# 开发环境基础镜像

# 基于 Ubuntu 20.04
FROM ubuntu:20.04

####################### 配置基础软件包 #######################

# 设置交互模式为无交互，这样可以避免一些 Y/N 的选项
# 这里使用 ARG 而不是 ENV 是因为 ARG 只在构建过程中生效，避免这个参数影响到启动后容器
ARG DEBIAN_FRONTEND=noninteractive

# 更新包索引
RUN apt-get update && apt-get upgrade -y

# 安装基础软件
# apt-get 相比 apt 更适合在脚本中使用
# -y 表示默认同意，可以加上 -q 来不显示安装过程
RUN apt-get install -y apt-utils curl git zsh vim wget sudo tar

# 设置 shell 变量
ENV SHELL=/bin/zsh

####################### 配置时区 #######################

# 设置时区
# 这里主要是使用了 tzdata 包，并通过 dpkg-reconfigure 命令对 tzdata 进行重新配置
ENV TZ=Asia/Shanghai
RUN apt-get install -y tzdata \
  && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
  && echo ${TZ} > /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata

####################### 配置 user00 账户 #######################

# 创建 user00 账户
RUN useradd -s /bin/zsh -m -d /home/user00 user00 -g users

# 增加 user00 到 sudo 组
RUN usermod -a -G sudo user00

# 设定 user00 执行 sudo 无需密码
RUN echo "user00 ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev

# 修改密码
RUN echo "root:root" | chpasswd
RUN echo "user00:user00" | chpasswd

####################### 配置 oh-my-zsh #######################

# 设置默认 shell 为 zsh
RUN chsh -s /bin/zsh

# 使用 oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# 安装 oh-my-zsh 插件
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# 安装 oh-my-zsh 插件
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# 使用 oh-my-zsh 插件
# dst 这个 zsh 主题可能会在进入 git 目录时反应很慢，可以在 git 目录通过这个命令关闭 git 变更文件判断解决这个问题：git config --add oh-my-zsh.hide-dirty 1
RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="dst"/g' ~/.zshrc

####################### user00 配置 oh-my-zsh #######################

# 切换到 user00
USER user00
# 进入用户目录
WORKDIR /home/user00

# 使用 oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# 安装 oh-my-zsh 插件
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# 安装 oh-my-zsh 插件
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# 使用 oh-my-zsh 插件
# dst 这个 zsh 主题可能会在进入 git 目录时反应很慢，可以在 git 目录通过这个命令关闭 git 变更文件判断解决这个问题：git config --add oh-my-zsh.hide-dirty 1
RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="dst"/g' ~/.zshrc
