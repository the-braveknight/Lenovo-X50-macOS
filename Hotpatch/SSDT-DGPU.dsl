// For disabling the discrete GPU

//DefinitionBlock ("", "SSDT", 2, "hack", "DGPU", 0)
//{
    // The original If(\ECON) conditional in PEGP._OFF is renamed to If(\EXON)
    // So the code inside it is never executed. Instead it is executed in the 
    // _REG when EC is ready.
    Name(EXON, 0)
    
    Device(RMD1)
    {
        Name(_HID, "RMD10000")
        
        External(\_SB.PCI0.RP05.PEGP._OFF, MethodObj)
        Method(_INI)
        {
            If (CondRefOf(\_SB.PCI0.RP05.PEGP._OFF)) { \_SB.PCI0.RP05.PEGP._OFF() }
        }
    }
//}
//EOF