// Custom configuration for G50-70/Z40-70 laptops

DefinitionBlock ("", "SSDT", 2, "hack", "TBK-G50", 0)
{
    Device(RMCF)
    {
        Name(_ADR, 0)   // do not remove

        // AUDL: Audio Layout
        //
        // The value here will be used to inject layout-id for HDEF and HDAU
        // If set to Ones, no audio injection will be done.
        Name(AUDL, 3)
    }
    
    #include "SSDT-PS2K.dsl"
    #include "SSDT-UIAC.dsl"
    #include "SSDT-XSEL.dsl"
    #include "SSDT-CX20751.dsl"
    #include "SSDT-DGPU-G50.dsl"
    #include "SSDT-BATT-G50.dsl"
}
//EOF