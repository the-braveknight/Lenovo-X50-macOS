// BIOS overrides

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "hack", "BIOS-Ov", 0)
{
#endif
    // XHCI: XHCI Mode
    // 0: Disabled
    // 1: Enabled
    // 2: Auto
    // 3: Smart Auto
    Name(XHCI, 3)
    
    // MAUL: Manual Mode
    // 0: Disabled
    // 1: Enabled
    Name(MAUL, 0)
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF