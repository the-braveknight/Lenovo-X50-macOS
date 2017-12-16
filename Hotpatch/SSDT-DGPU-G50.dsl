// For disabling the discrete GPU

//DefinitionBlock("", "SSDT", 2, "hack", "G50-DGPU", 0)
//{   
    External(_SB.PCI0, DeviceObj)
    Scope(_SB.PCI0)
    {
        Device(RMD1)
        {
            Name(_HID, "RMD20000")
            Method(_INI)
            {
               If (CondRefOf(\_SB.PCI0.RP05.PEGP._OFF)) { \_SB.PCI0.RP05.PEGP._OFF() }
            }
        }
        
        External(RP05, DeviceObj)
        Scope(RP05)
        {
            External(LNKD, FieldUnitObj)
            External(LNKS, FieldUnitObj)
            External(PEGP, DeviceObj)
            Scope(PEGP)
            {
                External(\P8XH, MethodObj)
                External(LCTL, FieldUnitObj)
                External(ELCT, IntObj)
                External(VREG, FieldUnitObj)
                External(VGAB, BuffObj)
                External(SVID, FieldUnitObj)
                External(HVID, BuffObj)
                External(SDID, FieldUnitObj)
                External(HDID, BuffObj)
                External(SGPO, MethodObj)
                External(HLRS, FieldUnitObj)
                External(PWEN, FieldUnitObj)
                Method (_OFF, 0, Serialized)
                { 
                    P8XH (Zero, 0xD7, One)
                    Debug = "_SB.PCI0.RP05.PEGP._OFF"
    
                    ELCT = LCTL
                    HVID = SVID
                    HDID = SDID
                    LNKD = One
                    While (LNKS != Zero)
                    {
                        Sleep (One)
                    }
    
                    SGPO (HLRS, One)
                    Sleep (0x02)
                    SGPO (PWEN, Zero)
                    Sleep (0x14)
                    Notify (\_SB.PCI0.RP05, Zero)
                    Return (Zero)
                }
            }
        }
        
        External(LPCB.EC0, DeviceObj)
        Scope(LPCB.EC0)
        {
            OperationRegion(ECR3, EmbeddedControl, 0x00, 0xFF)
            
            External(XREG, MethodObj)
            External(GATY, FieldUnitObj)
            External(\ECON, FieldUnitObj)
            Method (_REG, 2)
            {
                XREG(Arg0, Arg1)
                If(Arg0 == 3 && Arg1 == 1)
                {
                    If(ECON)
                    {
                        GATY = Zero
                    }
                }
            }
        }              
    }
//}
//EOF