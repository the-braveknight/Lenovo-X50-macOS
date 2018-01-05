#!/bin/bash

if [[ ! -d macos-tools ]]; then
    echo "Downloading latest macos-tools..."
    rm -Rf macos-tools && git clone https://github.com/the-braveknight/macos-tools --quiet
fi

case "$1" in
    --download-tools)
        rm -Rf Downloads/Tools && mkdir Downloads/Tools && macos-tools/bitbucket_download.sh -p Downloads/Tools.plist -o Downloads/Tools
    ;;
    --download-kexts)
        rm -Rf Downloads/Kexts && mkdir Downloads/Kexts && macos-tools/bitbucket_download.sh -p Downloads/Kexts.plist -o Downloads/Kexts
    ;;
    --download-hotpatch)
        rm -Rf Downloads/Hotpatch && mkdir Downloads/Hotpatch && macos-tools/hotpatch_download.sh -p Downloads/Hotpatch.plist -o Downloads/Hotpatch
    ;;
    --unarchive-downloads)
        macos-tools/unarchive_file.sh -d Downloads
    ;;
    --install-apps)
        macos-tools/install_app.sh -d Downloads
    ;;
    --install-binaries)
        macos-tools/install_binary.sh -d Downloads
    ;;
    --install-kexts)
        macos-tools/install_kext.sh -d Downloads -e Kext-Exceptions.plist
    ;;
    --install-hdainjector)
        macos-tools/create_hdainjector.sh -c CX20751 -r Resources_CX20751
        macos-tools/install_kext.sh AppleHDA_CX20751.kext
    ;;
    --install-backlightinjector)
        macos-tools/install_kext.sh Kexts/AppleBacklightInjector.kext
    ;;
    --install-ps2kext)
        if [[ "$(macos-tools/trackpad_model.sh)" == *"SYN"* ]]; then
            macos-tools/install_kext.sh Downloads/Kexts/RehabMan-Voodoo-*/Release/VoodooPS2Controller.kext
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
        $0 --install-backlightinjector
        $0 --install-hdainjector
        $0 --install-ps2kext
        $0 --update-kernelcache
    ;;
esac
