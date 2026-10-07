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

cd /tmp
curl -fsL https://raw.githubusercontent.com/emyasa/wimc/refs/heads/gni/install.sh -o wimc_install.sh
chmod +x wimc_install.sh
./wimc_install.sh
