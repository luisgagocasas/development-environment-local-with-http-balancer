#!/bin/bash

ensure_netplan_apply() {
  sleep 5
  sudo netplan apply
}

step=1
step() {
  echo "Step $1"
  step=$((step+1))
}

install_nginx() {
  step "===== Install Nginx Master ====="
  sudo apt-get update
  sudo apt-get install -y nginx
}

setup_welcome_msg() {
  step "===== Install Message Welcome ====="
  sudo apt-get -y install boxes
  version=$(cat /etc/os-release |grep VERSION= | cut -d'=' -f2 | sed 's/"//g')
  ipserver=$(hostname -I | cut -d' ' -f2)
  sudo echo -e "\necho \"Welcome to management server with AyPhu \n IP Server: ${ipserver} \n Ubuntu Server ${version} \n Server: Master\" | boxes -d dog -a c\n" >> /home/vagrant/.bashrc
  sudo ln -s /usr/games/boxes /usr/local/bin/boxes
}

server_config() {
  step "===== config $1 ====="
  slave=""

  for ((i=1;i<=$1;i++)); do
    slave+="server 192.168.1.20$i;\n"
  done

  echo -e "
  upstream web_backend {
    $slave
    ip_hash;
  }
  server {
    listen 80;
    location / {
      proxy_redirect      off;
      proxy_set_header    X-Real-IP \$remote_addr;
      proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header    Host \$http_host;
      add_header          X-Upstream \$upstream_addr always;
      add_header          ayphu \$remote_addr;
      proxy_pass http://web_backend;
    }
  }" | sudo tee /etc/nginx/sites-available/default
  sudo service nginx reload 
}

main() {
  # ensure_netplan_apply
  setup_welcome_msg
  install_nginx
  server_config $1
}

main $1