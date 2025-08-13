[[ -f ~/.local/log ]] || mkdir -p $HOME/.local/log &&  mkdir -p $HOME/.local/bin &&  mkdir -p $HOME/.local/bak
[[ -f ~/.aliases ]] && . ~/.aliases

[[ -f /etc/bashrc ]] && . /etc/bashrc
[[ -e ~/.nix-profile/etc/profile.d/nix.sh ]] && . ~/.nix-profile/etc/profile.d/nix.sh

#set -o vi

[[ -x $(command -v fzf) ]] && eval "$(fzf --bash)"
[[ -x $(command -v fastfetch) ]] && fastfetch
[[ -x $(command -v vim) ]] && export EDITOR='vim' || export EDITOR='vi'
[[ -x $(command -v starship) ]] && eval "$(starship init bash --print-full-init)"

export PATH="~/.local/bin:$PATH"
export PS1="\n\[\e]0;\u@\h: \w\a\]\[\033[;94m\]┌──${debian_chroot:+($debian_chroot)──}${VIRTUAL_ENV:+(\[\033[0;1m\]$(basename $VIRTUAL_ENV)\[\033[;94m\])}(\[\033[1;31m\]\u@\h\[\033[;94m\])-[\[\033[0;1m\]\w\[\033[;94m\]]\n\[\033[;94m\]└─\[\033[1;31m\]\$ \[\033[0m\]"

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
