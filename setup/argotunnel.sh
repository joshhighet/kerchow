#!/usr/bin/env bash
#cloudflared dual-argo-tunnel setup [interactive] [debian]
#joshhighet
loglevel=warn
serviceuser=cloudflared
servicegroup=cloudflared-grp
####################
logfile=/var/log/cloudflared-https.log
sshlogfile=/var/log/cloudflared-ssh.log
sshurl=ssh://localhost:22
####################
#preliminary checks#
####################
if [ "$EUID" -ne 0 ]
  then echo "argo setup needs root!"
  exit
fi
#check response code from cloudflare
if [[ $(curl -s -I https://dash.cloudflare.com | head -n 1) = *401 ]]; then
  printf "unable to reach cloudflare to continue setup\n"
  exit
fi
#check if folder structure pre-existing as some changes below will make resursive changes
[ -d "/etc/cloudflared" ] && echo "/etc/cloudflared already exists!" && exit
[ -d "/etc/cloudflared-ssh" ] && echo "/etc/cloudflared-ssh already exists" && exit
#check if user we plan to create for isolated service exists already
getent passwd $serviceuser > /dev/null 2&>1
if [ $? -eq 0 ]; then
    printf "user $serviceuser already exists\n"
    exit 0
fi
#https tunnel variables
printf "primary FQDN [i.e web.joshhighet.com] : " && read hostname
printf "local binding URL [i.e http://localhost:80] : " && read url
url_validity=`curl -s -I --insecure $url`
#if [[ $(curl -s -I --insecure https://localhost:443 | grep 'HTTP/1.1') = *302* ]]; then
#if [[ $(netstat -apn | grep ':::443') = *LISTEN* ]]; then
if [ -z "$url_validity" ]
then
printf "\nunable to communicate with local webservice : "
echo $url | lolcat
exit 0
fi
printf "tag [i.e bikinibottom=https] - enter for no tags : " && read tag
#ssh tunnel
printf "secondary FQDN for SSH [i.e ssh.joshhighet.com] : " && read sshhostname
printf "tag [i.e bikinibottom=ssh] - enter for no tags : " && read tag
#add group "$servicegroup" for user "$serviceuser"
addgroup $servicegroup \
--quiet
#add user "$serviceuser" without home directory or interactive capabilities
adduser \
--quiet \
--gecos "" \
--disabled-login \
--disabled-password \
--ingroup $servicegroup \
$serviceuser
########################
#begin primary install #
########################
#creating cloudflared home directory
mkdir /etc/cloudflared
#creating cloudflared-ssh home directory
mkdir /etc/cloudflared-ssh
#downloading cloudflared
wget --quiet https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb \
-O /tmp/cloudflared.deb
#downloading cloudflared-ssh
wget --quiet https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.tgz \
-O /tmp/cloudflared-ssh.tgz
#installing cloudflared
sudo dpkg -i /tmp/cloudflared.deb > /dev/null
#unpacking cloudflared-ssh tarball
tar -xvf /tmp/cloudflared-ssh.tgz -C /tmp \
> /dev/null
mv /tmp/cloudflared /usr/local/bin/cloudflared-ssh
#creating cloudflared logfiles & pid markers
touch $logfile
touch $sshlogfile
touch /etc/cloudflared/pid
touch /etc/cloudflared-ssh/pid
#populating cloudflared config file
echo "hostname: $hostname" > /etc/cloudflared/config.yml
echo "url: $url" >> /etc/cloudflared/config.yml
echo "loglevel: $loglevel" >> /etc/cloudflared/config.yml
echo "logfile: $logfile" >> /etc/cloudflared/config.yml
echo "tunnel_tag: $tag" >> /etc/cloudflared/config.yml
echo "pidfile: /etc/cloudflared/pid" >> /etc/cloudflared/config.yml
#populating cloudflared-ssh config file
echo "hostname: $sshhostname" > /etc/cloudflared-ssh/config.yml
echo "url: $sshurl" >> /etc/cloudflared-ssh/config.yml
echo "logfile: $sshlogfile" >> /etc/cloudflared-ssh/config.yml
echo "loglevel: $loglevel" >> /etc/cloudflared/config.yml
echo "tunnel_tag: $sshtag" >> /etc/cloudflared-ssh/config.yml
echo "pidfile: /etc/cloudflared-ssh/pid" >> /etc/cloudflared-ssh/config.yml
#configuring cloudflared systemd files
echo """[Unit]
Description=Update Argo Tunnel

[Timer]
OnCalendar=daily

[Install]
WantedBy=timers.target""" \
| tee /etc/systemd/system/cloudflared-update.timer /etc/systemd/system/cloudflared-ssh-update.timer 1>/dev/null
echo """[Unit]
Description=Update Argo Tunnel

[Timer]
OnCalendar=daily

[Install]
WantedBy=timers.target
/etc/systemd/system/cloudflared-update.service
[Unit]
Description=Update Argo Tunnel
After=network.target

[Service]
User=$serviceuser
Group=$servicegroup
ExecStart=/bin/bash -c '/usr/local/bin/cloudflared update; code=\$?; if [ \$code -eq 64 ]; then systemctl restart cloudflared; exit 0; fi; exit \$code'""" \
| tee /etc/systemd/system/cloudflared-update.service /etc/systemd/system/cloudflared-ssh-update.service 1>/dev/null
sed -i 's/cloudflared;/cloudflared-ssh/g' /etc/systemd/system/cloudflared-ssh-update.service
sed -i 's/cloudflared-update/cloudflared-ssh-update/g' /etc/systemd/system/cloudflared-ssh-update.service
sed -i 's/\/usr\/local\/bin\/cloudflared/\/usr\/local\/bin\/cloudflared-ssh/g' /etc/systemd/system/cloudflared-ssh-update.service
echo """[Unit]
Description=Argo Tunnel
After=network.target

[Service]
User=$serviceuser
Group=$servicegroup
TimeoutStartSec=0
Type=notify
ExecStart=/usr/local/bin/cloudflared --config /etc/cloudflared/config.yml --origincert /home/$serviceuser/.cloudflared/cert.pem --no-autoupdate
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target""" \
| tee /etc/systemd/system/multi-user.target.wants/cloudflared.service /etc/systemd/system/multi-user.target.wants/cloudflared-ssh.service 1>/dev/null
sed -i 's/\/usr\/local\/bin\/cloudflared/\/usr\/local\/bin\/cloudflared-ssh/g' /etc/systemd/system/multi-user.target.wants/cloudflared-ssh.service
sed -i 's/cloudflared\/config/cloudflared-ssh\/config/g' /etc/systemd/system/multi-user.target.wants/cloudflared-ssh.service
ln -s /etc/systemd/system/multi-user.target.wants/cloudflared.service /etc/systemd/system/cloudflared.service
ln -s /etc/systemd/system/multi-user.target.wants/cloudflared-ssh.service /etc/systemd/system/cloudflared-ssh.service
#
chmod 644 /etc/systemd/system/cloudflared-ssh*
chown --recursive $serviceuser:$servicegroup /etc/cloudflared
chown --recursive $serviceuser:$servicegroup /etc/cloudflared-ssh
chown --recursive $serviceuser:$servicegroup /var/log/cloudflared*
chown --recursive $serviceuser:$servicegroup /etc/systemd/system/cloudflared*
chown --recursive $serviceuser:$servicegroup /usr/local/bin/cloudflared
#checking for cloudflared updates
runuser -l $serviceuser -c '/usr/local/bin/cloudflared update'
runuser -l $serviceuser -c '/usr/local/bin/cloudflared-ssh update'
#printf "authenticating argo tunnel\n\n"
runuser -l $serviceuser -c '/usr/local/bin/cloudflared login'
#test
systemctl start cloudflared
systemctl start cloudflared-ssh
systemctl enable cloudflared --quiet
systemctl enable cloudflared-ssh --quiet
