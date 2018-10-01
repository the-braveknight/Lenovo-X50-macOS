#!/bin/bash

repo_dir=$(dirname ${BASH_SOURCE[0]})

macos_tools=$repo_dir/macos-tools

if [[ ! -d $macos_tools ]]; then
    echo "Downloading latest macos-tools..."
    rm -Rf $macos_tools && git clone https://github.com/the-braveknight/macos-tools $macos_tools --quiet
fi

downloads_dir=$repo_dir/Downloads
local_kexts_dir=$repo_dir/Kexts
hotpatch_dir=$repo_dir/Hotpatch/Downloads
repo_plist=$repo_dir/org.the-braveknight.x50.plist

source $macos_tools/_hack_cmds.sh

case "$1" in
    --install-config)
        installConfig $repo_dir/config.plist
    ;;
    --update-config)
        updateConfig $repo_dir/config.plist
    ;;
esac
