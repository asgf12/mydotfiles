[ -x $(command -v sudo) ] ||  alias sudo=""
[ -f ~/.defaultaliases ] && . ~/.defaultaliases
[ -f ~/.aliases_deb ] && . ~/.aliases_deb
[ -f ~/.aliases_nix ] && . ~/.aliases_nix
[ -f ~/.aliases_alp ] && . ~/.aliases_alp
[ -f ~/.aliases_hat ] && . ~/.aliases_hat

#set -o vi

[[ -e ~/.nix-profile/etc/profile.d/nix.sh ]] && . ~/.nix-profile/etc/profile.d/nix.sh

[[ -x $(command -v "fzf --bash") ]] && eval "$(fzf --bash)"
[[ -x $(command -v fastfetch) ]] && fastfetch
[[ -x $(command -v nvim) ]] && export EDITOR='nvim' || export EDITOR='vim'

export PATH="~/.local/bin:$PATH"

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PS1="\[\e]0;\u@\h: \w\a\]\[\033[;94m\]┌──${debian_chroot:+($debian_chroot)──}${VIRTUAL_ENV:+(\[\033[0;1m\]$(basename $VIRTUAL_ENV)\[\033[;94m\])}(\[\033[1;31m\]\u@\h\[\033[;94m\])-[\[\033[0;1m\]\w\[\033[;94m\]]\n\[\033[;94m\]└─\[\033[1;31m\]\$\[\033[0m\]"
