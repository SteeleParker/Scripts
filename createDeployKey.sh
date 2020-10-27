#!/bin/bash

# permissions - This should be run as the user that will be deploying
#if [ "$(whoami)" != "root" ]; then
#	echo "Root privileges are required to run this, try running with sudo..."
#	exit 2
#fi

# Directories
cd ~/.ssh
cat /dev/zero | ssh-keygen -m pem -f ~/.ssh/deploy_key -N ""

echo "
Host bitbucket.org
    IdentityFile ~/.ssh/deploy_key" >> ~/.ssh/config
    
cat deploy_key.pub >> ~/.ssh/authorized_keys 

chmod 600 ~/.ssh/config
