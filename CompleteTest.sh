#!/bin/bash

VBOX=0
VMWARE=0
LIBVIRT=0
PARALLELS=0
LIGHT_TEST=0
MEDIUM_TEST=0
INTENSE_TEST=0
FULL_SCALE_TEST=0

echo "Who do you want to build your Malcolm VM (must already be installed and configured with setup script)"
echo "1. VirtualBox"
echo "2. VMware"
echo "3. libvirt"
echo "4. parallels (Mac only)"
read -p "Enter your choice (1-4): " choice
echo ""

#check if libvirt, virtualbox, or vmware, parallels
case $choice in
    1)
        VBOX=1
        ;;
    2)
        VMWARE=1
        ;;
    3)
        LIBVIRT=1
        ;;
    4)
        PARALLELS=1
        ;;
    *)
        echo "Invalid choice. Please enter a valid option."
        exit 1
        ;;
esac

# Bash script to select Git repo and version location and update Ansible playbook
update_playbook() {
    local repo_url="$1"
    local version="$2"
    
    # Example: Update playbook.yml with sed
    # Adjust this according to your playbook structure and how you want to replace the URL and version
    sed -i "s|^\(\s*\)MALCOLM_REPO:.*|\1MALCOLM_REPO: '$repo_url'|" playbook.yml
    sed -i "s|^\(\s*\)MALCOLM_VERSION:.*|\1MALCOLM_VERSION: '$version'|" playbook.yml
    
    echo "Ansible playbook updated successfully with repo URL: $repo_url and version: $version"
}


# Prompt user to select Git repository
echo "Select Git repository location to build Malcolm from:"
echo "1. https://github.com/cisagov/Malcolm.git"
echo "2. https://github.com/mmguero-dev/Malcolm"
echo "3. https://github.com/idaholab/Malcolm"
echo "4. Other (Enter custom URL)"

read -p "Enter your choice (1, 2, 3, or Custom URL): " choice

case $choice in
    1)
        REPO_URL="https://github.com/cisagov/Malcolm.git"
        ;;
    2)
        REPO_URL="https://github.com/mmguero-dev/Malcolm"
        ;;
    3)
        REPO_URL="https://github.com/idaholab/Malcolm"
        ;;
    4)
        read -p "Enter custom Git repository URL: " REPO_URL
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

read -p "Enter to Malcolm version tag you want to test (e.g. v24.05.0, v23.12.1, or press ENTER for the latest version) " VERSION

update_playbook "$REPO_URL" "$VERSION"

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

if [ $LIBVIRT = 1 ]; then    
    sudo vagrant up
fi


if [ $VMWARE = 1 ]; then    
    sudo vagrant up
fi

if [ $PARALLELS = 1 ]; then    
    sudo vagrant up
fi

# copy api json files to your host for analysis/verification
# default user is vagrant:vagrant
if [ $VBOX = 1 ]; then
    sudo vagrant up
    sshpass -p "vagrant" scp -P 2222 -r vagrant@localhost:/ApiTesting . && echo "malcolm api json data copied to ApiTesting/"
fi

# commented out for now to make testing faster
# vagrant destroy