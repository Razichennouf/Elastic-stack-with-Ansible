#!/bin/bash

# This script is made to setup and configure ansible to handle and manage windows hosts via winrm
sudo update-ca-certificates
sudo apt update -y && apt upgrade -y
sudo update-ca-certificates
pip install -U ansible
pip install -U pywinrm
