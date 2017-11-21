# -*- mode: ruby -*-
# vi: set ft=ruby :
# vim: set ft=ruby :

# Before you first run vagrant up, please install vagrant-vbguest plugin:
# vagrant plugin install vagrant-vbguest

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "geerlingguy/ubuntu1604"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://gr:gros@case.bigecko.com/os/boxcutter-ubuntu1604.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 8088

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.16.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  #config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Disable default /vagrant synced folder.
  # http://superuser.com/a/757031
  config.vm.synced_folder '.', '/vagrant', :nfs => true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./data", "/data", :nfs => true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "1536"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo cp /vagrant/files/apt/sources.list /etc/apt/sources.list
  SHELL

  config.vm.provision "ansible_local" do |ansible|
    ansible.extra_vars = { ansible_ssh_user: 'vagrant', vagrant: true, zsh_user: 'vagrant' }
    ansible.provisioning_path   = "/vagrant/ansible"
    ansible.playbook            = "playbook.yml"
    ansible.galaxy_roles_path   = "ansible/roles"
    ansible.verbose             = true
    ansible.install             = true
    ansible.sudo                = true
  end

end

my_vagrantfile = File.expand_path('../Vagrantfile.my', __FILE__)
load my_vagrantfile if File.exists?(my_vagrantfile)
