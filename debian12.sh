# before you start, check os version
cat /etc/os-release | grep PRETTY_NAME
# Expected: PRETTY_NAME="Debian GNU/Linux 12 (bookworm)"

# update repositories and upgrade outdated
sudo apt update && sudo apt upgrade -y

# install basic packages
sudo apt install -y git wget curl unzip


#
# .net 8 (SDK LTS)
#
# download repo
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

# install repo
sudo dpkg -i packages-microsoft-prod.deb

# remove temp download
rm packages-microsoft-prod.deb

# installing SDK
sudo apt-get update && sudo apt-get install -y dotnet-sdk-8.0


#
# nodejs (22 LTS)
#
# installs fnm (Fast Node Manager)
curl -fsSL https://fnm.vercel.app/install | bash

# activate fnm
source ~/.bashrc

# download and install Node.js
fnm use --install-if-missing 22

# verifies the right Node.js version is in the environment
node -v # should print `v22.*`

# verifies the right npm version is in the environment
npm -v


#
# angular
#
# installing angular cli
npm install -g @angular/cli


#
# Docker
#
# cleaning old packages
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# installing docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin