set clipboard=unnamed
set wrap linebreak nolist
set number relativenumber
set autoindent
set paste
set expandtab
set scrolloff=0


" Gruvbox
autocmd vimenter * colorscheme gruvbox
colorscheme gruvbox
" color ir_black
" color solarized
" color pyte

nnoremap <esc><esc> :nohls<cr>

" VimDiff word wrap
au VimEnter * if &diff | execute 'windo set wrap' | endif

try
source ~/.vim_runtime/my_configs.vim
catch
endtry

let g:airline_powerline_fonts = 1

" CtrlP Plugin - http://ctrlpvim.github.io/ctrlp.vim/
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

