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

# check if user home dir exists, create if it doesn'
DIR="/home/$varname"

if [! -d "$DIR" ]; then
    echo "Home directory doesn't exist"
else 
  # add key to authorized_keys from GitHub account
  wget -O - https://github.com/$vargit.keys | sudo tee -a /home/$varname/.ssh/authorized_keys
fi 
