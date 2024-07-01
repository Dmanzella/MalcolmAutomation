#!/bin/bash

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

read -p "Enter your choice (1, 2, 3, or 4): " choice

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

# add functionality to leave blank and the version tag in ansible is commented out
read -p "Enter to Malcolm version tag you want to test (e.g. v24.05.0, v23.12.1) " VERSION

update_playbook "$REPO_URL" "$VERSION"
