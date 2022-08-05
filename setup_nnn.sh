#!/bin/bash

# check ubuntu version
release_ver="$(lsb_release -rs)"

# add the relevant repo
if [[ $(echo "$release_ver >= 22.04" | bc) == 1 ]]; then
    echo 'deb http://download.opensuse.org/repositories/home:/stig124:/nnn/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/nnn.list
    curl -fsSL https://download.opensuse.org/repositories/home:stig124:nnn/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_stig124_nnn.gpg >/dev/null
elif [[ $(echo "$release_ver >= 20.04 && $release_ver < 22.04" | bc) == 1 ]]; then
    echo 'deb http://download.opensuse.org/repositories/home:/stig124:/nnn/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/nnn.list
    curl -fsSL https://download.opensuse.org/repositories/home:stig124:nnn/xUbuntu_20.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_stig124_nnn.gpg >/dev/null
elif [[ $(echo "$release_ver >= 18.04 && $release_ver < 20.04" | bc) == 1 ]]; then
    echo 'deb http://download.opensuse.org/repositories/home:/stig124:/nnn/xUbuntu_18.04/ /' | sudo tee /etc/apt/sources.list.d/nnn.list
    curl -fsSL https://download.opensuse.org/repositories/home:stig124:nnn/xUbuntu_18.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_stig124_nnn.gpg >/dev/null
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
    printf "\n"
    printf "export EDITOR='%s'\n" "$nano_loc"
    printf "export NNN_OPENER='%s'\n" "$nano_loc"
    printf "export NNN_PLUG='l:!less \$nnn*'\n"

} >>~/.bashrc

# Add the script to enable 'cd on quit'
cat >>~/.bashrc <<-"NSCRIPT"
n() {
    # Original script from https://github.com/jarun/nnn/blob/master/misc/quitcd/quitcd.bash_zsh

    # Block nesting of nnn in subshells
    if [[ "${NNNLVL:-0}" -ge 1 ]]; then
        echo "nnn is already running"
        return
    fi

    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # The backslash allows one to alias n to nnn if desired without making an
    # infinitely recursive alias
    \nnn -dHUcn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
            ls -lhA
    fi

    unset NNN_TMPFILE

}
NSCRIPT

echo "Either run 'source ~/.bashrc' or exit the shell and log back in for changes to take effect"
