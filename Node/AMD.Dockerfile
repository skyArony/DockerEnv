# AMD64
FROM env_dev_base

############### 安装 brew ##############

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# docker 模式下这两个命令没用
# RUN echo 'eval "$(/home/user00/.linuxbrew/bin/brew shellenv)"' >> /home/user00/.zprofile
# RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# 用以下命令代替代替
ENV HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
ENV HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar"
ENV HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"
ENV MANPATH="/home/linuxbrew/.linuxbrew/share/man:${MANPATH}"
ENV INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH}"

############### 安装 node 开发环境 ##############

RUN brew install node pnpm

# docker 模式下这个命令没用
# RUN pnpm setup
# 用以下命令代替代替
ENV PNPM_HOME=/home/user00/.local/share/pnpm
ENV PATH="${PATH}:${PNPM_HOME}"

# 更新 pnpm
RUN pnpm add -g pnpm

############### 安装其他 pnpm 包 ##############

# nestjs
RUN pnpm add -g @nestjs/cli
