#!/bin/bash

mkdir -p ~/.config/nvim/
cp -r ./config/* ~/.config/nvim/

mkdir -p ~/.local/share/nvim/site/pack/myplugins/start/
cp -r ./local-share/oil.nvim/ ~/.local/share/nvim/site/pack/myplugins/start/

mkdir -p ~/.local/bin/
cp ./local-bin/nvim ~/.local/bin/
