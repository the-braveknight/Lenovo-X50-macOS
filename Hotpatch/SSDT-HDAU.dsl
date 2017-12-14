// HDAU (HDMI Audio) injection

DefinitionBlock("", "SSDT", 2, "hack", "HDAU", 0)
{
    
    External(_SB.PCI0, DeviceObj)
    Scope(_SB.PCI0)
    {
        External(HDAU, DeviceObj)
        Scope(HDAU)
        {
            Method(_DSM, 4)
            {
                If (!Arg2) { Return (Buffer() { 0x03 } ) }
                Return(Package()
                {
                    "layout-id", Buffer() { 3, 0, 0, 0 },
                    "hda-gfx", Buffer() { "onboard-1" },
                })
            }
        }
    }
}
//EOF