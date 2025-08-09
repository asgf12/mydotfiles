#!/usr/bin/env bash

# My options and base config for chromeOS linux container
# runas sudo only

pkg=(fd-find fzf gcc git grep gzip man-db mawk nvim podman python3 tldr tmux unzip vim wget xclip curl stow bat zgrep 7z diff dd zcat jq btop)
apt update && apt upgrade -y && apt install ${pkg[@]}
if [ $? -ne 0 ]; then
	echo 'interrupted';exit 1
fi
