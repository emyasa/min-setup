#!/bin/bash

mkdir -p ~/.config/nvim/
cp -r ./config/ ~/.config/nvim/

mkdir -p ~/.local/share/nvim/site/pack/packer/start/
cp -r ./local-share/packer/ ~/.local/share/nvim/site/pack/packer/start/

mkdir -p ~/.local/share/nvim/mason/packages/jdtls/
cp -r ./local-share/java-jdtls/ ~/.local/share/nvim/mason/packages/jdtls/

mkdir -p ~/.local/bin/
cp -r ./local-bin/ ~/.local/bin/
