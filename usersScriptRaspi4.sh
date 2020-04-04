#!/bin/bash

set -e -x

# apt-get update && apt-get upgrade -y

# passwd $1
setupUserAccount () {

  if [ -z "$1" ]
  then
      echo "Please provide an EPFL username"
      return 1
  fi

  if [ -z "$2" ]
  then
      echo "Please provide an GitHub username"
      return 1
  fi

  echo "Setting up user $1"

  # In case you want to test...
  #read -e -p "Remove $1's home dir ? [Y/n] " YN
  #[[ $YN == "y" || $YN == "Y" || $YN == "" ]] && sudo userdel -r $1

  # Add the user with home folder and the correct rights
  sudo useradd -s /bin/bash $1 || true
  # Ensure that user's home dir exists
  sudo mkhomedir_helper $1 || true
  # Ensure that .ssh folder exists
  sudo mkdir /home/$1/.ssh || true
  # Ensure that the authorized_keys file exsits
  sudo touch /home/$1/.ssh/authorized_keys
  # Set the ownershop of the .ssh directory
  sudo chown $1:$1 -R /home/$1/.ssh
  # Ensure that only the 1 can access the .ssh directory
  sudo chmod 700 /home/$1/.ssh
  # Avoid anyone to access the authorized_keys
  sudo chmod 600 /home/$1/.ssh/authorized_keys

  echo "Importing $1 aka $2 keys from Github"
  # Import the ssh_keys of the user
  sudo ssh-import-id -o /home/$1/.ssh/authorized_keys gh:$2
}

setupUserAccount "nborboen" "ponsfrilus"
setupUserAccount "czufferey" "zuzu59"
setupUserAccount "quatrava" "domq"
setupUserAccount "javet" "tacticsch"
setupUserAccount "nreymond" "nicolasreymond"
setupUserAccount "jycosand" "saphirevert"
