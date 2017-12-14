// IGPU injection

DefinitionBlock ("", "SSDT", 2, "hack", "IGPU", 0)
{
    External(_SB.PCI0, DeviceObj)
    Scope(_SB.PCI0)
    {
        External(IGPU, DeviceObj)
        Scope(IGPU)
        {
            // inject properties for integrated graphics on IGPU
            Method(_DSM, 4)
            {
                If (!Arg2) { Return (Buffer() { 0x03 } ) }
                Return(Package()
                {
                    "hda-gfx", Buffer() { "onboard-1" },
                })
            }
        }
    }
}
//EOF