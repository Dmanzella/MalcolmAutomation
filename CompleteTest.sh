#!/bin/bash

./environment_setup.sh

# I have seen one too many cows
export ANSIBLE_NOCOWS=1

vagrant up

# copy api json files to your host for analysis/verification
# default user is vagrant:vagrant
sshpass -p "vagrant" scp -P 2222 -r vagrant@localhost:/ApiTesting .

# commented out for now to make testing faster
# vagrant destroy