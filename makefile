# makefile
#
# Created by the-braveknight
#

BUILDDIR=./Build

IASLOPTS=-vw 2095 -vw 2008
IASL=iasl

RehabMan=$(BUILDDIR)/SSDT-IGPU.aml $(BUILDDIR)/SSDT-HDEF.aml $(BUILDDIR)/SSDT-HDAU.aml $(BUILDDIR)/SSDT-GPRW.aml $(BUILDDIR)/SSDT-PNLF.aml $(BUILDDIR)/SSDT-XOSI.aml $(BUILDDIR)/SSDT-PluginType1.aml $(BUILDDIR)/SSDT-XHC.aml $(BUILDDIR)/SSDT-Disable_EH01.aml
Z50=$(BUILDDIR)/SSDT-Z50.aml $(BUILDDIR)/SSDT-DGPU-Z50.aml
G50=$(BUILDDIR)/SSDT-G50.aml $(BUILDDIR)/SSDT-DGPU-G50.aml

.PHONY: all
all: $(RehabMan) $(Z50) $(G50)

$(BUILDDIR)/%.aml : Downloads/Hotpatch/%.dsl
	$(IASL) $(IASLOPTS) -p $@ $<
	
$(BUILDDIR)/%.aml : Hotpatch/%.dsl
	$(IASL) $(IASLOPTS) -p $@ $<

.PHONY: clean
clean:
	rm -f $(BUILDDIR)/*.aml

.PHONY: install_rehabman
install_rehabman: $(RehabMan)
	$(eval EFIDIR:=$(shell macos-tools/mount_efi.sh))
	cp $(RehabMan) $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_z50
install_z50: $(Z50)
	$(eval EFIDIR:=$(shell macos-tools/mount_efi.sh))
	rm -f $(EFIDIR)/EFI/CLOVER/ACPI/patched/*.aml
	cp $(Z50) $(EFIDIR)/EFI/CLOVER/ACPI/patched
	make install_rehabman

.PHONY: install_g50
install_g50: $(G50)
	$(eval EFIDIR:=$(shell macos-tools/mount_efi.sh))
	rm -f $(EFIDIR)/EFI/CLOVER/ACPI/patched/*.aml
	cp $(G50) $(EFIDIR)/EFI/CLOVER/ACPI/patched
	make install_rehabman