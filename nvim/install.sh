#!/bin/bash

mkdir -p ~/.config/nvim/
cp -r ./config/ ~/.config/nvim/

mkdir -p ~/.local/share/nvim/site/pack/myplugins/start/oil.nvim/
cp -r ./local-share/oil.nvim/ ~/.local/share/nvim/site/pack/myplugins/start/oil.nvim/

mkdir -p ~/.local/bin/
cp ./local-bin/nvim ~/.local/bin/
