#!/bin/bash

mkdir -p ~/.local/bin/
cp -r ./local-bin/ ~/.local/bin/

mkdir -p ~/.local/nvim/
cp -r ./standalone/ ~/.local/nvim/
ln -s ~/.local/nvim/bin/nvim ~/.local/bin/nvim

mkdir -p ~/.config/nvim/
cp -r ./config/ ~/.config/nvim/

mkdir -p ~/.local/share/nvim/site/pack/packer/start/
cp -r ./local-share/packer/ ~/.local/share/nvim/site/pack/packer/start/

mkdir -p ~/.local/share/nvim/mason/packages/jdtls/
cp -r ./local-share/java-jdtls/ ~/.local/share/nvim/mason/packages/jdtls/
