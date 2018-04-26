// CodecCommander.kext configuration to fix external mic issues

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 1, "hack", "CX20751/2", 0)
{
#endif
    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        "CodecCommander", Package()
        {
            "Custom Commands", Package()
            {
                Package(){}, // signifies Array instead of Dictionary
                Package()
                {
                    // 0x19 SET_PIN_WIDGET_CONTROL 0x24
                    "Command", Buffer() { 0x01, 0x97, 0x07, 0x24 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
            },
            "Perform Reset", ">n",
            "Perform Reset on External Wake", ">n",
        },
    })
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF