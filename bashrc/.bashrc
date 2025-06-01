[ -f ~/.defaultaliases ] && . ~/.defaultaliases
[ -f ~/.aliases_deb ] && . ~/.aliases_deb
[ -f ~/.aliases_nix ] && . ~/.aliases_nix
[ -f ~/.aliases_deb ] && . ~/.aliases_deb

[ -x $(command -v fzf) ] && eval "$(fzf --bash)"
