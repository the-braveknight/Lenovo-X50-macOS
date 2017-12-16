#!/bin/bash

function downloadTools() {
    echo "Downloading macos-tools..."
    rm -Rf macos-tools && git clone https://github.com/the-braveknight/macos-tools --quiet
}

function downloadRequirements() {
    macos-tools/download.sh settings.plist
}

function installPS2Kext() {
    if [[ "$(macos-tools/trackpad_model.sh)" == *"SYN"* ]]; then
        macos-tools/install_kext.sh $(macos-tools/find_kext.sh VoodooPS2Controller.kext)
    else
        macos-tools/install_kext.sh Kexts/ApplePS2SmartTouchPad.kext
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
    installHDAInjector
    installPS2Kext
    installBacklightInjector

    macos-tools/install_downloads.sh settings.plist
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
        if [[ ! -d macos-tools ]]; then
            echo "macos-tools not downloaded."
            echo "Use --download-tools argument."
            exit 1
        fi
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

