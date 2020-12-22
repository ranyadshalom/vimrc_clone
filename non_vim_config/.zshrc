alias ag='ag --pager less'

 
function rg {
        command rg -p $argv | less -R;
}
 
function full-path {
  for arg in "${argv[@]}"
  do
    echo `pwd`/`ls $arg`
  done
}
 
# Share history across all panes
setopt inc_append_history
 
#cdh is the cd history command
export FZF_DEFAULT_OPTS="--inline-info --layout=reverse" 

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey '^R' history-incremental-search-backward
bindkey '^f' fzf-history-widget
bindkey '^T' fzf-file-widget

bindkey -e
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word

