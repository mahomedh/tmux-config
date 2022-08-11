#!/bin/bash

# Description: Sets chmod permission for selection
#
# Dependencies: chmod
#
# Version: 1.0.0

selection=${NNN_SEL:-${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.selection}

if [ -s "$selection" ]; then
    targets=()
    while IFS= read -r -d '' i || [ -n "$i" ]; do
        targets+=("$i")
    done <"$selection"

    # set the same permission for all the files
    echo "Enter 3 digit permission to set on all the selected files:"
    read -r ch_perm

    for i in "${targets[@]}"; do
        if [[ -n "${ch_perm}" ]]; then
            printf "Setting permision %s on file: %s\n" "$ch_perm" "$i"
            result=$(chmod "$ch_perm" "$i" 2>&1)
            if [[ -n "${result}" ]]; then
                echo "$result"
                echo "Press enter to continue"
                read -r
            fi
        else
            echo "WARNING: No permission set. Press enter to continue"
        fi

        # Clear selection
        if [ -p "$NNN_PIPE" ]; then
            printf "-" >"$NNN_PIPE"
        fi
    done
else
    echo "ERROR: No files selected. Press enter to continue"
    read -r
fi
