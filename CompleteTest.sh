#!/bin/bash

# I have seen one too many cows
export ANSIBLE_NOCOWS=1

RED='\033[0;31m'

VBOX=0
VMWARE=0
LIBVIRT=0

echo "Who do you want to build your Malcolm VM (must already be installed and configured with setup script)"
echo "1. VirtualBox"
echo "2. VMware"
echo "3. libvirt"
read -p "Enter your choice (1-3): " choice
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
    *)
        echo "Invalid choice. Please enter a valid option."
        exit 1
        ;;
esac

# Bash script to select Git repo and version to update Ansible playbook
update_playbook() {
    local repo_url="$1"
    local version="$2"
    
    # Update playbook.yml with sed
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

# read config file and start handling pcaps to test
if [ ! -f "config.json" ]; then
    echo "Error: config.json not found."
    exit 1
fi

pcaps_to_test=($(jq -r '.pcaps_to_test[]' config.json))

mkdir -p Tests
rm -f Tests/*

for pcap in "${pcaps_to_test[@]}"; do
    if [ -f "Pcaps/$pcap" ]; then
        cp "Pcaps/$pcap" "Tests/"
        echo "Moved $pcap to Tests/ folder"
    else
        echo -e "${RED} Warning: $pcap not found in Pcaps/. skipping"
    fi
done

# List pcap array of current test as specified in config.json
for ingested in "${pcaps_to_test[@]}"; do
    echo "$ingested"
done





if [ $LIBVIRT -eq 1 ]; then    
    sudo vagrant up --provider libvirt
fi

if [ $VMWARE -eq 1 ]; then    
    sudo vagrant up --provider vmware_desktop
fi

if [ $VBOX -eq 1 ]; then
    sudo vagrant up --provider virtualbox
    sshpass -p "vagrant" scp -P 2222 -r vagrant@localhost:/ApiTesting . && echo "malcolm api json data copied to ApiTesting/"
fi

# commented out for now to make testing faster
# vagrant destroy