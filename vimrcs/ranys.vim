let g:notes_path = "~/Documents/Notes"

set clipboard+=unnamed,unnamedplus
set wrap linebreak nolist
set number relativenumber
set autoindent
set cursorline
" set paste  " creates issues with autocomplete
set scrolloff=0

" Space indentation
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab


" j, k Store relative line number jumps in the jumplist.
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'j'

" Yank from remote host into local clipboard
function! OscCopy()
  let encodedText=@"
  let encodedText=substitute(encodedText, '\', '\\\\', "g")
  let encodedText=substitute(encodedText, "'", "'\\\\''", "g")
  let executeCmd="echo -n '".encodedText."' | base64 | tr -d '\\n'"
  let encodedText=system(executeCmd)
  if $TMUX != ""
    "tmux
    let executeCmd='echo -en "\x1bPtmux;\x1b\x1b]52;;'.encodedText.'\x1b\x1b\\\\\x1b\\" > /dev/tty'
  else
    let executeCmd='echo -en "\x1b]52;;'.encodedText.'\x1b\\" > /dev/tty'
  endif
  call system(executeCmd)
  redraw!
endfunction
command! OscCopy :call OscCopy()


" always yank to local system clipboard each yanking
if has('nvim')
  autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | OSCYankReg + | endif
else
  augroup wayland_clipboard
    au!
    au TextYankPost * call OscCopy()
  augroup END
endif

" Gruvbox
autocmd vimenter * colorscheme gruvbox
colorscheme gruvbox
set background=dark    " Setting dark mode

" Search highlight cleanup
nnoremap <esc><esc> :nohls<cr>

" VimDiff word wrap
au VimEnter * if &diff | execute 'windo set wrap' | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" NERDTree sort by timestamp
let s:nerdSortEnabled = 0

function! ToggleSortNERDTreeTimestamp()
    if s:nerdSortEnabled
        let g:NERDTreeSortOrder=['\/$', '*', '\.swp$', '\.bak$', '\~$']
        let s:nerdSortEnabled = 0
        return ":NERDTreeRefreshRoot\<CR>"
    else
        let g:NERDTreeSortOrder=['\/$', '*', '[[-timestamp]]']
        let s:nerdSortEnabled = 1
        return ":NERDTreeRefreshRoot\<CR>"
    endif
endfunction
nnoremap <expr> <leader>ns ToggleSortNERDTreeTimestamp()

try
source ~/.vim_runtime/my_configs.vim
catch
endtry

let g:airline_powerline_fonts = 1

" note taking
function Note()
    let time = strftime("%Y-%m-%d")
    return ":tabnew " . g:notes_path . "/" . time . " "
endfunction
nnoremap <expr> <leader>n Note()

" enable AutoSave on Vim startup
let g:auto_save = 1

" Highlight tabs as errors.
" https://vi.stackexchange.com/a/9353/3168
" match Error /\t/
" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

" spell checking
" set spell

nnoremap <F5> :UndotreeToggle<CR>

" FZF.vim https://github.com/junegunn/fzf/blob/master/README-VIM.md
" TODO add FZF to my vimrc repo
set rtp+=~/.fzf

" make test commands execute using AsyncRun
let test#strategy = "asyncrun"
" AsyncRun (asyncrun) ---------------------------------------------------- {{{ "
let g:asyncrun_open = 20     " --> for the height of the quickfix window "
let g:asyncrun_status = ''   " --> to support integration with vim-airline "
" ------------------------------------------------------------------------ }}} "

" Tests mappings
nnoremap <leader>s :TestNearest<CR>
nnoremap <leader>t :TestFile<CR>

" Git mappings & settings
nnoremap <leader>gl :GV --all<cr>
nnoremap <leader>gs :Git<cr>
set diffopt+=vertical

" Build/ship mappings
nnoremap <leader>bb :AsyncRun brazil-build release<CR>
nnoremap <leader>cr :AsyncRun cr<cr>

" vim-plug auto install
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" vim-plug plugins
call plug#begin()
Plug 'junegunn/fzf.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'vim-test/vim-test'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'puremourning/vimspector'
call plug#end()

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  " Fix VIM bug https://stackoverflow.com/questions/62702766/termguicolors-in-vim-makes-everything-black-and-white
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

  set termguicolors
endif

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
    \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" FZF settings
set rtp+=/usr/local/opt/fzf "path for Brew installed fzf
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'GFiles'
" nnoremap <C-f> :FZF<cr>
nnoremap <leader>g :Rg!<cr>
nnoremap <leader>. :Tags<cr>
nnoremap <leader>p :FZF<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>cc :History:<cr>
let g:fzf_history_dir = '~/.local/share/fzf-history'   " enable fzf history
" Don't show preview window in GitFiles
command! -bang -nargs=? -complete=dir GFiles  call fzf#vim#gitfiles(<q-args>, {'options': ['--layout=reverse', '--info=inline']}, <bang>0)

" paste over visual selction, but don't yank removed text
xnoremap p "_dP

" load current buffer's checkstyle file to quickfix list
nnoremap <leader>cs :%!grep ERROR \| sed "s/\[ERROR\] //" <CR> :cfile %<CR>
