#!/bin/bash

# sets up your environment to spin up Malcolm VM using Vagrant, Ansible, and Virtualbox
# not tested and probably is missing something

sudo apt-get update && sudo apt install vagrant virtualbox pipx

pipx install --include-deps ansible
