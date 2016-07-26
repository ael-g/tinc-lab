# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "node1" do |node1|
    node1.vm.box = "debian/contrib-jessie64"
    node1.vm.network "private_network", ip:'192.168.10.10'
    node1.vm.synced_folder "salt", "/srv/"
    node1.vm.hostname = "node1"
    node1.vm.provision :salt do |salt|
      salt.masterless = true
      salt.minion_config = "minion"
      salt.run_highstate = true
    end
  end

  config.vm.define "node2" do |node2|
    node2.vm.box = "debian/contrib-jessie64"
    node2.vm.network "private_network", ip:'192.168.10.11' 
    node2.vm.synced_folder "salt", "/srv/"
    node2.vm.hostname = "node2"
    node2.vm.provision :salt do |salt|
      salt.masterless = true
      salt.minion_config = "minion"
      salt.run_highstate = true
    end
  end

  config.vm.define "node3" do |node3|
    node3.vm.box = "debian/contrib-jessie64"
    node3.vm.network "private_network", ip:'192.168.10.12' 
    node3.vm.synced_folder "salt", "/srv/"
    node3.vm.hostname = "node3"
    node3.vm.provision :salt do |salt|
      salt.masterless = true
      salt.minion_config = "minion"
      salt.run_highstate = true
    end
  end

end
