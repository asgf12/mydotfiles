#!/usr/bin/env bash

# My options and base config for chromeOS linux container
# runas sudo only
# checked deb 12/13

pkg=(aria2 fd-find fzf gcc git grep gzip man mawk screenfetch neovim podman python3 pipx tmux unzip vim wget xclip curl stow bat 7zip jq btop)

apt update && apt upgrade -y && apt install ${pkg[@]}
if [ $? -ne 0 ]; then
	echo 'interrupted';exit 1
fi

pipx install tldr

name="$(grep 1000 /etc/passwd | cut -d: -f1)"
echo $name:100000:65536 >> /etc/subuid
echo $name:100000:65536 >> /etc/subgid
 
[[ -f $HOME/.local/bin ]] || mkdir -p $HOME/.local/bin
ln -s /bin/screenfetch $HOME/.local/bin/fastfetch

[[ -d $HOME/mydotfiles ]] || cd $HOME && git clone http://github.com/asgf12/mydotfiles.git
if [[ -d $HOME/mydotfiles && ! -h $HOME/.bashrc ]]; then
	mkdir -p $HOME/.local/bak
	[[ -f $HOME/.bashrc ]] && mv $HOME/.bashrc $HOME/.local/bak/
	[[ -f $HOME/.bash_profile ]] && mv $HOME/.bash_profie $HOME/.local/bak/
	[[ -f $HOME/.aliases ]] && mv $HOME/.aliases $HOME/.local/bak/
	[[ -f $HOME/.bash_aliases ]] && mv $HOME/.bash_aliases $HOME/.local/bak/
	[[ -d $HOME/.config/tmux ]] && mv $HOME/.config/tmux $HOME/.local/bak/
	[[ -d $HOME/.config/containers ]] && mv $HOME/.config/containers $HOME/.local/bak/
fi

[[ -h $HOME/.bashrc ]] || cd $HOME/mydotfiles && stow bashrc podman tmux aliases && echo -e 'basic config symlinked\nsourcing not suported\nrestart or\n. $HOME/.bashrc'
