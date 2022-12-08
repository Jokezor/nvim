# Start from the latest version of Ubuntu
FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y software-properties-common \
    curl \
    git-all \ 
    ca-certificates \
    python3 \
    git \
    sudo \
    gdb \
    python3-pip \ 
    python3.10-venv


# Get upgraded node
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y nodejs

# Install the python packages from requirements.txt
COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

# Lazy git
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/') && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz -C /usr/bin lazygit

RUN apt-get update && apt-get install -y ripgrep

# Install neovim
RUN apt-get update && \
    curl -Lo nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz && \ 
    tar xf nvim-linux64.tar.gz && ln -s nvim-linux64/bin/nvim /usr/bin/nvim && ln -s nvim-linux64/bin/nvim /usr/local/bin/nvim

RUN echo "alias nvim=nvim-linux64/bin/nvim" >> /root/.bashrc

# Copy over my nvim setup
COPY . /tmp
RUN mkdir ~/.config/

RUN cp -r /tmp/nvim ~/.config/nvim && \
  # Uncomment the line below and replace the link with your user config repo to load a user config
  # git clone https://github.com/username/AstroNvim_user ~/.config/nvim/lua/user
  nvim-linux64/bin/nvim --headless -c "autocmd User PackerComplete quitall"

RUN nvim-linux64/bin/nvim --headless -c "autocmd User LspInstall pyright" -c "quitall" 

#-c "autocmd User LspInstall black quitall" -c "autocmd User LspInstall isort quitall" && \
#    nvim-linux64/bin/nvim --headless -c "autocmd User AstroUpdate quitall"


# Set neovim as the default editor
ENV EDITOR=nvim
