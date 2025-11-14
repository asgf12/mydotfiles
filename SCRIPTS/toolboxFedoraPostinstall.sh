#!/usr/bin/env bash

# My options and base config for Fedora toolbox
# Tested on ver 43

name="$(grep 1000 /etc/passwd | cut -d: -f1)"
userhome="/home/$name"
userconf="$userhome/.config"
bak=".local/bak"

# check if dnf is configured
if !(grep -ie "defaultyes=true" /etc/dnf/dnf.conf); then
    echo "defaultyes=true" >> /etc/dnf/dnf.conf
fi

if !(grep -ie "max_parallel_downloads" /etc/dnf/dnf.conf); then
    echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
fi

# packagelist + update&install
pkg=(ripgrep aria2 fd fzf git fastfetch grep gzip tmux unzip vim wget tldr curl stow bat 7zip jq btop)
sudo dnf update -y && sudo dnf install -y ${pkg[@]}
if [ $? -ne 0 ]; then
	echo 'interrupted';exit 1
fi

echo "dotfiles conf, ctrl+c to not continue" && sleep 5
[[ -d $userhome/mydotfiles ]] || cd $userhome && git clone http://github.com/asgf12/mydotfiles.git
if [[ -d $userhome/mydotfiles && ! -h $userhome/.bashrc ]]; then
	mkdir -p $userhome/$bak
	[[ -f $userhome/.bashrc ]] && mv $userhome/.bashrc $userhome/$bak
	[[ -f $userhome/.bash_profile ]] && mv $userhome/.bash_profie $userhome/$bak
	[[ -f $userhome/.aliases ]] && mv $userhome/.aliases $userhome/$bak
	[[ -f $userhome/.bash_aliases ]] && mv $userhome/.bash_aliases $userhome/$bak
	[[ -d $userconf/tmux ]] && mv $userconf/tmux $userhome/$bak
	[[ -d $userconf/containers ]] && mv $userconf/containers $userhome/$bak
fi

[[ -h $userhome/.bashrc ]] || cd $userhome/mydotfiles && stow bashrc podman vim tmux nix && echo -e 'basic config symlinked\nsourcing not suported\nrestart or\n. $userhome/.bashrc'
