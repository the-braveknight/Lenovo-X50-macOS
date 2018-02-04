#!/bin/bash

downloads=Downloads

essential_kexts=Essential-Kexts.txt

local_kexts_dir=Kexts

kexts_dir=$downloads/Kexts
kexts_downloads=$downloads/Kexts.txt
kexts_exceptions=Kexts-Exceptions.txt

tools_dir=$downloads/Tools
tools_downloads=$downloads/Tools.txt

hotpatch_dir=$downloads/Hotpatch
hotpatch_downloads=$downloads/Hotpatch.txt

hda_codec=CX20751
hda_resources=Resources_CX20751

ps2_trackpad=$(ioreg -n PS2M -arxw0 > /tmp/ps2_trackpad.plist && /usr/libexec/PlistBuddy -c "Print :0:name" /tmp/ps2_trackpad.plist)

if [[ ! -d macos-tools ]]; then
    echo "Downloading latest macos-tools..."
    rm -Rf macos-tools && git clone https://github.com/the-braveknight/macos-tools --quiet
fi

function findKext() {
    find $kexts_dir $local_kexts_dir -name $1 -not -path \*/PlugIns/* -not -path \*/Debug/*
}

case "$1" in
    --download-tools)
        rm -Rf $tools_dir && mkdir $tools_dir
        while read tool; do macos-tools/bitbucket_download.sh -a RehabMan -n "$tool" -o $tools_dir; done < $tools_downloads
    ;;
    --download-kexts)
        rm -Rf $kexts_dir && mkdir $kexts_dir
        while read kext; do macos-tools/bitbucket_download.sh -a RehabMan -n "$kext" -o $kexts_dir; done < $kexts_downloads
    ;;
    --download-hotpatch)
        rm -Rf $hotpatch_dir && mkdir $hotpatch_dir
        while read ssdt; do macos-tools/hotpatch_download.sh -o $hotpatch_dir "$ssdt"; done < $hotpatch_downloads
    ;;
    --unarchive-downloads)
        macos-tools/unarchive_file.sh -d $downloads
    ;;
    --install-apps)
        macos-tools/install_app.sh -d $downloads
    ;;
    --install-binaries)
        macos-tools/install_binary.sh -d $downloads
    ;;
    --install-kexts)
        macos-tools/install_kext.sh -d $downloads -e $(cat $kexts_exceptions)
        $0 --install-hdainjector
        $0 --install-backlightinjector
        $0 --install-ps2kext
    ;;
    --install-essential-kexts)
        macos-tools/install_kext.sh -i $(for kext in $(cat $essential_kexts); do findKext $kext; done)
    ;;
    --install-hdainjector)
        macos-tools/create_hdainjector.sh -c $hda_codec -r $hda_resources
        macos-tools/install_kext.sh AppleHDA_$hda_codec.kext
    ;;
    --install-backlightinjector)
        macos-tools/install_kext.sh Kexts/AppleBacklightInjector.kext
    ;;
    --install-ps2kext)
        if [[ "$ps2_trackpad" == *"SYN"* ]]; then
            macos-tools/install_kext.sh $kexts_dir/RehabMan-Voodoo-*/Release/VoodooPS2Controller.kext
            sudo rm -Rf /Library/Extensions/ApplePS2SmartTouchPad.kext
        else
            macos-tools/install_kext.sh Kexts/ApplePS2SmartTouchPad.kext
            sudo rm -Rf /Library/Extensions/VoodooPS2Controller.kext
        fi
    ;;
    --update-kernelcache)
        sudo kextcache -i /
    ;;
    --install-config)
        macos-tools/install_config.sh config.plist
    ;;
    --update-config)
        macos-tools/install_config.sh -u config.plist
    ;;
    --download-requirements)
        $0 --download-kexts
        $0 --download-tools
        $0 --download-hotpatch
    ;;
    --install-downloads)
        $0 --unarchive-downloads
        $0 --install-binaries
        $0 --install-apps
        $0 --install-kexts
        $0 --install-essential-kexts
        $0 --update-kernelcache
    ;;
esac
