#!/bin/bash

mkdir -p ~/.config/nvim/
cp -r ./config/ ~/.config/nvim/

mkdir -p ~/.local/share/nvim/site/pack/myplugins/start/oil.nvim/
cp -r ./local-share/oil.nvim/ ~/.local/share/nvim/site/pack/myplugins/start/oil.nvim/

mkdir -p ~/.local/share/nvim/mason/packages/jdtls/
cp -r ./local-share/java-jdtls/ ~/.local/share/nvim/mason/packages/jdtls/

mkdir -p ~/.local/share/nvim/site/pack/myplugins/nvim-jdtls/
cp -r ./local-share/nvim-jdtls/ ~/.local/share/nvim/site/pack/myplugins/nvim-jdtls/

mkdir -p ~/.local/bin/
cp ./local-bin/nvim ~/.local/bin/
