#!/bin/bash
# Chech the script is running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Ask what the user name will be
echo Hello, what will the user name be?
read varname
# Check if user exists already
exists=$(grep -c "$varname" /etc/passwd)
if [ $exists -gt 0 ]; then
    echo "The user $varname already exists"
    echo "Check for a home directory and consider running the"
    echo "the sh_add_githubkey.sh script"
    exit
fi

# Ask what the GitHub user name is
echo Hello, what is the GitHub user name?
read vargit


# add the new user account using the name provided above
adduser --disabled-password --gecos "" $varname
usermod -aG sudo $varname
# add user to sudoers
sudoexists=$(grep -c "$varname" /etc/sudoers)
if [ $sudoexists -gt 0 ]; then
    echo "The user $varname already exists in sudoers"
    else
    sudo sh -c "echo '$varname ALL=NOPASSWD: ALL' >> /etc/sudoers"
fi

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


