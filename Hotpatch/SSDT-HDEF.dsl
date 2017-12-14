// HDEF injection

DefinitionBlock("", "SSDT", 2, "hack", "HDEF", 0)
{
    // inject properties for audio
    External(_SB.PCI0, DeviceObj)
    Scope(_SB.PCI0)
    {
        External(HDEF, DeviceObj)
        Scope(HDEF)
        {
            Method(_DSM, 4)
            {
                If (!Arg2) { Return (Buffer() { 0x03 } ) }
                Return(Package()
                {
                    "layout-id", Buffer() { 3, 0, 0, 0 },
                    "PinConfigurations", Buffer() { },
                })
            }
            
            // CodecCommander.kext customizations
            // created by nayeweiyang/XuWang
            Name(RMCF, Package()
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
                "CodecCommanderProbeInit", Package()
                {
                    "Version", 0x020600,
                    "14f1_510f", Package()
                    {
                        "PinConfigDefault", Package()
                        {
                            Package(){},
                            Package()
                            {
                                "LayoutID", 3,
                                "PinConfigs", Package()
                                {
                                    Package(){},
                                    0x16, 0x04211040,
                                    0x17, 0x90170110,
                                    0x19, 0x04811030,
                                    0x1a, 0x90a00120,
                                }
                            }
                        }
                    }
                }
            })
        }
    }
}
//EOF
