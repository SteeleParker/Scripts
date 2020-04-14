#!/bin/bash

# permissions
if [ "$(whoami)" != "root" ]; then
	echo "Root privileges are required to run this, try running with sudo..."
	exit 2
fi

# Directories
mkdir -p ~/.ssh
cd ~/.ssh
cat /dev/zero | ssh-keygen -m pem -f ~/.ssh/deploy_key -N ""
