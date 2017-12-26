// Custom configuration for Z50-70/Z40-70 laptops

DefinitionBlock ("", "SSDT", 2, "hack", "TBK-Z50", 0)
{
    Device(RMCF)
    {
        Name(_ADR, 0)   // do not remove

        // AUDL: Audio Layout
        //
        // The value here will be used to inject layout-id for HDEF and HDAU
        // If set to Ones, no audio injection will be done.
        Name(AUDL, 3)

        // IGPI: Override for ig-platform-id (or snb-platform-id).
        // Will be used if non-zero, and not Ones
        // Can be set to Ones to disable IGPU injection.
        // For example, if you wanted to inject a bogus id, 0x12345678
        //    Name(IGPI, 0x12345678)
        // Or to disable, IGPU injection from SSDT-IGPU:
        //    Name(IGPI, Ones)
        // Or to set a custom ig-platform-id, example:
        //    Name(IGPI, 0x01660008)
        Name(IGPI, 0x0a2e0008)
            
        // LMAX: Backlight PWM MAX.  Must match framebuffer in use.
        //
        // Ones: Default will be used (0x710 for Ivy/Sandy, 0xad9 for Haswell/Broadwell)
        // Other values: must match framebuffer
        Name(LMAX, 0x56c)
    }
    
    #include "SSDT-PS2K.dsl"
    #include "SSDT-UIAC.dsl"
    #include "SSDT-DGPU.dsl"
    #include "SSDT-XSEL.dsl"
    #include "SSDT-CX20751.dsl"
    #include "SSDT-BATT-Z50.dsl"
}
//EOF