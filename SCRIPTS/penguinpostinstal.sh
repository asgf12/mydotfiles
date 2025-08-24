#!/usr/bin/env bash

# My options and base config for chromeOS linux container
# runas sudo only
# checked deb 12/13

pkg=(aria2 fd-find fzf git grep gzip man mawk screenfetch podman python3 pipx tmux unzip vim wget xclip curl stow bat 7zip jq btop)
# screenfetch aliased to fastferch later, 2 consider ripgrep & tealdeer (not in repos) maybe docker

apt update && apt upgrade -y && apt install ${pkg[@]}
if [ $? -ne 0 ]; then
	echo 'interrupted';exit 1
fi


name="$(grep 1000 /etc/passwd | cut -d: -f1)"
userhome="/home/$name"
userconf="$userhome/.config"
bak=".local/bak"
bin=".local/bin"
$echosub="echo $name:100000:65536 >> /etc"

apt install tldr
if [ $? -ne 0 ]; then
    su - $name -c "pipx install tldr"
fi

[ -z "$(grep $name /etc/subuid)" ] && $echosub/subuid
[ -z "$(grep $name /etc/subgid)" ] && $echosub/subgid
 
[[ -f $userhome/$bin ]] || mkdir -p $userhome/$bin
ln -s /bin/screenfetch $userhome/$bin/fastfetch

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

[[ -h $userhome/.bashrc ]] || cd $userhome/mydotfiles && stow bashrc podman vim tmux aliases && echo -e 'basic config symlinked\nsourcing not suported\nrestart or\n. $userhome/.bashrc'
