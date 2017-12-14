// For solving instant wake by hooking GPRW
// With the current setup, no instant wake issues appear to exist
// This SSDT is used to disable wake on USB which can be annoying on laptops

DefinitionBlock("", "SSDT", 2, "hack", "GPRW", 0)
{
    External(XPRW, MethodObj)

    // In DSDT, native GPRW is renamed to XPRW with Clover binpatch.
    // As a result, calls to GPRW land here.
    // The purpose of this implementation is to avoid "instant wake"
    // by returning 0 in the second position (sleep state supported)
    // of the return package.
    Method(GPRW, 2)
    {
        If (0x6d == Arg0) { Return (Package() { 0x6d, 0, }) }
        Return (XPRW(Arg0, Arg1))
    }
}
//EOF
