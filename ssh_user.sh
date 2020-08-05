#!/bin/bash
# Chech the script is running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Ask what the user name will be
echo Hello, what will the user name be?
read varname
# Ask what the GitHub user name is
echo Hello, what is the GitHub user name?
read vargit

# add the new user account using the name provided above
adduser --disabled-password --gecos "" $varname
usermod -aG sudo $varname
# add user to sudoers
sudo sh -c "echo '$varname ALL=NOPASSWD: ALL' >> /etc/sudoers"

# check if user home dir exists, create if it doesn'
DIR="/home/$varname"
if [! -d "$DIR" ]; then
  mkdir /home/$varname
  chown $varname:$varname /home/$varname
  echo "Home directory created: ${DIR}..."
fi 

  # make the ssh directory under the users home folder
  mkdir /home/$varname/.ssh
  chmod 700 /home/$varname/.ssh
  chown $varname:$varname /home/$varname/.ssh
  touch /home/$varname/.ssh/authorized_keys

  # add key to authorized_keys from GitHub account
  wget -O - https://github.com/$vargit.keys | sudo tee -a /home/$varname/.ssh/authorized_keys
  
  ## can also use the following but you have to uncomment the line below and comment out the one above ##
  # import keys from github
  #ssh-import-id-gh $vargit

  chmod 600 /home/$varname/.ssh/authorized_keys
  chown $varname:$varname /home/$varname/.ssh/authorized_keys
  echo Thanks! The user $varname is now setup.


