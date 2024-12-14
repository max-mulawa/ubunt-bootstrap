#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m' # No Color

set -o | grep noclobber
unalias cp

#https://askubuntu.com/questions/151819/how-do-i-swap-mouse-buttons-to-be-left-handed-from-the-terminal
if [ ! -f ~/.Xmodmap ]; then
    echo -e "${GREEN}Set right mouse button as primary${NC}"
    #temp change by folowing command
    xmodmap -e "pointer = 3 2 1"
    echo "pointer = 3 2 1" > ~/.Xmodmap
fi

# https://www.tecmint.com/things-after-installing-ubuntu/
echo "Updating package list and upgrading packages"
sudo apt update && sudo apt upgrade -y #https://linuxhint.com/update_all_packages_ubuntu/

echo  -e "Installing tooling I enjoy"
sudo apt install htop curl jq vim tree direnv -y

sudo snap install yq

echo  -e "Installing net-tools"
sudo apt install net-tools -y

if ! grep -qF "half-life" ~/.bashrc; then
  echo  -e "${GREEN}Installing om-my-bash${NC}"
  # set OSH_THEME="half-life in .bashrc
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
  #echo 'OSH_THEME="half-life"' | sudo tee -a ~/.bashrc
  #cat ~/.bashrc | sed 's/OSH_THEME=[^;]*/OSH_THEME="half-life"/gI' >| ~/.bashrc && source ~/.bashrc
  #source ~/.bashrc
fi

rsync -a ./dotfiles/ $HOME

# https://arslan.io/2019/07/03/how-to-write-idempotent-bash-scripts/
if [ ! -f "/etc/apt/sources.list.d/vscode.list" ]; then
    echo -e "${GREEN}Installing VS Code${NC}" #https://code.visualstudio.com/docs/setup/linux
    sudo apt-get install wget gpg apt-transport-https -y
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt update
    sudo apt install code -yqq

    echo 'export PATH=$PATH:/usr/share/code/bin' | tee -a ~/.bashrc > /dev/null
    
    echo -e "${GREEN}VS Code installed${NC}" 
fi

if [ -z "$(dpkg -l|grep chrome|awk '{print $2}')" ]; then 
    echo -e "${GREEN}Installing chrome${NC}"
    #https://askubuntu.com/questions/423355/how-do-i-check-if-a-package-is-installed-on-my-server
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    echo -e "chrome installed"
fi

#https://www.howtogeek.com/349844/how-to-stop-ubuntu-from-collecting-data-about-your-pc/
echo -e "turn off ubuntu data sending metrics"
ubuntu-report send no -f

# list of all themes >ls -d /usr/share/themes/*
echo -e "Set dark mode in desktop" #https://askubuntu.com/questions/769417/how-to-change-global-dark-theme-on-and-off-through-terminal
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

echo -e "Chaging desktop background to gray" #https://askubuntu.com/questions/66914/how-to-change-desktop-background-from-command-line-in-unity
gsettings set org.gnome.desktop.background picture-uri-dark /usr/share/backgrounds/ubuntu-default-greyscale-wallpaper.png

echo -e "Dock launcher on the bottom" #https://linuxconfig.org/how-to-customize-dock-panel-on-ubuntu-20-04-focal-fossa-linux
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM

echo -e "Installing gimp / flameshot (screenshots)"
sudo apt install gimp flameshot -y

sudo snap install vlc

sudo apt install ranger -y
if ! grep -qF "ranger" ~/.bashrc; then
    echo  -e "${GREEN}Installing ranger${NC}"
    echo 'alias r=". ranger"' | tee -a ~/.bashrc
    source ~/.bashrc
fi 

# mkdir ~/.config/copyq
# CopyQ set autostart and shortcut
sudo apt install copyq -y #&& cp ./.config/copyq/copyq.conf ~/.config/copyq/copyq.config

#https://github.com/KittyKatt/screenFetch/wiki/Installation
sudo apt install screenfetch -y

echo  -e "Installing Terminator"
mkdir $HOME/.config/terminator
sudo apt install terminator -y && cp -f ./.config/terminator/config $HOME/.config/terminator/config


sudo snap install postman 
sudo snap install slack 

# install networking capture tools
sudo DEBIAN_FRONTEND=noninteractive apt install -y wireshark tshark

