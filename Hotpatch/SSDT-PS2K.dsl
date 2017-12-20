// Keyboard configuration

//DefinitionBlock("", "SSDT", 2, "hack", "PS2K", 0)
//{   
    // Enabling brightness keys
    External(_SB.PCI0.LPCB, DeviceObj)
    Scope(_SB.PCI0.LPCB) // brightness buttons
    {
        External(EC, DeviceObj)
        External(PS2K, DeviceObj)
        Scope(EC)
        {
            Method (_Q11) // Brightness down
            {
                Notify (PS2K, 0x0405) // For VoodooPS2Controller.kext (by RehabMan)
                Notify (PS2K, 0x20) // For ApplePS2SmartTouchPad.kext (by EMlyDinEsH)
            }
        
            Method (_Q12) // Btightness up
            {
                Notify (PS2K, 0x0406) // For VoodooPS2Controller.kext (by RehabMan)
                Notify (PS2K, 0x10) // For ApplePS2SmartTouchPad.kext (by EMlyDinEsH)
            }
        }
    }
//}
//EOF