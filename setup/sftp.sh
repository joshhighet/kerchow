#!/bin/sh

#custom vars
groupname=sftp #group that will be created for SFTP only users
uploaddir=/media/disk #directory uploads will be placed, reccomend an external mountpoint if in docker....
sharename=shared #communal user directory name
userdir=files #user directory name
appname=simplesftp #appname - should maybe fetch this from execution filename ?

#prettycolors
reset=$(tput sgr0)
good=$(tput setaf 2)
error=$(tput setaf 1)
highlight=$(tput setaf 3)
blink=$(tput blink)

#check execution is being initiated as root (0)
if ! [ "$(id -u)" = 0 ]; then
  printf "%s%s must be run as root! %s \nusage: sudo ./%s.sh \n" "$error" "$appname" "$reset" "$appname"
  logger $appname attempted execution without sufficient privledges
  exit 0
fi

#throw a pretty title before the message from below multichoice
printf "%s%s%s - " "$highlight" "$appname" "$reset"

#usage display, prints key mappings
display_usage() {
  echo
  echo "usage: $0"
  echo
  printf " -d, --deluser  revoke access\n"
  printf " -h, --help     display usage\n"
  printf " -a, --adduser  add new uplink user\n"
  printf " -i, --info     show current accounts\n"
  printf " -o, --oview    show collection stats\n"
  printf " -s, --setup    perform initial setup\n"
  printf " -r, --remove   disable, remove & delete\n"
  printf " -n, --newssh   add new downlink user %s(admin optional)%s\n" "$highlight" "$reset"
  echo
}

#error function, called at different stages when something borks
raise_error() {
  printf "%sinvalid command %s\n" "$error" "$reset"
  logger $appname invalid command recieved
}

#some over-engineered way of checking wether a group exists, should have just used /etc/groups smh
#broken with zsh
existance=$(cut -d: -f1 /etc/passwd | xargs groups | grep $groupname)
#i honestly don't know what I've done here
groupexistance=$(getent group | awk -F '[,:]' '{ print $1, NF - 3 }' | grep $groupname | sort -k2,2n)

