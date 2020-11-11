#!/bin/sh
set -e

cd ~/.vim_runtime

echo 'set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim
source ~/.vim_runtime/vimrcs/ranys.vim

try
source ~/.vim_runtime/vimrcs/amazon_ranys.vim
catch
endtry

try
source ~/.vim_runtime/my_configs.vim
catch
endtry' > ~/.vimrc


echo -n "Override tmux configuration for the ones in here?"
read answer

if [ "$answer" != "${answer#[Yy]}"  ] ;then
        ln -s ~/.vim_runtime/non_vim_config/.tmux.conf ~/.tmux.conf
    else
        echo "Installed the Ultimate Vim "ranys adjusted" configuration successfully! Enjoy :-)"
fi
