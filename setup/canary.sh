#!/usr/bin/env bash

canaryextip=127.0.0.1
serviceuser=canary
#check if user we plan to create for isolated service exists already
getent passwd ${serviceuser} > /dev/null 2&>1
if [ $? -eq 0 ]; then
    printf "user ${serviceuser} already exists\n"
    exit 0
fi
add user "${serviceuser}" without home directory or interactive capabilities into docker group (allow docker-compose without sudo)
adduser \
--quiet \
--gecos "" \
--disabled-login \
--disabled-password \
--ingroup docker \
${serviceuser}
printf "primary FQDN [i.e canary.joshhighet.com] : " && read canarydomain
sudo apt-get install -y \
python-pip \
python-dev \
libyaml-dev \
docker-compose \
-qq > /dev/null
git clone https://github.com/thinkst/canarytokens-docker --quiet
cd canarytokens-docker
canarydir=`pwd`
mv switchboard.env.dist switchboard.env
mv frontend.env.dist frontend.env
sed -i 's/CANARY_PUBLIC_IP=/CANARY_PUBLIC_IP='${canaryextip}'/g' switchboard.env
sed -i 's/#CANARY_PUBLIC_DOMAIN=/CANARY_PUBLIC_DOMAIN='${canarydomain}'/g' switchboard.env
sed -i 's/CANARY_ALERT_EMAIL_FROM_ADDRESS=/#CANARY_ALERT_EMAIL_FROM_ADDRESS=/g' switchboard.env
sed -i 's/CANARY_ALERT_EMAIL_FROM_DISPLAY=/#CANARY_ALERT_EMAIL_FROM_DISPLAY=/g' switchboard.env
sed -i 's/CANARY_ALERT_EMAIL_SUBJECT=/#CANARY_ALERT_EMAIL_SUBJECT=/g' switchboard.env
sed -i 's/CANARY_DOMAINS=localhost/CANARY_DOMAINS='${canarydomain}'/g' frontend.env
sed -i 's/CANARY_NXDOMAINS=yourdomain.com/#CANARY_NXDOMAINS=nullptr.'${canarydomain}'/g' frontend.env
sed -i 's/ubuntu:16.04/ubuntu:18.04/g' canarytokens/Dockerfile
#not utilising DNS canaries - shift ports so mainstream resolution is not tampered with
sed -i 's/53:53/5300:5300/g' docker-compose.yml
#hugepages
sudo bash -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled"
sed -r 's/GRUB_CMDLINE_LINUX_DEFAULT="[a-zA-Z0-9_= ]*/& transparent_hugepage=never/' /etc/default/grub \
| sudo tee /etc/default/grub 1>/dev/null
#overcommit_mem
echo "vm.overcommit_memory = 1" | sudo tee /etc/sysctl.conf 1>/dev/null
sudo sysctl vm.overcommit_memory=1 1>/dev/null
sudo update-grub &> /dev/null
echo """[Unit]
Description=Docker Compose CanaryTokens
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=${canarydir}
ExecStart=/usr/local/bin/docker-compose up
ExecStop=/usr/local/bin/docker-compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target""" \
| sudo tee /etc/systemd/system/canarytokens.service 1>/dev/null
sudo systemctl start canarytokens --quiet
sudo systemctl enable canarytokens --quiet
service canarytokens status
