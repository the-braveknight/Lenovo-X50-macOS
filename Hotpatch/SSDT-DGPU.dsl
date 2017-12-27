// For disabling the discrete GPU

//DefinitionBlock ("", "SSDT", 2, "hack", "DGPU", 0)
//{
    // The original If(\ECON) conditional in PEGP._OFF is renamed to If(\EXON)
    // So the code inside it is never executed. Instead, it is executed in the 
    // _REG when EC is ready.
    Name(EXON, 0)
    
    // Assuming PEGP device is at \_SB.PCI0.RP05.PEGP (which is the case
    // for Z50/Z40/G50/G40) laptops.
    Device(DGPU)
    {
        Name(_HID, "DGPU0000")
                
        External(\_SB.PCI0.RP05.PEGP._OFF, MethodObj)
        Method(DGOF) { If(CondRefOf(\_SB.PCI0.RP05.PEGP._OFF)) { \_SB.PCI0.RP05.PEGP._OFF() } } // Call DGPU _OFF (without EC code)
        
        External(\_SB.PCI0.LPCB.EC.GATY, FieldUnitObj)
        Method(ECOF) { If(CondRefOf(\_SB.PCI0.RP05.PEGP._OFF)) { \_SB.PCI0.LPCB.EC.GATY = 0 } } // EC disable code
        
        Method(_INI) { DGOF() }
    }
    
    External(_SB.PCI0.LPCB.EC, DeviceObj)
    Scope(_SB.PCI0.LPCB.EC)
    {
        OperationRegion(ECR3, EmbeddedControl, 0x00, 0xFF)
        
        External(XREG, MethodObj)
        Method (_REG, 2)
        {
            XREG(Arg0, Arg1)
            If(Arg0 == 3 && Arg1 == 1) { \DGPU.ECOF() }
        }
    }
//}
//EOF