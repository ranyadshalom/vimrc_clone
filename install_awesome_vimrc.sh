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


echo -n "Install coc-vim along with extensions? (for VIM autocompletion)"
read answer
if [ "$answer" != "${answer#[Yy]}"  ] ;then
        ~/.vim_runtime/install_coc_vim.sh
    else
        echo "Skipped coc-vim. Some keymappings set in ranys.vim won't work."
fi

echo -n "Override tmux configuration for the ones in here?"
read answer
if [ "$answer" != "${answer#[Yy]}"  ] ;then
        ln -s ~/.vim_runtime/non_vim_config/.tmux.conf ~/.tmux.conf
    else
        echo "Skipped tmux conf."
fi

echo "Installed the Ultimate Vim "ranys adjusted" configuration successfully! Enjoy :-)"
