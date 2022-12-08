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

# Get nvim dependencies
RUN apt-get update && \
    apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen 

# Install neovim from source
RUN git clone https://github.com/neovim/neovim && cd neovim && git checkout stable && \
    make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"  && \
    make install && \
    export PATH="$HOME/neovim/bin:$PATH"

#RUN echo "export PATH=nvim-linux64/bin/nvim:$PATH" >> ~/.bashrc

# Copy over files
COPY . /tmp

#RUN mkdir ~/.config/

RUN git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim && \
  # Uncomment the line below and replace the link with your user config repo to load a user config
  # git clone https://github.com/username/AstroNvim_user ~/.config/nvim/lua/user
  ~/neovim/bin/nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'


# Install pip for Python 3
RUN apt-get update && \
    apt-get install -y python3-pip


# Install the python packages from requirements.txt
COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

RUN npm install -g pyright

# Set neovim as the default editor
ENV EDITOR=nvim
