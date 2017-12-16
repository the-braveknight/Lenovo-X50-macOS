# makefile
#
# Created by the-braveknight
#

BUILDDIR=./Build

IASLOPTS=-vw 2095 -vw 2008
IASL=iasl

ALL=$(BUILDDIR)/SSDT-IGPU.aml $(BUILDDIR)/SSDT-HDEF.aml $(BUILDDIR)/SSDT-HDAU.aml $(BUILDDIR)/SSDT-GPRW.aml $(BUILDDIR)/SSDT-PNLF.aml $(BUILDDIR)/SSDT-XOSI.aml $(BUILDDIR)/SSDT-PluginType1.aml $(BUILDDIR)/SSDT-XHC.aml $(BUILDDIR)/SSDT-Disable_EH01.aml
Z50=$(ALL) $(BUILDDIR)/SSDT-Z50.aml
G50=$(ALL) $(BUILDDIR)/SSDT-G50.aml

.PHONY: all
all: $(Z50) $(G50)

$(BUILDDIR)/%.aml : Downloads/Hotpatch/%.dsl
	$(IASL) $(IASLOPTS) -p $@ $<
	
$(BUILDDIR)/SSDT-Z50.aml : Hotpatch/SSDT-Z50.dsl
	$(IASL) $(IASLOPTS) -p $@ $<
	
$(BUILDDIR)/SSDT-G50.aml : Hotpatch/SSDT-G50.dsl
	$(IASL) $(IASLOPTS) -p $@ $<

.PHONY: clean
clean:
	rm -f $(BUILDDIR)/*.aml

.PHONY: install_z50
install_z50: $(Z50)
	$(eval EFIDIR:=$(shell macos-tools/mount_efi.sh))
	rm -f $(EFIDIR)/EFI/CLOVER/ACPI/patched/*.aml
	cp $(Z50) $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_g50
install_g50: $(G50)
	$(eval EFIDIR:=$(shell macos-tools/mount_efi.sh))
	rm -f $(EFIDIR)/EFI/CLOVER/ACPI/patched/*.aml
	cp $(G50) $(EFIDIR)/EFI/CLOVER/ACPI/patched
