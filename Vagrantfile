# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "perforce/trusty64-min"
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  config.vm.define :saltmaster do |salt|
    salt.vm.network :private_network, ip: "192.168.44.101"
    salt.vm.hostname = 'salt-master'
    salt.vm.provision "shell", inline: "sh /vagrant/setup/init.sh master"
  end

  # test minion 
  config.vm.define :p4dhost do |salt|
    salt.vm.network :private_network, ip: "192.168.44.201"
    salt.vm.hostname = "p4d-host"
    salt.vm.provision "shell", inline: "sh /vagrant/setup/init.sh"
  end

  # test minion 
  config.vm.define :apphost do |salt|
    salt.vm.network :private_network, ip: "192.168.44.51"
    salt.vm.hostname = "app-host"
    salt.vm.provision "shell", inline: "sh /vagrant/setup/init.sh"
  end

end