setup() {
  #check wether an app marker has been created
  if [ -e /root/.$appname ]
  then
    #we know setup has already been run as marker present, bailing
    printf "%salready setup! %s\n" "$error" "$reset"
    logger $appname attempted setup when already setup
    exit 0
  else
    if
    #check wether group name already exists
    [ -z "$groupexistance" ]
    then
      #check wether the mountpoint is already in existance
      if [ -e $uploaddir/$sharename ]
      then
        #attempted setup in directory already utilised, bailing to avoid overwrite
        printf "%s$uploaddir/$sharename already exists! %s\n" "$error" "$reset"
        logger $appname upload directory already exists, check presence and modify variables uploaddir sharename if required
        exit 0
      else
        #check wether password based auth is enabled on the ssh server
        if ! grep -q "PasswordAuthentication no" /etc/ssh/sshd_config;
        then
          #enforcing key-based auth, bailing setup if enabled
          printf "%skey based auth must be enabled within sshd_config to proceed %s\n" "$error" "$reset"
          #this would probs work to handle the above without operator handling: sed "/^[^#]*PasswordAuthentication[[:space:]]yes/c\PasswordAuthentication no" /etc/ssh/sshd_config
          logger $appname can not be run whilst password-based auth enabled, enable keyauth to proceed
          exit 0
        else
          #check wether sshd is broadcasting on default port
          if grep -q "Port 22" /etc/ssh/sshd_config;
          then
            #if sshd is running on 22, blast the user with warnings
            printf "%sreccomend changing the sshd broadcast port from 22 %s\n" "$highlight" "$reset"
            if
            #request confirmation on default ports before proceeding
            [[ "no" == $(confirmation "are you sure you want to proceed on default ports?") || \
            "no" == $(confirmation "are you really sure - this is prone to$error cyberweapons$reset") ]]
            then
              #if user says no to proceeding on default ports, bail
              printf '%s%s%s%s\n' "$error" "$blink" "action cancelled" "$reset"
              logger $appname cancelled after reccomending sshd broadcast on non-default port
              exit 0
            fi
          fi
          if
          #run prelim checks before kicking off setup
          #print variables to ensure as expected
          [[ "no" == $(confirmation "are you sure you want to setup?") || \
          "no" == $(confirmation "confirm the below config
          $highlight Group Name $reset= $groupname
          $highlight Chroot Jail Directory $reset= $uploaddir $error- recursive ownership will be modified! $reset
          $highlight Share Name $reset= $sharename
          $highlight User Upload Directory $reset= $userdir") ]]
          then
            #if user says no to confirming setup commencement, bail
            printf '%s%s%s%s\n' "$error" "$blink" "action cancelled" "$reset"
            logger $appname did not get confirmation to proceed during setup, exiting
            exit 0
          else
            #if all the above is cleared, kick off the setup
            cp /etc/ssh/sshd_config /etc/ssh/sshd_config.$appname
            #backup sshd config in case we blow up
            printf "%ssshd_config backed up to /etc/ssh/sshd_config.%s \n %s" "$good" "$appname" "$reset"
            logger $appname sshd_config backed up to /etc/ssh/sshd_config.$appname
            #create app marker in root directory, dumb way to impliment a prelim check
            touch /root/.$appname
            logger $appname bookmark placed within /root/.$appname
            #create the upload dir
            mkdir -p $uploaddir
            #make root owner of upload dir
            sudo chown root:root $uploaddir
            #751 the upload dir
            sudo chmod 751 $uploaddir
            #create the sftp-only upload group
            groupadd $groupname
            logger $appname created group $groupname
            #bounce our config into the sshd config file
            echo "Match group sftp
            ChrootDirectory $uploaddir/%u
            AllowTCPForwarding no
            X11Forwarding no
            ForceCommand internal-sftp" >> /etc/ssh/sshd_config
            logger $appname modified sshd_config
            #restart ssh process after messing with the config file to apply
            service sshd reload
            logger $appname restarted sshd daemon sshd_config
            #create communal upload directory
            mkdir $uploaddir/"$sharename"
          fi
        fi
      fi
    else
      #if sftp only upload group exists, bail (wrong side of if statement, should be at top with other prelims)
      printf "%sgroup %s already exists %s\n" "$error" "$groupname" "$reset"
      logger $appname group $groupname already exists, check group and mod variables if required
      exit 0
    fi
  fi
}

disable_sftp () {
  #check wether the app-marker from setup is present, if not bail. can't disable if not setup
  if [ -e /root/.$appname ]
  then
    #check upload group exists
    if [ -z "$groupexistance" ]
    then
      #something weird is going on. setup probrally broke halfway through
      printf "%sgroup %s does not exist %s" "$error" "$groupname" "$reset"
      logger $appname app marker in place but group does not exist. you gotta problem
      exit 0
    else
      if
      #get confirmation before nuking config
      [[ "no" == $(confirmation "are you sure you want to remove all config?") || \
      "no" == $(confirmation "are you really really really sure?") ]]
      then
        #if user does not give us the green, bail
        printf '%s%s%s%s\n' "$error" "$blink" "action cancelled" "$reset"
        logger $appname tried to remove but did not get confirmation from user, exiting
        exit 0
      fi
      #ask again before blowing it away
      read -p "are you certain you want to proceed with the removal of group $groupname (y/n)" -n 1 -r
      echo
      #should invoke confirmation function here
      #if we get a yes reply from the above, proceed with destruction
      if [[ $REPLY =~ ^[Yy]$ ]]
      then
        logger $appname got the green light to remove config, goodbye sftp!
        #remove group
        delgroup $groupname
        logger $appname has removed usergroup $groupname
        printf "%s removed" "$groupname"
        #get rid of the config we added into the sshd_config file for sftp-only uploaders
        #could probrally move the backup we made at setup back into place, but this lets us keep other config if added
        sed '/Match group sftp/,/ForceCommand internal-sftp/d' /etc/ssh/sshd_config -i
        logger $appname has removed the config from sshd_config
        printf "\nsftp settings removed from sshd_config\n"
        rm /root/.$appname
        echo
        printf "%sconfig removed%s\n" "$good" "$reset"
      else
        exit 0
        logger $appname attempted removal bbut did not get confirmation, exiting
        #had a way to remove the upload directory, but would rather leave this call to the operator manually to downplay risk
          #read -p "delete the upload directory $uploaddir ? (y/n)" -n 1 -r
          #if [[ $REPLY =~ ^[Yy]$ ]]
          #then
          #rm -rf $uploaddir
          #printf "the sftp directory %s has been removed \n" "$uploaddir"
          #else
          #printf "the sftp directory %s has not been removed \n" "$uploaddir"
        #fi
      fi
    fi
  else
    #not sure why we would invoke the removal string if we have not setup, but just to be safe have this guy handy
    printf "run %s./%s --setup%s first\n" "$highlight" "$appname" "$reset"
    logger $appname attempted removal when not setup
    exit 0
  fi
}

new_consoleuser() {
  #check wether the app-marker from setup is present, if not bail. can't disable if not setup
  if [ -e /root/.$appname ]
  #if the app-marker is present, proceed
  then
    #get username to add
    read -p 'username: ' user
    if
    #get user from passwd
    #check wether username already taken
    [ "grep -c "$user" /etc/passwd" == 1 ]
    then echo "$user already exists"
    logger "$appname" can not create user with overlapping username, bailing - "$user" already esists
    exit 0
  else
    #if user is unique, proceed
    #get openSSH key, store in memory for now
    read -p 'opsnSSH public key: ' sshkey
    #get user confirmation before creating user
    if
    #make creator aware this is a LOCAL account and not a SFTP chrooted account
    [[ "no" == $(confirmation "are you sure you want to create an account for $user?") || \
    "no" == $(confirmation "are you really sure - this will provide more access than required for basic file submissions?") ]]
    then
      printf '%s%s%s%s\n' "$error" "$blink" "action cancelled" "$reset"
      logger $appname tried to create new console user but did not get confirmation, bailing
      exit 0
    fi
    #if everything above clears, proceed with workflow
    adduser "$user"
    logger "$appname": has created a new local user account for :"$user"
    #create user's ssh directory, required for keybased auth
    mkdir /home/"$user"/.ssh
    logger "$appname" "$user" .ssh directory created
    #send their public key into a keyfile (will be created when piped)
    echo "$sshkey" >> /home/"$user"/.ssh/authorized_keys
    logger "$appname" has added "$user" ssh keyfile into /home/"$user"/.ssh/authorized_keys
    #get input from operator as to wether account should be in sudoers
    read -p "give user sudo rights? (y/n)" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    #if operator says yes to above question, give superpowers
    then
      usermod -aG sudo "$user"
      logger "$appname" made "$user" a sudoer
    else
      #if no sudo rights given, finish and note accordingly
      printf "access created - %s has not been added to sudoers\n" "$user"
    fi
  fi
else
  printf "run %s./%s --setup%s first\n" "$highlight" "$appname" "$reset"
  logger $appname attempted setup, but setup has not been run, bailing.
  exit 0
fi

}

add_user() {
  #check wether the app-marker from setup is present, if not bail. can't add user if not setup
  if [ -e /root/.$appname ]
  then
    #get username
    read -p 'username: ' user
    #get sshkey
    read -p 'openSSH public key: ' sshkey
    #check wether directory already in existance
    if [ -d "$uploaddir"/"$user"/"$sharename" ];
    then
      #if directory exists, backout
      printf "$uploaddir/$user/$sharename already exists\n"
      logger $appname attempted to create new user "$user" but directory was present. bailing
      exit 0
    else
      #get confirmation from operator before adding new user
      if [[ "no" == $(confirmation "are you sure you want to give access to ""$user"?) || \
      "no" == $(confirmation "are you really sure?") ]]
      then
        #if operator does not give the clear, backout
        printf '%s%s%s%s\n' "$error" "$blink" "action cancelled" "$reset"
        logger $appname tried to create new user but did not get confirmation from operator, bailing
        exit 0
      fi
      #if above checks are passed, proceed
      #create user without a shell login, define their group and set their home directory
      useradd --system --shell /usr/sbin/nologin --groups $groupname --home $uploaddir/"$user" "$user"
      #give root full ownership of their home directory
      sudo chown root:root $uploaddir
      sudo chmod 751 $uploaddir
      #create the home directory we assigned the user in the above
      mkdir $uploaddir/"$user"
      chown root:$groupname $uploaddir/"$user"
      chmod 751 $uploaddir/"$user"
      #create the single-upload directory for the user
      mkdir $uploaddir/"$user"/"$userdir"
      #create the communal space for the user to upload into
      mkdir $uploaddir/"$user"/"$sharename"
      #bind the communal directory to the directory we created above (similar to symlinking, but goddamn that breaks everything)
      mount --bind $uploaddir/"$sharename" $uploaddir/"$user"/"$sharename"
      chown "$user":$groupname $uploaddir/"$user"/"$userdir"
      chmod 751 $uploaddir/"$user"/"$userdir"
      chown "$user":$groupname $uploaddir/"$user"/"$sharename"
      chmod 755 $uploaddir/"$user"/"$sharename"
      chmod 755 $uploaddir/"$sharename"
      #create a .ssh directory for the user's keyfile to be housed within
      mkdir $uploaddir/"$user"/.ssh
      #blast their ssh key into a keyfile in the recently created directory
      echo "$sshkey" >> $uploaddir/"$user"/.ssh/authorized_keys
      #give the user full rights to the .ssh directory to avoid hell when connecting
      chown -R "$user":"$user" $uploaddir/"$user"/.ssh
      printf "%s%s now has access\n%s" "$highlight" "$user" "$reset"
    fi
  else
    printf "run %s./%s --setup%s first\n" "$highlight" "$appname" "$reset"
    logger $appname attempted to add new user without setup, bailing
    exit 0
  fi
}

disable_user() {
  if
  #check wether the app-marker from setup is present, if not bail. can't disable if not setup
  [ -e /root/.$appname ]
  then
    if [ -z "$existance" ]
    #existance will check for users within the upload user group and bail if no users are found
    then
      printf "%sno active users within group %s %s\nrun %s./%s --adduser%s to get started \n" "$error" "$groupname" "$reset" "$highlight" "$appname" "$reset"
      logger $appname attempted to disable user but no users exist! bailing
      exit 0
    else
      #get user to remove
      read -p 'user to remove: ' user
      #set some exec-specific vars
      #broken on zsh
      userdir=$(getent passwd "$user" | cut -f6 -d:)
      userstate=$(grep -c "$user" /etc/passwd)
      if
      #check if user exists
      [ "$userstate" == 1 ]
      then echo "$user exists"
      if
      #get confirmation from operator before removing
      [[ "no" == $(confirmation "are you sure you want to revoke access for $user?") || \
      "no" == $(confirmation "are you really sure?") ]]
      then
        #if explicit yes not given, bail workflow
        printf '%s%s%s%s\n' "$error" "$blink" "action cancelled" "$reset"
        logger $appname attempted to disable user but did not get operator confiration, bailing
        exit 0
      fi
      if
      #user exists AND belongs to the sftp upload group
      id -nG "$user" | grep -qw $groupname;
      then
        #delete user
        echo """$user""" belongs to group: $groupname
        printf "%s's directory (%s) will not be removed automatically" "$user" "$userdir"
        #remove the moutnpoint for the communal directory
        umount $uploaddir/"$user"/"$sharename"
        echo
        deluser "$user"
      else
        echo "$user" exists but does not belong to group: $groupname
        logger $appname attempted to disable user but user does not belong within the uploader group, bailing
        exit 0
      fi
    else
      printf "%s does not exist\nrun ./%s --info to to find users within group %s" "$user" "$appname" "$groupname"
      echo
      logger $appname attempted to remove a user that does not exist, bailing
      exit 0
    fi
  fi
else
  printf "run %s./%s --setup%s first\n" "$highlight" "$appname" "$reset"
  logger $appname attempted to disable a user but setup has not been run, bailing
  exit 0
fi
}

show_users() {
  #check wether the app-marker from setup is present, if not bail. can't disable if not setup
  if [ -e /root/.$appname ]
  then
    if [ -z "$existance" ]
    #existance will check for users within the upload user group and bail if no users are found
    then
      printf "%sno active users within group %s %s\nrun %s./%s --adduser%s to add a new user \n" "$error" "$groupname" "$reset" "$highlight" "$appname" "$reset"
      logger $appname attempted to print users within uploaders group but none exist!
      exit 0
    else
      #if users exist within this directory, get a list of the users and provide to operator
      printf users
      echo
      cut -d: -f1 /etc/passwd | xargs groups | grep $groupname
    fi
  else
    printf "run %s./%s --setup%s first\n" "$highlight" "$appname" "$reset"
    logger $appname attempted to print users but setup has not been run!
    exit 0
  fi
}

disk_oview() {
  if
  #check wether the app-marker from setup is present, if not bail. can't disable if not setup
  [ -e /root/.$appname ]
  then
    #if setup run, print a tree of the directory with an accompanying size
    #check if tree is installed
    dpkg -s tree &> /dev/null
    if [ $? -eq 0 ];
#if tree installed, run the report
    then
      printf "%supload report to %s - %s %s\n" "$highlight" "$uploaddir" "$appname" "$reset"
      tree --du -h $uploaddir
    else
      #if tree is not installed, install first and run report
      printf "package %stree%s not installed, installing\n" "$highlight" "$reset"
      apt-get install -qq -o=Dpkg::Use-Pty=0 tree
      printf "package %stree%s installed\n" "$highlight" "$reset"
      printf "%supload report to %s - %s %s\n" "$highlight" "$uploaddir" "$appname" "$reset"
      tree --du -h $uploaddir
    fi
  else
    printf "run %s./%s --setup%s first\n" "$highlight" "$appname" "$reset"
    logger $appname attempted to run a disk stat but setup has not been run, bailing
    exit 0
  fi
}

handsfree_setup() {
  #check wether an app marker has been created
  mkdir $uploaddir
  #check wether password based auth is enabled on the ssh server
  if ! grep -q "PasswordAuthentication no" /etc/ssh/sshd_config;
  then
    #enforcing key-based auth, bailing setup if enabled
    printf "%skey based auth not enabled - enabling %s\n" "$error" "$reset"
    echo "PasswordAuthentication no" > /etc/ssh/ssh_config
    #this would probs work to handle the above without operator handling: sed "/^[^#]*PasswordAuthentication[[:space:]]yes/c\PasswordAuthentication no" /etc/ssh/sshd_config
    logger $appname can not be run whilst password-based auth enabled, now enabled
    exit 0
  else
    cp /etc/ssh/ssh_config /etc/ssh/ssh_config.$appname
    #backup sshd config in case we blow up
    printf "%sssh_config backed up to /etc/ssh/ssh_config.%s \n %s" "$good" "$appname" "$reset"
    logger $appname ssh_config backed up to /etc/ssh/ssh_config.$appname
    #create app marker in root directory, dumb way to impliment a prelim check
    touch /root/.$appname
    logger $appname bookmark placed within /root/.$appname
    #create the upload dir
    mkdir -p $uploaddir
    #make root owner of upload dir
    sudo chown root:root $uploaddir
    #751 the upload dir
    sudo chmod 751 $uploaddir
    #create the sftp-only upload group
    groupadd $groupname
    logger $appname created group $groupname
    #bounce our config into the sshd config file
    echo "Match group sftp
    ChrootDirectory $uploaddir/%u
    AllowTCPForwarding no
    X11Forwarding no
    ForceCommand internal-sftp" >> /etc/ssh/ssh_config
    logger $appname modified ssh_config
    #restart ssh process after messing with the config file to apply
    service sshd reload
    logger $appname restarted sshd daemon ssh_config
    #create communal upload directory
    mkdir $uploaddir/"$sharename"
  fi
}

argument="$1"
if [ -z "$argument" ] ; then
  printf "%sno arg given! %s" "$error" "$reset"
  display_usage
else
  case $argument in
    -h|--help)
    display_usage
    ;;
    -a|--adduser)
    add_user
    ;;
    -s|--setup)
    setup
    ;;
    -d|--deluser)
    disable_user
    ;;
    -x|--nohands)
    handsfree_setup
    ;;
    -r|--remove)
    disable_sftp
    ;;
    -i|--info)
    show_users
    ;;
    -n|--newssh)
    new_consoleuser
    ;;
    -o|--oview)
    disk_oview
    ;;
    *)
    raise_error "unknown arg: ${argument}"
    display_usage
    ;;
  esac
fi
#if [[ $- == *i* ]]; then
#  tput sgr0
#fi
printf "%s$appname %s - " "$good" "$reset"
printf '\e]8;;https://joshhighet.com\e\\@joshhighet\e]8;;\e\\\n'
