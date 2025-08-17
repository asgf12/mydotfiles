#!/usr/bin/env bash

# My options and base config for chromeOS linux container
# runas sudo only
# checked deb 12/13

pkg=(aria2 fd-find fzf git grep gzip man mawk screenfetch podman python3 pipx tmux unzip vim wget xclip curl stow bat 7zip jq btop)

apt update && apt upgrade -y && apt install ${pkg[@]}
if [ $? -ne 0 ]; then
	echo 'interrupted';exit 1
fi


name="$(grep 1000 /etc/passwd | cut -d: -f1)"
userhome="/home/$name"

apt install tldr
if [ $? -ne 0 ]; then
    su - $name -c "pipx install tldr"
fi

[ -z "$(grep $name /etc/subuid)" ] && echo $name:100000:65536 >> /etc/subuid
[ -z "$(grep $name /etc/subgid)" ] && echo $name:100000:65536 >> /etc/subgid
 
[[ -f $userhome/.local/bin ]] || mkdir -p $userhome/.local/bin
ln -s /bin/screenfetch $userhome/.local/bin/fastfetch

[[ -d $userhome/mydotfiles ]] || cd $userhome && git clone http://github.com/asgf12/mydotfiles.git
if [[ -d $userhome/mydotfiles && ! -h $userhome/.bashrc ]]; then
	mkdir -p $userhome/.local/bak
	[[ -f $userhome/.bashrc ]] && mv $userhome/.bashrc $userhome/.local/bak/
	[[ -f $userhome/.bash_profile ]] && mv $userhome/.bash_profie $userhome/.local/bak/
	[[ -f $userhome/.aliases ]] && mv $userhome/.aliases $userhome/.local/bak/
	[[ -f $userhome/.bash_aliases ]] && mv $userhome/.bash_aliases $userhome/.local/bak/
	[[ -d $userhome/.config/tmux ]] && mv $userhome/.config/tmux $userhome/.local/bak/
	[[ -d $userhome/.config/containers ]] && mv $userhome/.config/containers $userhome/.local/bak/
fi

[[ -h $userhome/.bashrc ]] || cd $userhome/mydotfiles && stow bashrc podman tmux aliases && echo -e 'basic config symlinked\nsourcing not suported\nrestart or\n. $userhome/.bashrc'
