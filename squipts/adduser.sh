################################################################################
# curl -L raw.githubusercontent.com/joshhighet/kerchow/main/access.sh | bash
################################################################################
USER=josh
EXTIP=`curl -s ipinfo.io/ip`
SSHKEYLOC=cdn.joshhighet.com/ssh
PASS=`openssl rand -base64 16`
adduser $USER --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "$USER:$PASS" | chpasswd
mkdir -p /home/$USER/.ssh
curl -s -L $SSHKEYLOC | tee /home/$USER/.ssh/authorized_keys
chown -R $USER:$USER /home/$USER
usermod -aG sudo $USER
printf 'cmd: ssh '$USER'@'$EXTIP''\\n
printf 'pass: '$PASS\\n
