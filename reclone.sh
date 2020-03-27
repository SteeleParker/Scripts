#!/bin/bash

# Purpose of this script is to remove the scripts and clone them.
# Placeholder script for later performing any string manipulation based on env vars
# Current target directory is ~/scripts

rm -rf ~/scripts
cd ~/
mkdir ~/scripts
git clone https://github.com/SteeleParker/Scripts.git ~/scripts
cd ~/scripts
ls -1 | xargs chmod u+x $1
