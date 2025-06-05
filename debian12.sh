#!/bin/bash -i

ask_to_install() {

  local question="$1"

  while true; do
    echo "$question [Y]es / [N]o"
    read answer

    case $answer in
    [Yy]*)
      return 1
      ;;
    [Nn]*)
      return 0
      ;;
    *) echo "Please answer Yes or No." ;;
    esac
  done
}

already_installed() {
  local package="$1"

  if [ -x "$(command -v $package)" ]; then
    echo "Already installed: $package"
    return 1
  fi

  return 0
}

check_os() {
  if ! [ -f "/etc/debian_version" ]; then
    echo "Error: This script is only supported on Debian-based systems."
    exit 1
  fi
}

prepare_environment() {
  echo "Updating sources and repos..."
  sudo apt-get update 1>/dev/null
  sudo apt-get -y upgrade 1>/dev/null
  echo "Finished"
  echo ""
}

intall_required_packages() {
  echo "Installing required packages... [git, curl, unzip, ca-certificates, gnupg, apt-transport-https]"
  sudo apt-get -y install git curl unzip ca-certificates gnupg apt-transport-https 1>/dev/null
  echo "Finished"
  echo ""
}

install_dotnet_sdk() {
  ask_to_install "Would you like install .net sdk 8.x?"

  if [ $? == 1 ]; then
    echo "Installing dotnet sdk 8.x..."

    already_installed "dotnet"

    if [ $? == 1 ]; then
      echo "dotnet sdk is already installed."
      return
    fi

    local file_name="dotnet-sdk.deb"

    curl -fsSL https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -o $file_name

    sudo dpkg -i $file_name 1>/dev/null
    rm $file_name

    sudo apt-get update 1>/dev/null
    sudo apt-get -y install dotnet-sdk-8.0 1>/dev/null

    echo "dotnet sdk version installed is: $(dotnet --version)"

    echo "Finished"
  fi

  echo ""
}

install_nodejs() {
  ask_to_install "Would you like install NodeJS 22.x?"

  if [ $? == 1 ]; then
    echo "Installing NodeJS..."

    already_installed "node"

    if [ $? == 1 ]; then
      echo "nodejs is already installed."
      return
    fi

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

    source ~/.bashrc

    nvm install 22 1>/dev/null

    echo "nodejs version installed is: $(node --version)"
    echo "Finished"
  fi

  echo ""
}

install_angular_cli() {
  ask_to_install "Would you like install Angular CLI?"

  if [ $? == 1 ]; then
    echo "Installing Angular CLI..."

    already_installed "ng"

    if [ $? == 1 ]; then
      echo "angular cli is already installed."
      return
    fi

    npm install -g @angular/cli 1>/dev/null

    echo "angular version is: $(ng --version)"
    echo "Finished"
  fi

  echo ""
}

install_docker() {
  ask_to_install "Would you like install Docker?"

  if [ $? == 1 ]; then
    echo "Installing Docker..."

    already_installed "docker"

    if [ $? == 1 ]; then
      echo "docker is already installed."
      return
    fi

    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
      sudo apt-get remove $pkg 1>/dev/null
    done

    # Add Docker's official GPG key:
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
      sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update 1>/dev/null

    # installing docker
    sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 1>/dev/null

    echo "docker version is: $(docker --version)"
    echo "Finished"
  fi

  echo ""
}

install_oh_my_posh() {
  ask_to_install "Would you like install Oh My Posh?"

  if [ $? == 1 ]; then
    echo "Installing Oh My Posh..."

    already_installed "oh-my-posh"

    if [ $? == 1 ]; then
      echo "oh-my-posh is already installed."
      #return
    fi

    curl -s https://ohmyposh.dev/install.sh | bash -s 1>/dev/null

    source ~/.profile

    oh-my-posh font install

    echo 'eval "$(oh-my-posh init bash --config ~/.cache/oh-my-posh/themes/dracula.omp.json)"' >> ~/.profile

    eval "$(oh-my-posh init bash --config ~/.cache/oh-my-posh/themes/dracula.omp.json)"

    source ~/.profile

    echo "Finished"
  fi

  echo ""
}

#cd ~
sudo &>/dev/null
check_os
prepare_environment
intall_required_packages
install_dotnet_sdk
install_nodejs
install_angular_cli
install_docker
install_oh_my_posh
