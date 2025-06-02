[ -x $(command -v sudo) ] ||  alias sudo=""
[ -f ~/.defaultaliases ] && . ~/.defaultaliases
[ -f ~/.aliases_deb ] && . ~/.aliases_deb
[ -f ~/.aliases_nix ] && . ~/.aliases_nix
[ -f ~/.aliases_alp ] && . ~/.aliases_alp

[ -x $(command -v fzf) ] && eval "$(fzf --bash)"
[ -x $(command -v fastfetch) ] && fastfetch
[ -x $(command -v nvim) ] && export EDITOR='nvim' || export EDITOR='vim'

