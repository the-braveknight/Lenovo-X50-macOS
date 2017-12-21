// SSDT-REG: _REG + PEGP._OFF EC code

//DefinitionBlock ("", "SSDT", 2, "hack", "X50-REG", 0)
//{
    External(_SB.PCI0.LPCB.EC, DeviceObj)
    External(_SB.PCI0.RP05.PEGP._OFF, MethodObj)
    
    Scope(_SB.PCI0.LPCB.EC)
    {
        OperationRegion(ECR3, EmbeddedControl, 0x00, 0xFF)
            
        External(XREG, MethodObj)
        External(GATY, FieldUnitObj)
        Method (_REG, 2)
        {
            XREG(Arg0, Arg1)
            If(Arg0 == 3 && Arg1 == 1)
            {
                If (CondRefOf(\_SB.PCI0.RP05.PEGP._OFF)) { GATY = Zero }
            }
        }
    }
//}
//EOF