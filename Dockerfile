# Start from the latest version of Ubuntu
FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get update && \
    apt-get install -y curl && \
    apt-get install -y golang && \
    apt-get install -y git-all


# Install neovim
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/') && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz -C /usr/bin lazygit

RUN apt-get update && apt-get install -y lua5.1 nodejs npm ripgrep

RUN apt-get update && \
    curl -Lo nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz && \ 
    tar xf nvim-linux64.tar.gz && ln -s nvim-linux64/bin/nvim /usr/bin/nvim && ln -s nvim-linux64/bin/nvim /usr/local/bin/nvim

RUN echo "export PATH=nvim-linux64/bin/nvim:$PATH" >> ~/.bashrc

COPY . /tmp

RUN mkdir ~/.config/

RUN cp -r /tmp/nvim ~/.config/nvim && \
  # Uncomment the line below and replace the link with your user config repo to load a user config
  # git clone https://github.com/username/AstroNvim_user ~/.config/nvim/lua/user
  nvim-linux64/bin/nvim --headless -c "autocmd User PackerComplete quitall"


# Install pip for Python 3
RUN apt-get update && \
    apt-get install -y python3-pip


# Install the python packages from requirements.txt
COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

# Set neovim as the default editor
ENV EDITOR=nvim
