// For disabling the discrete GPU

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "hack", "DGPU", 0)
{
#endif

    External(_SB.PCI0.LPCB.EC, DeviceObj)
    Scope(_SB.PCI0.LPCB.EC)
    {
        // The original GATY FieldUnitObj is renamed to GATX, so
        // calls to GATY land here. This prevents crash when called
        // before EC is initialized.
        Name(GATY, 0)
        
        OperationRegion(ECR3, EmbeddedControl, 0x00, 0xFF)
        
        External(XREG, MethodObj)
        External(GATX, FieldUnitObj)
        Method(_REG, 2)
        {
            XREG(Arg0, Arg1)
            
            // Set original GATY (renamed to GATX) to zero.
            GATX = 0
        }
    }
    
    // Assuming PEGP device is at \_SB.PCI0.RP05.PEGP (which is the case
    // for most Lenovo laptops).
    Device(DGPU)
    {
        Name(_HID, "DGPU0000")
        
        External(\_SB.PCI0.RP05.PEGP._OFF, MethodObj)
        Method(_INI)
        {
            If(CondRefOf(\_SB.PCI0.RP05.PEGP._OFF)) { \_SB.PCI0.RP05.PEGP._OFF() }
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF