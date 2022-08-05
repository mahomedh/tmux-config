#!/bin/bash

# check ubuntu version
release_ver="$(lsb_release -rs)"

# add the relevant repo
if [[ $(echo "$release_ver >= 22.04" | bc) == 1 ]]; then
    echo 'deb http://download.opensuse.org/repositories/home:/stig124:/nnn/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/nnn.list
    curl -fsSL https://download.opensuse.org/repositories/nnn/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_stig124_nnn.gpg >/dev/null
elif [[ $(echo "$release_ver >= 20.04 && $release_ver < 22.04" | bc) == 1 ]]; then
    echo 'deb http://download.opensuse.org/repositories/home:/stig124:/nnn/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/nnn.list
    curl -fsSL https://download.opensuse.org/repositories/nnn/xUbuntu_20.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_stig124_nnn.gpg >/dev/null
elif [[ $(echo "$release_ver >= 18.04 && $release_ver < 20.04" | bc) == 1 ]]; then
    echo 'deb http://download.opensuse.org/repositories/home:/stig124:/nnn/xUbuntu_18.04/ /' | sudo tee /etc/apt/sources.list.d/nnn.list
    curl -fsSL https://download.opensuse.org/repositories/nnn/xUbuntu_18.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_stig124_nnn.gpg >/dev/null
else
    echo "The output of 'lsb_release -r' is not recognised. Please check."
    exit 2
fi

# install
apt update
apt install nnn -y

# get the nano location using which
nano_loc="$(command -v nano)"

if [[ -z "$nano_loc" ]]; then
    echo "Can't find nano"
    exit 3
fi

{
    # add the env vars to .bashrc
    echo EDITOR="$nano_loc"
    echo NNN_OPENER="$nano_loc"

    # add the alias to .bashrc
    echo alias n='nnn -dHUcn'
} >>~/.bashrc

# shellcheck source=/dev/null
source ~/.bashrc
