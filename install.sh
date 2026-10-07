#!/bin/bash

# Install Git
xcode-select --install

cd /tmp/
git clone https://github.com/emyasa/min-setup

cd min-setup/nvim/
chmod +x install.sh
./install.sh

cd ../tmux/
chmod +x install.sh
./install.sh

cd ../zshrc/
chmod +x install.sh
./install.sh
