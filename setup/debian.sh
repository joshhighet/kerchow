#!/bin/zsh

if [ "$(uname)" != "Linux" ]; then
  echo "script is for linux"
  exit 1
fi

if [ -z "$CREATEUSERNAME" ] || [ -z "$PUBKEYGRANT" ]; then
  echo "CREATEUSERNAME and PUBKEYGRANT envars must be set. eg"
  echo "CREATEUSERNAME=josh PUBKEYGRANT='ssh-rsa xxxx==' ./newhost-debian.sh"
  exit 1
fi

APT_PACKAGES=(
  gh
  jq
  ufw
  zsh
  nmap
  tree
  cowsay
  lolcat
  masscan
  tcpdump
  torsocks
  python3-pip
  unattended-upgrades
  apt-transport-https
)
# filebeat, metricbeat

if ! id -u ${CREATEUSERNAME} >/dev/null 2>&1; then
  echo "user:${CREATEUSERNAME} does not exist - creating"
  adduser ${CREATEUSERNAME} --quiet --gecos ""
  password=`openssl rand -base64 12`
  echo ${password} | passwd ${CREATEUSERNAME} --stdin
  usermod -aG sudo ${CREATEUSERNAME}
  sudo runuser -l ${CREATEUSERNAME} -c "mkdir /home/${CREATEUSERNAME}/.ssh"
  sudo runuser -l ${CREATEUSERNAME} -c "touch /home/${CREATEUSERNAME}/.ssh/authorized_keys"
  sudo runuser -l ${CREATEUSERNAME} -c "echo ${PUBKEYGRANT} >> /home/${CREATEUSERNAME}/.ssh/authorized_keys"
  sudo runuser -l ${CREATEUSERNAME} -c "ssh-keygen -t rsa -b 4096 -C autodeploy -f /home/${CREATEUSERNAME}/.ssh/id_rsa -q"
else
  echo "user:${CREATEUSERNAME} already exists"
fi

if ! which bat >/dev/null 2>&1; then
  # https://github.com/sharkdp/bat#on-ubuntu-using-most-recent-deb-packages
  if [ "$(uname -m)" = "aarch64" ]; then
    ARCH='arm64'
  else
    ARCH='armhf'
  fi
  wget `curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | jq '.assets[].browser_download_url' -r | grep ${ARCH}.deb`
  sudo dpkg -i bat_*_${ARCH}.deb
  rm bat_*_${ARCH}.deb
fi

# https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian-ubuntu-linux-raspberry-pi-os-apt
if [ ! -f /usr/share/keyrings/githubcli-archive-keyring.gpg ]; then
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
fi

if [ ! -f /etc/apt/sources.list.d/github-cli.list ]; then
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
fi

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get install -y ${APT_PACKAGES[@]}
sudo apt-get -y autoclean
sudo apt-get -y autoremove
#sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.pre_init
#sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo runuser -l ${CREATEUSERNAME} -c "touch /home/${CREATEUSERNAME}/.hushlogin"
timedatectl set-timezone Pacific/Auckland

if [ "$(echo $SHELL)" != "/bin/zsh" ]; then
  chsh -s /bin/zsh
fi

if [ ! -d /home/${CREATEUSERNAME}/.oh-my-zsh ]; then
  sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
fi

pip3 install --upgrade pip

PYPACKAGES=(
    shodan
    virtualenv
)

pip3 install ${PYPACKAGES[@]}
