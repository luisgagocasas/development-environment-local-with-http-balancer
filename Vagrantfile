# Variables
VM_IP = "192.168.1.20"
SLAVE_SERVERS = 2

# Parse variables command line
options = {}
options[:bridge] = ARGV[1] || "wlp0s20f3"

# Required plugin
unless Vagrant.has_plugin?("vagrant-docker-compose")
  system("vagrant plugin install vagrant-docker-compose")
  puts "Dependencies installed, please try the command again."
  exit
end

Vagrant.configure("2") do |config|
  # VM Master
  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.box = "ubuntu/focal64"
    master.vm.box_version = "20211026.0.0"
    master.vm.box_check_update = false
    master.vm.provision:shell, inline: <<-SHELL
      echo "root:rootroot" | sudo chpasswd
      sudo timedatectl set-timezone America/Lima
    SHELL
    master.vm.network :public_network, bridge: options[:bridge], ip: "#{VM_IP}0"
    master.vm.provision :shell, inline: "apt-get update"
    master.vm.provision :shell, path: "master.sh", args: SLAVE_SERVERS
  end

  # Slave loop
  (1..SLAVE_SERVERS).each do |i|
    config.vm.define "slave0#{i}" do |slave|
    slave.vm.hostname = "slave0#{i}"
    slave.vm.box = "ubuntu/focal64"
    slave.vm.box_version = "20211026.0.0"
    slave.ssh.insert_key = true
    slave.vm.box_check_update = false
    slave.vm.provision:shell, inline: <<-SHELL
      echo "root:rootroot" | sudo chpasswd
      sudo timedatectl set-timezone America/Lima
    SHELL
    slave.vm.network :public_network, bridge: options[:bridge], ip: "#{VM_IP}#{i}"
    slave.vm.provision :shell, inline: "apt-get update"
    slave.vm.provision :shell, path: "slave.sh", args: "#{i}"
    slave.vm.provision :file, source: "project", destination: "$HOME/"
    slave.vm.provision :docker
    slave.vm.provision :docker_compose, yml: "/home/vagrant/project/docker-compose.yml", run: "always"
    # Info update realtime (host -> vm)
    # slave.vm.synced_folder "project", "/home/vagrant/project"
    # Info upload file for SCP not realtime (host -> vm)
    # slave.vm.provision :docker_compose, yml: "/home/vagrant/project/docker-compose.yml", run: "always"
    end
  end

  config.trigger.after :up do |trigger|
    trigger.info = "Finish run process!!"
    trigger.run_remote = { path: "summary.sh", args: [VM_IP, SLAVE_SERVERS] }
  end
end