# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  ## if you want a different OS, here is where you supply it...must be in Vagrant Cloud Repo
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.disk :disk, size: "150GB", primary: true
  config.vm.hostname = "Malcolm"

  # # port forwarding rules so our host machine can access vm web interface, vagrant automatically sets up ssh for us, so just adding http/htpps
  config.vm.network "forwarded_port", guest: 80, host: 6000
  config.vm.network "forwarded_port", guest: 443, host: 6001


  config.vm.provider "virtualbox" do |v|
    virtualbox = 1
    v.name = "Malcolm"
    # vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]  
    v.memory = 32000
    v.cpus = 4
    v.customize ["modifyvm", :id, "--ioapic", "on"]

    #networking for NAT
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]

    v.customize ["modifyvm", :id, "--cableconnected1", "on"]
  end
  
  ## From the vagrant docs for determining a VM provider.
  # 1. The --provider flag on a vagrant up is chosen above all else, if it is present.
  # 2. If the VAGRANT_DEFAULT_PROVIDER environmental variable is set, it takes next priority and will be the provider chosen.
  # 3. Vagrant will go through all of the config.vm.provider calls in the Vagrantfile and try each in order. It will choose the first provider that is usable. For example, if you configure Hyper-V, it will never be chosen on Mac this way. It must be both configured and usable.

  config.vm.provider "vmware_desktop" do |desktop|    
    desktop.vmx["memsize"] = "32000"
    desktop.vmx["numvcpus"] = "4" 
  end

  # windows things
  config.vm.provider "hyperv" do |hyperv|
    hyperv.memory = 32000
    hyperv.cpus = 4
  end

  config.vm.provider :libvirt do |libvirt, override|
    override.vm.box = "generic/ubuntu2004"
    libvirt.memory = 32000
    libvirt.cpus = 4
  end

  # macbook things
  config.vm.provider :parallels do |prl|
    prl.memory = 32000
    prl.cpus = 4
  end

  #set everything else up with ansible
  config.vm.provision "ansible" do |ansible|

    # Use for debugging ansible, add more v's for more verbosity
    # ansible.verbose = "v"   
    ansible.playbook = "playbook.yml"
    ansible.compatibility_mode = "2.0"
  end

end
