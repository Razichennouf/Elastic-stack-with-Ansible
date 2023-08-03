#!/bin/bash

# This script is made to setup and configure ansible to handle and manage windows hosts via winrm
sudo update-ca-certificates
sudo apt update -y && apt upgrade -y
sudo apt install python3.11
pip3 install -U ansible
ansible-galaxy collection install ansible.windows
pip3 install -U pywinrm
