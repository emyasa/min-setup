#!/bin/bash

mkdir -p ~/.config/nvim/
cp -r ./config/ ~/.config/nvim/

mkdir -p ~/.local/share/nvim/site/pack/myplugins/start/
cp ./local-share/oil.nvim/ ~/.local/share/nvim/site/pack/myplugins/start/

cp ./local-bin/nvim ~/.local/bin/
