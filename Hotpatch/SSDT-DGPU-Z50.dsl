// For disabling the discrete GPU

DefinitionBlock ("", "SSDT", 2, "hack", "Z50-DGPU", 0)
{
    External(_SB.PCI0, DeviceObj)
    Scope(_SB.PCI0)
    {
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
                External(SGPO, MethodObj)
                External(HLRS, FieldUnitObj)
                External(PWEN, FieldUnitObj)
                Method (_OFF, 0, Serialized)
                { 
                    P8XH (Zero, 0xD6, One)
                    P8XH (One, 0xF0, One)
                    Debug = "_SB.PCI0.RP05.PEGP._OFF"
                    
                    ELCT = LCTL
                    VGAB = VREG
                    LNKD = One
                    While (LNKS != Zero)
                    {
                        Sleep (One)
                    }

                    SGPO (HLRS, One)
                    SGPO (PWEN, Zero)
                    Return (Zero)
                }
            }
        }
    }
    
    Device(RMD1)
    {
        Name(_HID, "RMD10000")
        Method(_INI)
        {
            If (CondRefOf(\_SB.PCI0.RP05.PEGP._OFF)) { \_SB.PCI0.RP05.PEGP._OFF() }
        }
    }
}
//EOF