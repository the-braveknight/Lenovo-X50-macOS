#!/bin/bash

hda_resources=Resources_CX20751

function downloadTools() {
    echo "Downloading macos-tools..."
    rm -Rf macos-tools && git clone https://github.com/the-braveknight/macos-tools --quiet
}

function downloadKexts() {
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
    # Create XML/Layout files injector; PinConfigs are injected with CodecCommander.kext & SSDT-HDEF
    macos-tools/create_xmlinjector.sh $hda_resources
    macos-tools/install_kext.sh AppleHDAInjector.kext
}

function installBacklightInjector() {
    macos-tools/install_kext.sh Kexts/AppleBacklightInjector.kext
}

function installKexts() {
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

function compileACPI() {
    macos-tools/make_acpi.sh Hotpatch
}

function installACPI() {
    macos-tools/install_acpi.sh
}

if [[ ! -d macos-tools ]]; then
    downloadTools
fi

case "$1" in
    --download-tools)
        downloadTools
        ;;
    --download-kexts)
        downloadKexts
        ;;
    --install-kexts)
        installKexts
        ;;
    --install-config)
        installConfig
        ;;
    --update-config)
        updateConfig
        ;;
    --compile-acpi)
        compileACPI
        ;;
    --install-acpi)
        installACPI
        ;;
esac
