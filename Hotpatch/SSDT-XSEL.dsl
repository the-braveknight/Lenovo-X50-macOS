// USB custom XSEL, required for disabling EHCI

//DefinitionBlock ("", "SSDT", 2, "hack", "XSEL", 0)
//{
    // Disabling EHCI #1
    External(_SB.PCI0.XHC, DeviceObj)
    Scope(_SB.PCI0.XHC)
    {       
        External(\_SB.XUSB, FieldUnitObj)
        External(XRST, IntObj)
        External(PR3, FieldUnitObj)
        External(PR3M, FieldUnitObj)
        External(PR2, FieldUnitObj)
        External(PR2M, FieldUnitObj)
        Method(XSEL)
        {
            // This code is based on original XSEL, but without all the conditionals
            // With this code, USB works correctly even in 10.10 after booting Windows
            // setup to route all USB2 on XHCI to XHCI (not EHCI, which is disabled)
            XUSB = 1
            XRST = 1
            Or(And (PR3, 0xFFFFFFC0), PR3M, PR3)
            Or(And (PR2, 0xFFFF8000), PR2M, PR2)
        }
    }
//}
//EOF
