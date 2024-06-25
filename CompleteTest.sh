#!/bin/bash

$VBOX=0
$VMWARE=0
$LIBVIRT=0
$PARALLELS=0

./environment_setup.sh

./provider_setup.sh

echo "Who do you want to build your VM"
echo "1. VirtualBox"
echo "2. VMware"
echo "3. libvirt"
echo "4. parallels (Mac only)"
read -p "Enter your choice (1-4): " choice

#check if libvirt, virtualbox, or vmware, parallels
case $choice in
    1)
        #vbox
        $VBOX = 1
        exit 1
        ;;
    2)
        #VMWARE
        $VMWARE = 1
        exit 1
        ;;
    3)
        #Libvirt
        $LIBVIRT = 1
        exit 1
        ;;
    4)
        # parallels for macbook user
        $PARALLELS = 1
        exit 1
        ;;
    *)
        echo "Invalid choice. Please enter a valid option."
        exit 1
        ;;
esac

# I have seen one too many cows
export ANSIBLE_NOCOWS=1

if [ $LIBVIRT ]; 
then    
    
fi

vagrant up

# copy api json files to your host for analysis/verification
# default user is vagrant:vagrant
sshpass -p "vagrant" scp -P 2222 -r vagrant@localhost:/ApiTesting . && echo "malcolm api json data copied to ApiTesting/"

# commented out for now to make testing faster
# vagrant destroy