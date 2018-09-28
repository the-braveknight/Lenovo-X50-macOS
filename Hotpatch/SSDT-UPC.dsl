// USB _UPC configuration for Lenovo Z50-70/G50-70/etc

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "hack", "_UPC", 0)
{
#endif

    External(_SB.PCI0.XHC.RHUB, DeviceObj)
    Scope(_SB.PCI0.XHC.RHUB)
    {        
        Name(UPC2, Package() // USB2
        {
            0xFF, 0, 0, 0
        })
        
        Name(UPC3, Package() // USB3
        {
            0xFF, 3, 0, 0
        })
        
        Name(UPCP, Package() // Internal (built-in)
        {
            0xFF, 0xFF, 0, 0
        })
        
        Method(HS01._UPC)
        {
            Return(UPC2)
        }
        
        Method(HS02._UPC)
        {
            Return(UPC3)
        }
        
        Method(HS03._UPC)
        {
            Return(UPC2)
        }

        Method(HS06._UPC)
        {
            Return(UPCP)
        }
        
        Method(HS07._UPC)
        {
            Return(UPCP)
        }
        
        Method(SSP1._UPC)
        {
            Return(UPC3)
        }
    }
    
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF