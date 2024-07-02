#!/bin/bash

VBOX=0
VMWARE=0
LIBVIRT=0
PARALLELS=0
LIGHT_TEST=0
MEDIUM_TEST=0
INTENSE_TEST=0
FULL_SCALE_TEST=0

# ./environment_setup.sh

# ./provider_setup.sh

./repo_selector.sh

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
        VBOX=1
        ;;
    2)
        #VMWARE
        VMWARE=1
        ;;
    3)
        #Libvirt
        LIBVIRT=1
        ;;
    4)
        # parallels for macbook users
        PARALLELS=1
        ;;
    *)
        echo "Invalid choice. Please enter a valid option."
        exit 1
        ;;
esac

echo "Choose Malcolm test intensity (number of pcaps ingested and tested)"
echo "1. Light"
echo "2. Medium"
echo "3. Intense"
echo "4. Full-scan"
read -p "Enter your choice (1-4): " choice

# zero out scan type variables in playbook
sed -i "0,/^\(\s*\)LIGHT_TEST:.*/ s|^\(\s*\)LIGHT_TEST:.*|\1LIGHT_TEST: $LIGHT_TEST|" playbook.yml
sed -i "0,/^\(\s*\)MEDIUM_TEST:.*/ s|^\(\s*\)MEDIUM_TEST:.*|\1MEDIUM_TEST: $MEDIUM_TEST|" playbook.yml
sed -i "0,/^\(\s*\)INTENSE_TEST:.*/ s|^\(\s*\)INTENSE_TEST:.*|\1INTENSE_TEST: $INTENSE_TEST|" playbook.yml
sed -i "0,/^\(\s*\)FULL_SCALE_TEST:.*/ s|^\(\s*\)FULL_SCALE_TEST:.*|\1FULL_SCALE_TEST: $FULL_SCALE_TEST|" playbook.yml 

#make test type chosen = 1 in the playbook
case $choice in
    1)
        LIGHT_TEST=1
        sed -i "0,/^\(\s*\)LIGHT_TEST:.*/ s|^\(\s*\)LIGHT_TEST:.*|\1LIGHT_TEST: $LIGHT_TEST|" playbook.yml
        ;;
    2)
        MEDIUM_TEST=1
        sed -i "0,/^\(\s*\)MEDIUM_TEST:.*/ s|^\(\s*\)MEDIUM_TEST:.*|\1MEDIUM_TEST: $MEDIUM_TEST|" playbook.yml
        ;;
    3)
        INTENSE_TEST=1
        sed -i "0,/^\(\s*\)INTENSE_TEST:.*/ s|^\(\s*\)INTENSE_TEST:.*|\1INTENSE_TEST: $INTENSE_TEST|" playbook.yml
        ;;
    4)
        FULL_SCALE_TEST=1
        sed -i "0,/^\(\s*\)FULL_SCALE_TEST:.*/ s|^\(\s*\)FULL_SCALE_TEST:.*|\1FULL_SCALE_TEST: $FULL_SCALE_TEST|" playbook.yml
        ;;
    *)
        echo "Invalid choice. Please enter a valid option."
        exit 1
        ;;
esac

# I have seen one too many cows
export ANSIBLE_NOCOWS=1

# if [ $LIBVIRT ]; then    
    
# fi

sudo vagrant provision

# copy api json files to your host for analysis/verification
# default user is vagrant:vagrant
if [ $VBOX ]; then
    sshpass -p "vagrant" scp -P 2222 -r vagrant@localhost:/ApiTesting . && echo "malcolm api json data copied to ApiTesting/"
fi

# commented out for now to make testing faster
# vagrant destroy