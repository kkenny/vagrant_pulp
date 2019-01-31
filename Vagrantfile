# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.provision "shell", inline: <<-SHELL
    yum install -y net-tools lsof wget
  SHELL

  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.memory = "512"
    vb.cpus = "1"
  end

  config.vm.define "chef" do |chef|
    chef.vm.network "private_network", ip: "10.0.0.3", netmask: "255.255.255.0"
    chef.vm.hostname = "chef"
    chef.vm.box = "centos/7"
    chef.vm.provision "shell", path: "bootstrap-chef.sh"
  end

  config.vm.define "pulp-master-01" do |pm1|
    pm1.vm.network "private_network", ip: "10.0.0.2", netmask: "255.255.255.0"
    pm1.vm.hostname = "pulp-master-01"
    pm1.vm.box = "centos/7"
    pm1.vm.provider :virtualbox do |pm1_vb|
      pm1_vb.memory = "1024"
      pm1_vb.cpus = "2"
    end
    pm1.vm.provision "shell", path: "bootstrap-pulp-master.sh"
  end

  config.vm.define "pulp-secondary-01", autostart: true do |ps1|
    ps1.vm.network "private_network", ip: "10.0.0.6", netmask: "255.255.255.0"
    ps1.vm.hostname = "pulp-secondary-01"
    ps1.vm.box = "centos/7"
    ps1.vm.provision "shell", path: "bootstrap-pulp-main-secondary.sh"
  end

  config.vm.define "lb1", autostart: false do |lb1|
    lb1.vm.network "private_network", ip: "10.0.0.4", netmask: "255.255.255.0"
    lb1.vm.network "forwarded_port", guest: 80, host: 8080
    lb1.vm.hostname = "lb1"
    lb1.vm.box = "centos/7"
#    lb1.vm.provision "shell", path: "bootstrap-lb-master.sh"
  end

  config.vm.define "pulp-secondary-02", autostart: false do |ps2|
    ps2.vm.network "private_network", ip: "10.0.0.7", netmask: "255.255.255.0"
    ps2.vm.hostname = "pulp-secondary-02"
    ps2.vm.box = "centos/7"
#    ps2.vm.provision "shell", path: "bootstrap-web.sh"
  end

  config.vm.define "client-01", autostart: false do |cl1|
    cl1.vm.network "private_network", ip: "10.0.0.8", netmask: "255.255.255.0"
    cl1.vm.hostname = "client-01"
    cl1.vm.box = "centos/7"
#    cl1.vm.provision "shell", path: "bootstrap-web.sh"
  end

  config.vm.define "client-02", autostart: false do |cl2|
    cl2.vm.network "private_network", ip: "10.0.0.9", netmask: "255.255.255.0"
    cl2.vm.hostname = "client-02"
    cl2.vm.box = "centos/7"
#    cl1.vm.provision "shell", path: "bootstrap-web.sh"
  end

  config.vm.define "lb2", autostart: false do |lb2|
    lb2.vm.network "private_network", ip: "10.0.0.5", netmask: "255.255.255.0"
    lb2.vm.hostname = "lb2"
    lb2.vm.box = "centos/7"
#    lb2.vm.provision "shell", path: "bootstrap-lb-slave.sh"
  end

end
