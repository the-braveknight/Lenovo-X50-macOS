# makefile
#
# Created by the-braveknight
#

BUILDDIR=./Build

IASLOPTS=-vw 2095 -vw 2008
IASL=iasl

Z50=$(BUILDDIR)/SSDT-Z50.aml
G50=$(BUILDDIR)/SSDT-G50.aml

.PHONY: all
all: $(Z50) $(G50)
	
$(BUILDDIR)/%.aml : Hotpatch/%.dsl
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