if [ ! -f "/etc/apt/sources.list.d/docker.list" ]; then
    echo  -e "${GREEN}Installing docker and docker-compose${NC}"
    #docker install : https://docs.docker.com/engine/install/ubuntu/
    sudo apt-get install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

    #https://github.com/docker/compose
    export composeVersion=$(curl -SsL https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)
    wget https://github.com/docker/compose/releases/download/$composeVersion/docker-compose-linux-x86_64
    sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    sudo usermod -aG docker $USER #adding user to docker group https://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo

    #change ownership for local $HOME/.docker directory to docker group and user
    sudo chgrp -hR docker ~/.docker && sudo chown -R $USER ~/.docker
    docker completion bash | sudo tee -a /usr/share/bash-completion/completions/docker > /dev/null
fi

if [ ! -f "/usr/local/bin/kubectl" ]; then
    echo  -e "${GREEN}Installing kubectl${NC}"
    #kubectl install https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    echo "export KUBECONFIG=\$HOME/.kube/config" >> ~/.bashrc
fi

if [ ! -f "/usr/local/bin/helm" ]; then
    export helmVer=$(curl -SsL https://api.github.com/repos/helm/helm/releases/latest | jq -r .tag_name)
    wget https://get.helm.sh/helm-$helmVer-linux-amd64.tar.gz
    tar -zxvf helm-$helmVer-linux-amd64.tar.gz
    sudo mv linux-amd64/helm /usr/local/bin/helm
    helm completion bash | sudo tee -a /usr/share/bash-completion/completions/helm > /dev/null
fi 

#Install kubectx kubens f2f
if [ ! -f "/opt/kubectx/kubectx" ]; then
    echo  -e "${GREEN}Installing kubectx/kubens/fzf${NC}"
    #https://github.com/ahmetb/kubectx#manual-installation-macos-and-linux
    sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
    sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
    sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
    #https://github.com/junegunn/fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
    #sudo apt-get install fzf -y
    source ~/.bashrc
fi

if [ ! -f "/usr/local/bin/minikube" ]; then 
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    minikube completion bash | sudo tee -a /usr/share/bash-completion/completions/minikube > /dev/null
fi

if [ ! -f "/usr/local/bin/kind" ]; then 
    export kindVersion=$(curl -SsL https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | jq -r .tag_name)  
    wget https://github.com/kubernetes-sigs/kind/releases/download/$kindVersion/kind-linux-amd64
    chmod +x ./kind-linux-amd64
    sudo mv ./kind-linux-amd64 /usr/local/bin/kind
    kind completion bash | sudo tee -a /usr/share/bash-completion/completions/kind > /dev/null
fi

if [ ! -f "/usr/local/bin/k9s" ]; then 
    export k9sVersion=$(curl -SsL https://api.github.com/repos/derailed/k9s/releases/latest | jq -r .tag_name)
    wget https://github.com/derailed/k9s/releases/download/$k9sVersion/k9s_Linux_amd64.tar.gz
    tar -zxvf k9s_Linux_amd64.tar.gz
    sudo mv k9s /usr/local/bin/k9s
    k9s completion bash | sudo tee -a /usr/share/bash-completion/completions/k9s > /dev/null
    rm k9s_Linux_amd64.tar.gz
fi 

if [ ! -f "/usr/local/go" ]; then
     curl -L -o go.linux-amd64.tar.gz go.dev/dl/$(curl https://go.dev/dl/?mode=json \
                     | jq -r '.[0].version').linux-amd64.tar.gz

     sudo rm -rf /usr/local/go 
     sudo tar -C /usr/local -xzf go.linux-amd64.tar.gz
     echo "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin" >> ~/.bashrc
     source ~/.bashrc
     go version
fi

# k8s logs watcher
go install github.com/stern/stern@latest

sudo snap install zoom-client

{
    if ! grep -qF "#.bashrc extensions" ~/.bashrc; then
        echo  -e "${GREEN}Installing bashrc extensions${NC}" 
        export install_dir=$(pwd)

        echo "#.bashrc extensions" >> ~/.bashrc   
        for bashrc_file in $install_dir/bashrc/.bashrc* ; do
            echo "source ${bashrc_file}" >> ~/.bashrc
        done
        source ~/.bashrc
    fi
}

echo -e "${GREEN}Done${NC}"
