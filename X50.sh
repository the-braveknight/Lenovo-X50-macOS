#!/bin/bash

function downloadTools() {
    echo "Downloading latest macos-tools..."
    rm -Rf macos-tools && git clone https://github.com/the-braveknight/macos-tools --quiet
}

function downloadRequirements() {
    macos-tools/bitbucket_download.sh -p Downloads/Kexts.plist
    macos-tools/bitbucket_download.sh -p Downloads/Tools.plist
    macos-tools/hotpatch_download.sh -p Downloads/Hotpatch.plist
}

function installPS2Kext() {
    if [[ "$(macos-tools/trackpad_model.sh)" == *"SYN"* ]]; then
        macos-tools/install_kext.sh $(macos-tools/find_kext.sh VoodooPS2Controller.kext)
        sudo rm -Rf /Library/Extensions/ApplePS2SmartTouchPad.kext
    else
        macos-tools/install_kext.sh Kexts/ApplePS2SmartTouchPad.kext
        sudo rm -Rf /Library/Extensions/VoodooPS2Controller.kext
    fi
}

function installHDAInjector() {
    macos-tools/create_hdainjector.sh Resources_CX20751
    macos-tools/install_kext.sh AppleHDAInjector.kext
}

function installBacklightInjector() {
    macos-tools/install_kext.sh Kexts/AppleBacklightInjector.kext
}

function installDownloads() {
    macos-tools/install_downloads.sh -e Kext-Exceptions.plist

    installHDAInjector
    installPS2Kext
    installBacklightInjector

    sudo kextcache -i /
}

function installConfig() {
    macos-tools/install_config.sh config.plist
}

function updateConfig() {
    macos-tools/update_config.sh config.plist
}

case "$1" in
    --download-tools)
        downloadTools
    ;;
    *)
    if [[ ! -d macos-tools ]]; then downloadTools; fi
    case "$1" in
        --download-requirements)
            downloadRequirements
        ;;
        --install-downloads)
            installDownloads
        ;;
        --install-config)
            installConfig
        ;;
        --update-config)
            updateConfig
        ;;
    esac
esac
