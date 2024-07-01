#!/bin/bash

$PWD=$(pwd)
$USER=$(whoami)

# Prompt user to select a VM provider
echo "Which VM provider do you want to use with Vagrant and install?"
echo "1. VirtualBox"
echo "2. VMware"
echo "3. libvirt"
echo "4. parallels (Mac only)"
read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        # Check if VirtualBox is installed
        if ! command -v VBoxManage &> /dev/null
        then
            echo "Virtualbox is not installed, installing..."
            sudo apt-get update && sudo apt-get install -y virtualbox
        fi

        # Install necessary Vagrant plugins for VirtualBox
        echo "virtualbox installed, no plugin needed and ready to go"
        exit 1
        ;;
    2)
        # Check if VMware is installed
        if ! command -v vmrun &> /dev/null
        then
            echo "VMware is not installed, installing..."
            echo "Now need to setup Broadcom account for VMware, unable to script this out as of now and need to install vmware manually"   
            # exit 1
        fi

        if dpkg-query -W vagrant-vmware-utility &> /dev/null
        then
            echo "vagrant-vmware-utility package is installed."
        else
            echo "vagrant-vmware-utility package is not installed, installing..."
            sudo apt-get install -y wget
            wget https://releases.hashicorp.com/vagrant-vmware-utility/1.0.21/vagrant-vmware-utility_1.0.21_x86_64.deb
            sudo apt install $PWD/vagrant-vmware-utility_1.0.21_x86_64.deb
            rm $PWD/vagrant-vmware-utility_1.0.21_x86_64.deb
        fi

        # Install necessary Vagrant plugins for VMware
        if vagrant plugin list | grep -q vagrant-vmware-desktop
        then
            echo "vmware plugin is already installed"
        else
            echo "installing plugin"
            vagrant plugin install vagrant-vmware-desktop
        fi

        exit 1
        ;;
    3)
        # libvirt
        if ! command -v virsh &> /dev/null
        then
            echo "libvirt is not installed, installing..."
            sudo apt-get install -y qemu libvirt-daemon-system ebtables libguestfs-tools ruby-fog-libvirt libvirt-dev libvirt-daemon libvirt-clients virt-manager python3-libvirt
            sudo usermod -a -G libvirt $USER
            sudo sed -i '81 s/^#//' /etc/libvirt/libvirtd.conf
        fi

        if vagrant plugin list | grep -q vagrant-libvirt
        then
            echo "vagrant-libvirt plugin is already installed."
        else
            echo "Installing vagrant-libvirt plugin..."
            vagrant plugin install vagrant-libvirt
        fi

        exit 1
        ;;
    4)
        # parallels for macbook user
        if ! command -v prlctl &> /dev/null
        then
            echo "Parallels Desktop is not installed. You will need to install this manually from their website"
        exit 1
        fi

        if vagrant plugin list | grep -q vagrant-parallels
        then
            echo "vagrant-parallels plugin is already installed."
        else
            echo "Installing vagrant-parallels plugin..."
            vagrant plugin install vagrant-parallels
        fi

        exit 1
        ;;
    *)
        echo "Invalid choice. Please enter a valid option."
        exit 1
        ;;
esac

echo "Setup complete for the selected VM provider."
