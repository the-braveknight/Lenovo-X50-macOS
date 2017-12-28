// BIOS overrides

//DefinitionBlock ("", "SSDT", 2, "hack", "BIOS-Ov", 0)
//{
    // XHCM: XHCI Mode
    // 0: Disabled
    // 1: Enabled
    // 2: Auto
    // 3: Smart Auto
    Name(XHCM, 3)
    
    // MNUL: Manual Mode
    // 0: Disabled
    // 1: Enabled
    Name(MNUL, 0)
//}
//EOF