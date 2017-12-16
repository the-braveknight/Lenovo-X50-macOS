// Battery patches
//
//DefinitionBlock ("", "SSDT", 2, "hack", "G50-BAT", 0)
//{
    External(P80H, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(ECON, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.BAT0.PBIF, PkgObj)
    External(_SB.PCI0.LPCB.EC0.BAT0.PBST, PkgObj)
    External(_SB.PCI0.LPCB.EC0.BAT0.OBST, IntObj)
    External(_SB.PCI0.LPCB.EC0.BAT0.OBAC, IntObj)
    External(_SB.PCI0.LPCB.EC0.BAT0.OBPR, IntObj)
    External(_SB.PCI0.LPCB.EC0.BAT0.OBRC, IntObj)
    External(_SB.PCI0.LPCB.EC0.BAT0.OBPV, IntObj)
    External(_SB.PCI0.LPCB.EC0.B1ST, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.SMPR, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.SMST, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.SMAD, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.BCNT, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.SMCM, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.CMFP, PkgObj)
    External(_SB.PCI0.LPCB.EC0.CFMX, MutexObj)
    External(_SB.PCI0.LPCB.EC0.FUSL, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.FUSH, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.B1CT, FieldUnitObj)
    External(SMID, FieldUnitObj)
    External(SFNO, FieldUnitObj)
    External(BFDT, FieldUnitObj)
    External(SMIC, FieldUnitObj)
    External(CAVR, FieldUnitObj)
    External(STDT, FieldUnitObj)
    
    Scope (_SB.PCI0.LPCB.EC0)
    {      
        Method (BAT0._BST, 0, Serialized)  // _BST: Battery Status
        {
            Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
            If (LEqual (ECON, One))
            {
                Sleep (0x10)
                Store (B1ST, Local0)
                Store (DerefOf (Index (PBST, Zero)), Local1)
                While (One)
                {
                    Store (And (Local0, 0x07), _T_0)
                    If (LEqual (_T_0, Zero))
                    {
                        Store (And (Local1, 0xF8), OBST)
                    }
                    Else
                    {
                        If (LEqual (_T_0, One))
                        {
                            Store (Or (One, And (Local1, 0xF8)), OBST)
                        }
                        Else
                        {
                            If (LEqual (_T_0, 0x02))
                            {
                                Store (Or (0x02, And (Local1, 0xF8)), OBST)
                            }
                            Else
                            {
                                If (LEqual (_T_0, 0x04))
                                {
                                    Store (Or (0x04, And (Local1, 0xF8)), OBST)
                                }
                            }
                        }
                    }

                    Break
                }

                Sleep (0x10)
                Store (B1B2 (AC00 ,AC01), OBAC)
                If (And (OBST, One))
                {
                    Store (And (Not (OBAC), 0x7FFF), OBAC)
                }

                Store (OBAC, OBPR)
                Sleep (0x10)
                Store (B1B2 (RC00, RC01), OBRC)
                Sleep (0x10)
                Store (B1B2 (FV00, FV01), OBPV)
                Multiply (OBRC, 0x0A, OBRC)
                Store (Divide (Multiply (OBAC, OBPV), 0x03E8, ), OBPR)
                Store (OBST, Index (PBST, Zero))
                Store (OBPR, Index (PBST, One))
                Store (OBRC, Index (PBST, 0x02))
                Store (OBPV, Index (PBST, 0x03))
            }

            Return (PBST)
        }

        Method (BAT0._BIF, 0, NotSerialized)  // _BIF: Battery Information
        {
            If (LEqual (ECON, One))
            {
                Store (B1B2 (DC00, DC01), Local0)
                Multiply (Local0, 0x0A, Local0)
                Store (Local0, Index (PBIF, One))
                Store (B1B2 (FC00, FC01), Local0)
                Multiply (Local0, 0x0A, Local0)
                Store (Local0, Index (PBIF, 0x02))
                Store (B1B2 (DV00, DV01), Index (PBIF, 0x04))
                Store ("", Index (PBIF, 0x09))
                Store ("", Index (PBIF, 0x0B))
            }

            Return (PBIF)
        }
        
        Method (RE1B, 1, NotSerialized)
        {
            OperationRegion (ERM2, EmbeddedControl, Arg0, 1)
            Field (ERM2, ByteAcc, NoLock, Preserve) { BYTE, 8 }
            Return (BYTE)
        }
        Method (RECB, 2, Serialized)
        // Arg0 - offset in bytes from zero-based EC
        // Arg1 - size of buffer in bits
        {
            ShiftRight(Arg1, 3, Arg1)
            Name (TEMP, Buffer(Arg1) { })
            Add(Arg0, Arg1, Arg1)
            Store (0, Local0)
            While (LLess(Arg0, Arg1))
            {
                Store (RE1B(Arg0), Index(TEMP, Local0))
                Increment (Arg0)
                Increment (Local0)
            }
            Return (TEMP)
        }
        
        OperationRegion (ERM2, EmbeddedControl, Zero, 0xFF)
        Field (ERM2, ByteAcc, Lock, Preserve)
        {
            Offset (0xC2),
            RC00, 8, RC01, 8,
            Offset (0xC6),
            FV00, 8, FV01, 8, 
            DV00, 8, DV01, 8, 
            DC00, 8, DC01, 8, 
            FC00, 8, FC01, 8,
            Offset (0xD2),
            AC00, 8, AC01, 8,
        }   
        
        Method (WE1B, 2, NotSerialized)
        {
            OperationRegion (ERM2, EmbeddedControl, Arg0, 1)
            Field (ERM2, ByteAcc, NoLock, Preserve) { BYTE, 8 }
            Store (Arg1, BYTE)
        }
        Method (WECB, 3, Serialized)
        // Arg0 - offset in bytes from zero-based EC
        // Arg1 - size of buffer in bits
        // Arg2 - value to write
        {
            ShiftRight(Arg1, 3, Arg1)
            Name (TEMP, Buffer(Arg1) { })
            Store (Arg2, TEMP)
            Add(Arg0, Arg1, Arg1)
            Store (0, Local0)
            While (LLess(Arg0, Arg1))
            {
                WE1B(Arg0, DerefOf(Index(TEMP, Local0)))
                Increment (Arg0)
                Increment (Local0)
            }
        }
        Method (VPC0.MHPF, 1, NotSerialized)
        {
            Name (BFWB, Buffer (0x25) {})
            CreateByteField (BFWB, Zero, FB0)
            CreateByteField (BFWB, One, FB1)
            CreateByteField (BFWB, 0x02, FB2)
            CreateByteField (BFWB, 0x03, FB3)
            CreateField (BFWB, 0x20, 0x0100, FB4)
            CreateByteField (BFWB, 0x24, FB5)
            If (LLessEqual (SizeOf (Arg0), 0x25))
            {
                If (LNotEqual (SMPR, Zero))
                {
                    Store (SMST, FB1)
                }
                Else
                {
                    Store (Arg0, BFWB)
                    Store (FB2, SMAD)
                    Store (FB3, SMCM)
                    Store (FB5, BCNT)
                    Store (FB0, Local0)
                    If (LEqual (And (Local0, One), Zero))
                    {
                        WECB (0x64, 0x0100, FB4)
                    }

                    Store (Zero, SMST)
                    Store (FB0, SMPR)
                    Store (0x03E8, Local1)
                    While (Local1)
                    {
                        Sleep (One)
                        Decrement (Local1)
                        If (LOr (LAnd (SMST, 0x80), LEqual (SMPR, Zero)))
                        {
                            Break
                        }
                    }

                    Store (FB0, Local0)
                    If (LNotEqual (And (Local0, One), Zero))
                    {
                        Store (RECB (0x64, 0x0100), FB4)
                    }

                    Store (SMST, FB1)
                    If (LOr (LEqual (Local1, Zero), LNot (LAnd (SMST, 0x80))))
                    {
                        Store (Zero, SMPR)
                        Store (0x92, FB1)
                    }
                }

                Return (BFWB)
            }
        }

        Method (VPC0.MHIF, 1, NotSerialized)
        {
            Store (0x50, P80H)
            If (LEqual (Arg0, Zero))
            {
                Name (RETB, Buffer (0x0A) {})
                Name (BUF1, Buffer (0x08) {})
                Store (RECB (0x14, 0x40), BUF1)
                CreateByteField (BUF1, Zero, FW0)
                CreateByteField (BUF1, One, FW1)
                CreateByteField (BUF1, 0x02, FW2)
                CreateByteField (BUF1, 0x03, FW3)
                CreateByteField (BUF1, 0x04, FW4)
                CreateByteField (BUF1, 0x05, FW5)
                CreateByteField (BUF1, 0x06, FW6)
                CreateByteField (BUF1, 0x07, FW7)
                Store (FUSL, Index (RETB, Zero))
                Store (FUSH, Index (RETB, One))
                Store (FW0, Index (RETB, 0x02))
                Store (FW1, Index (RETB, 0x03))
                Store (FW2, Index (RETB, 0x04))
                Store (FW3, Index (RETB, 0x05))
                Store (FW4, Index (RETB, 0x06))
                Store (FW5, Index (RETB, 0x07))
                Store (FW6, Index (RETB, 0x08))
                Store (FW7, Index (RETB, 0x09))
                Return (RETB)
            }
        }
        
        Method (VPC0.GBID, 0, Serialized)
        {
            Name (GBUF, Package (0x04)
            {
                Buffer (0x02)
                {
                    0x00, 0x00                                     
                }, 

                Buffer (0x02)
                {
                    0x00, 0x00                                     
                }, 

                Buffer (0x08)
                {
                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                }, 

                Buffer (0x08)
                {
                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                }
            })
            Store (B1CT, Index (DerefOf (Index (GBUF, Zero)), Zero))
            Store (Zero, Index (DerefOf (Index (GBUF, One)), Zero))
            Name (BUF1, Buffer (0x08) {})
            Store (RECB (0x14, 0x40), BUF1)
            CreateByteField (BUF1, Zero, FW0)
            CreateByteField (BUF1, One, FW1)
            CreateByteField (BUF1, 0x02, FW2)
            CreateByteField (BUF1, 0x03, FW3)
            CreateByteField (BUF1, 0x04, FW4)
            CreateByteField (BUF1, 0x05, FW5)
            CreateByteField (BUF1, 0x06, FW6)
            CreateByteField (BUF1, 0x07, FW7)
            Store (FW0, Index (DerefOf (Index (GBUF, 0x02)), Zero))
            Store (FW1, Index (DerefOf (Index (GBUF, 0x02)), One))
            Store (FW2, Index (DerefOf (Index (GBUF, 0x02)), 0x02))
            Store (FW3, Index (DerefOf (Index (GBUF, 0x02)), 0x03))
            Store (FW4, Index (DerefOf (Index (GBUF, 0x02)), 0x04))
            Store (FW5, Index (DerefOf (Index (GBUF, 0x02)), 0x05))
            Store (FW6, Index (DerefOf (Index (GBUF, 0x02)), 0x06))
            Store (FW7, Index (DerefOf (Index (GBUF, 0x02)), 0x07))
            Store (Zero, Index (DerefOf (Index (GBUF, 0x03)), Zero))
            Return (GBUF)
        }
        Method (CFUN, 4, Serialized)
        {
            Name (ESRC, 0x05)
            If (LNotEqual (Match (CMFP, MEQ, DerefOf (Index (Arg0, Zero)), MTR, 
                Zero, Zero), Ones))
            {
                Acquire (CFMX, 0xFFFF)
                Store (Arg0, SMID)
                Store (Arg1, SFNO)
                Store (Arg2, BFDT)
                Store (0xCE, SMIC)
                Release (CFMX)
            }
            Else
            {
                If (LEqual (DerefOf (Index (Arg0, Zero)), 0x10))
                {
                    If (LEqual (DerefOf (Index (Arg1, Zero)), One))
                    {
                        CreateByteField (Arg2, Zero, CAPV)
                        Store (CAPV, CAVR)
                        Store (One, STDT)
                    }
                    Else
                    {
                        If (LEqual (DerefOf (Index (Arg1, Zero)), 0x02))
                        {
                            Store (Buffer (0x80) {}, Local0)
                            CreateByteField (Local0, Zero, BFD0)
                            Store (0x08, BFD0)
                            Store (One, STDT)
                            Store (Local0, BFDT)
                        }
                        Else
                        {
                            Store (Zero, STDT)
                        }
                    }
                }
                Else
                {
                    If (LEqual (DerefOf (Index (Arg0, Zero)), 0x18))
                    {
                        Acquire (CFMX, 0xFFFF)
                        If (LEqual (DerefOf (Index (Arg1, Zero)), 0x02))
                        {
                            WECB (0x64, 0x0100, Zero)
                            Store (DerefOf (Index (Arg2, One)), SMAD)
                            Store (DerefOf (Index (Arg2, 0x02)), SMCM)
                            Store (DerefOf (Index (Arg2, Zero)), SMPR)
                            While (LAnd (Not (LEqual (ESRC, Zero)), Not (LEqual (And (SMST, 0x80
                                ), 0x80))))
                            {
                                Sleep (0x14)
                                Subtract (ESRC, One, ESRC)
                            }

                            Store (SMST, Local2)
                            If (LEqual (And (Local2, 0x80), 0x80))
                            {
                                Store (Buffer (0x80) {}, Local1)
                                Store (Local2, Index (Local1, Zero))
                                If (LEqual (Local2, 0x80))
                                {
                                    Store (0xC4, P80H)
                                    Store (BCNT, Index (Local1, One))
                                    Store (RECB (0x64, 0x0100), Local3)
                                    Store (DerefOf (Index (Local3, Zero)), Index (Local1, 0x02))
                                    Store (DerefOf (Index (Local3, One)), Index (Local1, 0x03))
                                    Store (DerefOf (Index (Local3, 0x02)), Index (Local1, 0x04))
                                    Store (DerefOf (Index (Local3, 0x03)), Index (Local1, 0x05))
                                    Store (DerefOf (Index (Local3, 0x04)), Index (Local1, 0x06))
                                    Store (DerefOf (Index (Local3, 0x05)), Index (Local1, 0x07))
                                    Store (DerefOf (Index (Local3, 0x06)), Index (Local1, 0x08))
                                    Store (DerefOf (Index (Local3, 0x07)), Index (Local1, 0x09))
                                    Store (DerefOf (Index (Local3, 0x08)), Index (Local1, 0x0A))
                                    Store (DerefOf (Index (Local3, 0x09)), Index (Local1, 0x0B))
                                    Store (DerefOf (Index (Local3, 0x0A)), Index (Local1, 0x0C))
                                    Store (DerefOf (Index (Local3, 0x0B)), Index (Local1, 0x0D))
                                    Store (DerefOf (Index (Local3, 0x0C)), Index (Local1, 0x0E))
                                    Store (DerefOf (Index (Local3, 0x0D)), Index (Local1, 0x0F))
                                    Store (DerefOf (Index (Local3, 0x0E)), Index (Local1, 0x10))
                                    Store (DerefOf (Index (Local3, 0x0F)), Index (Local1, 0x11))
                                    Store (DerefOf (Index (Local3, 0x10)), Index (Local1, 0x12))
                                    Store (DerefOf (Index (Local3, 0x11)), Index (Local1, 0x13))
                                    Store (DerefOf (Index (Local3, 0x12)), Index (Local1, 0x14))
                                    Store (DerefOf (Index (Local3, 0x13)), Index (Local1, 0x15))
                                    Store (DerefOf (Index (Local3, 0x14)), Index (Local1, 0x16))
                                    Store (DerefOf (Index (Local3, 0x15)), Index (Local1, 0x17))
                                    Store (DerefOf (Index (Local3, 0x16)), Index (Local1, 0x18))
                                    Store (DerefOf (Index (Local3, 0x17)), Index (Local1, 0x19))
                                    Store (DerefOf (Index (Local3, 0x18)), Index (Local1, 0x1A))
                                    Store (DerefOf (Index (Local3, 0x19)), Index (Local1, 0x1B))
                                    Store (DerefOf (Index (Local3, 0x1A)), Index (Local1, 0x1C))
                                    Store (DerefOf (Index (Local3, 0x1B)), Index (Local1, 0x1D))
                                    Store (DerefOf (Index (Local3, 0x1C)), Index (Local1, 0x1E))
                                    Store (DerefOf (Index (Local3, 0x1D)), Index (Local1, 0x1F))
                                    Store (DerefOf (Index (Local3, 0x1E)), Index (Local1, 0x20))
                                    Store (DerefOf (Index (Local3, 0x1F)), Index (Local1, 0x21))
                                }

                                Store (Local1, BFDT)
                                Store (One, STDT)
                            }
                            Else
                            {
                                Store (0xC5, P80H)
                                Store (Zero, STDT)
                            }
                        }
                        Else
                        {
                            Store (0xC6, P80H)
                            Store (Zero, STDT)
                        }

                        Release (CFMX)
                    }
                    Else
                    {
                        Store (Zero, STDT)
                    }
                }
            }
        }
        Method (\B1B2, 2, NotSerialized) { Return (Or(Arg0, ShiftLeft(Arg1, 8))) }
    }
//}
//EOF