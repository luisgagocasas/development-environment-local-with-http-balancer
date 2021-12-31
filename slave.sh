#!/bin/bash

step=1
step() {
  echo "Step $step $1"
  step=$((step+1))
}

setup_welcome_msg() {
  step "===== Install Message Welcome ====="
  sudo apt-get -y install boxes
  version=$(cat /etc/os-release |grep VERSION= | cut -d'=' -f2 | sed 's/"//g')
  ipserver=$(hostname -I | cut -d' ' -f2)
  sudo echo -e "\necho \"Welcome to management server with AyPhu \n IP Server: ${ipserver} \n Ubuntu Server ${version} \n Server: Slave #$1\" | boxes -d dog -a c\n" >> /home/vagrant/.bashrc
}

main() {
  setup_welcome_msg $1
}

main $1