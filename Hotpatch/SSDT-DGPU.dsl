// For disabling the discrete GPU

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "hack", "DGPU", 0)
{
#endif
    // The original GATY FieldUnitObj is renamed to GATX, so
    // calls to GATY land here. This prevents crash when called
    // before EC is initialized.
    Name(_SB.PCI0.LPCB.EC.GATY, 0)
    
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