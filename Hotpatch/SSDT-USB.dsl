// USB configuration for Lenovo Z50-70/Z40-70 laptops

DefinitionBlock ("", "SSDT", 2, "hack", "USB", 0)
{
    // Disabling EHCI #1
    External(_SB.PCI0, DeviceObj)

    Scope(_SB.PCI0)
    {
        // registers needed for disabling EHC#1
        External(EHC1, DeviceObj)
        Scope(EHC1)
        {
            OperationRegion(RMP1, PCI_Config, 0x54, 2)
            Field(RMP1, WordAcc, NoLock, Preserve)
            {
                PSTE, 2  // bits 2:0 are power state
            }
        }
        
        External(XHC, DeviceObj)
        Scope(XHC)
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
            
            // Injecting XHC properties
            Method(_DSM, 4) 
            {
                If (!Arg2) { Return (Buffer() { 0x03 } ) }
                Return(Package()
                {
                    "RM,pr2-force", Buffer() { 0xff, 0x3f, 0, 0 },
                    "subsystem-id", Buffer() { 0x70, 0x72, 0x00, 0x00 },
                    "subsystem-vendor-id", Buffer() { 0x86, 0x80, 0x00, 0x00 },
                    "AAPL,current-available", Buffer() { 0x34, 0x08, 0, 0 },
                    "AAPL,current-extra", Buffer() { 0x98, 0x08, 0, 0, },
                    "AAPL,current-extra-in-sleep", Buffer() { 0x40, 0x06, 0, 0, },
                    "AAPL,max-port-current-in-sleep", Buffer() { 0x34, 0x08, 0, 0 },
                })
            }
        }
        
        // registers needed for disabling EHC#1
        External(LPCB, DeviceObj)
        Scope(LPCB)
        {
            OperationRegion(RMP1, PCI_Config, 0xF0, 4)
            Field(RMP1, DWordAcc, NoLock, Preserve)
            {
                RCB1, 32, // Root Complex Base Address
            }
            // address is in bits 31:14
            OperationRegion(FDM1, SystemMemory, (RCB1 & Not((1<<14)-1)) + 0x3418, 4)
            Field(FDM1, DWordAcc, NoLock, Preserve)
            {
                ,15,
                FDE1,1, // should be bit 15 (0-based) (FD EHCI#1)
            }
        }
        
        Device(RMD1)
        {
            //Name(_ADR, 0)
            Name(_HID, "RMD10000")
            Method(_INI)
            {
                // disable EHCI#1
                // put EHCI#1 in D3hot (sleep mode)
                ^^EHC1.PSTE = 3
                // disable EHCI#1 PCI space
                ^^LPCB.FDE1 = 1
            }
        }
    }
}
//EOF
