#!/bin/bash

# ./environment_setup.sh

vagrant up

# copy api json files to your host for analysis/verification
scp -P 2222 -r vagrant@localhost:/ApiTesting .

vagrant destroy