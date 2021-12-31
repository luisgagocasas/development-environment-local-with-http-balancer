# Development environment local with http balancer

Use this repository in development environment.

## Vagrant + Nginx balancer + docker + docker-compose

The purpose of this repository is to establish a development environment incorporating load balancing using nginx with some docker nodes to run containers of different technologies.

The idea is to emulate a production environment with load balancing of an application.

Maybe later install a database on the master vm.

## Technologies

- Vagrant + (VirtualBox)
- Docker
- Docker-compose
- Nginx (only vm master)

## Command

- vagrant validate
- vagrant up
- vagrant destroy -f
- vagrant status
- vagrant ssh master
- vagrant ssh slave01
- vagrant ssh slave02
- vagrant ssh -c "ls -ls" 2>/dev/null

## Variable important (Vagrantfile)
- VM_IP (IP base)
- SLAVE_SERVERS (number of slave)

## Folder for slave
- /project/ (this folder will be incorporated into the slaves)

## Document
- Nginx - load balancer https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/


## By

- Luis Gago Casas (https://luisgagocasas.com)