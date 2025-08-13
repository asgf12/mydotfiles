#!/usr/bin/env bash

# My options and base config for chromeOS linux container
# runas sudo only

pkg=(fd-find fzf gcc git grep gzip man mawk neovim podman python3 tldr tmux unzip vim wget xclip curl stow bat 7zip jq btop)
apt update && apt upgrade -y && apt install ${pkg[@]}
if [ $? -ne 0 ]; then
	echo 'interrupted';exit 1
fi

name="$(grep 1000 /etc/passwd | cut -d: -f1)"
echo $name:100000:65536 >> /etc/subuid
echo $name:100000:65536 >> /etc/subgid
