#cloudbuild - quickconfig a random machine in DigitalOcean

droplet_name=josh
do_size=s-1vcpu-1gb
provision_user=josh
do_image=docker-18-04
postboot_command="mkdir /tmp/j && git clone https://github.com/joshhighet/j.git /tmp/j --quiet && cd /tmp/j && chmod +x j.sh && ./j.sh"

##########
command -v doctl \
>/dev/null 2>&1 || \
{ echo >&2 "doctl required : github.com/digitalocean/doctl"; exit 1; }
command -v lolcat \
>/dev/null 2>&1 || \
{ echo >&2 "lolcat required : github.com/busyloop/lolcat"; exit 1; }
##########
instance_overlap=`doctl compute droplet list $droplet_name --format ID --no-header`
ssh_pubkey_fingerprint=`doctl compute ssh-key list --no-header --format FingerPrint | head -n 1`
#########
if [ "$instance_overlap" ]
then printf "droplet $droplet_name already exists\nremove this droplet with : "
printf "doctl compute droplet delete $instance_overlap\n" | lolcat
exit 0
fi
if [ -z "$ssh_pubkey_fingerprint" ]
then printf "add an ssh pubkey to to proceed\nadd with : "
printf "doctl compute ssh-key import ~/.ssh/id_rsa.pub\n" | lolcat
exit 0
fi
#########
printf "\n🔥 new droplet incoming 🔥️\n\n" | lolcat --animate --speed=60
region[1]="nyc1" region[2]="sgp1" region[3]="lon1"
region[4]="nyc3" region[5]="ams3" region[6]="fra1"
region[7]="tor1" region[8]="sfo2" region[9]="blr1"
whatWan=${#region[@]} selecta=$(($RANDOM % $whatWan))
#########
doctl compute droplet create \
$droplet_name --size $do_size \
--image $do_image \
--enable-ipv6 \
--region ${region[$selecta]} \
--ssh-keys $ssh_pubkey_fingerprint \
--format ID,Name,Memory,VCPUs,Disk,Region,Image | lolcat --animate --speed=5
#########
printf "\n"
printf "🖥️  droplet  provisioning - standby 🖥️ \n\n" | lolcat --animate --speed=15
doctl compute droplet list $droplet_name \
--format PublicIPv4,PublicIPv6 | lolcat --animate --speed=60
printf "\n🎀 waiting for droplet to accept inbound connections 🎀\n\n" | lolcat --animate --speed=1
shelladdr=`doctl compute droplet list $droplet_name --format PublicIPv4 --no-header`
#########
if [[ "$1" == "--quick" ]]; then
  printf "🏎️ 💨 quickmode selected- customconfig will not be applied 🏎️ 💨\n\n" | lolcat
  ticker=0;
  until ssh \
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no \
  -t root@$shelladdr || [ $ticker -eq 20 ]; \
  do sleep 1; (( COUNT++ )); done
  printf "\n 👋 🛑 ✋ "
  doctl compute droplet delete $droplet_name
  exit 0
fi
#########
sleep 90
#########
printf "⏰ init. custom provisioning - this will take a few mins ⏰\n\n" | lolcat --animate --speed=15
ssh \
-o UserKnownHostsFile=/dev/null \
-o StrictHostKeyChecking=no \
-t root@$shelladdr $postboot_command
#ticker=0;
#until ssh \
#-o UserKnownHostsFile=/dev/null \
#-o StrictHostKeyChecking=no \
#-t root@$shelladdr $postboot_command || [ $ticker -eq 1 ]; \
#do sleep 1; (( COUNT++ )); done
printf "\n🏁 all done - droplet restarting - standby 🏁\n\n" | lolcat --animate --speed=15
#########
sleep 35
#########
ssh \
-o UserKnownHostsFile=/dev/null \
-o StrictHostKeyChecking=no \
-t $provision_user@$shelladdr
#ticker=0;
#echo $provision_user
#until ssh \
#-o UserKnownHostsFile=/dev/null \
#-o StrictHostKeyChecking=no \
#-t $provision_user@$shelladdr || [ $ticker -eq 1 ]; \
#do sleep 1; (( COUNT++ )); done
#########
printf "\n 👋 🛑 ✋ "
doctl compute droplet delete $droplet_name
