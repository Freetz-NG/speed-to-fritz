SQUASHFS4_VERSION:=4.0
SQUASHFS4_SOURCE:=squashfs$(SQUASHFS4_VERSION).tar.gz
#SQUASHFS4_SOURCE_MD5:=
SQUASHFS4_SITE:=@SF/squashfs
SQUASHFS4_DIR:=$(TOOLS_SOURCE_DIR)/squashfs$(SQUASHFS4_VERSION)

MKSQUASHFS4_DIR:=$(SQUASHFS4_DIR)/squashfs-tools
MKSQUASHFS4_MAKE_DIR:=$(TOOLS_DIR)/make

UNSQUASHFS4_DIR:=$(SQUASHFS4_DIR)/squashfs-tools
UNSQUASHFS4_MAKE_DIR:=$(TOOLS_DIR)/make

SQUASHFS4_LZMA_VERSION:=443
SQUASHFS4_LZMA_DIR:=$(TOOLS_SOURCE_DIR)/lzma$(SQUASHFS4_LZMA_VERSION)
SQUASHFS4_EXTERNAL_LZMA_DIR:=../../lzma$(SQUASHFS4_LZMA_VERSION)


$(DL_DIR)/$(SQUASHFS4_SOURCE): | $(DL_DIR)
	$(DL_TOOL) $(DL_DIR) $(TOOLS_DOT_CONFIG) $(SQUASHFS4_SOURCE) $(SQUASHFS4_SITE) $(SQUASHFS4_SOURCE_MD5)


$(SQUASHFS4_DIR)/.unpacked: $(DL_DIR)/$(SQUASHFS4_SOURCE) | $(TOOLS_SOURCE_DIR)
	tar -C $(TOOLS_SOURCE_DIR) $(VERBOSE) -xzf $(DL_DIR)/$(SQUASHFS4_SOURCE)
	for i in $(MKSQUASHFS4_MAKE_DIR)/patches/*.squashfs4.patch; do \
		$(PATCH_TOOL) $(SQUASHFS4_DIR) $$i; \
	done
	touch $@

$(MKSQUASHFS4_DIR)/mksquashfs4-lzma: $(SQUASHFS4_DIR)/.unpacked
	$(MAKE) CXX="$(TOOLS_CXX)" LZMA_DIR="$(SQUASHFS4_EXTERNAL_LZMA_DIR)" \
		-C $(MKSQUASHFS4_DIR) mksquashfs4-lzma
	touch -c $@

$(UNSQUASHFS4_DIR)/unsquashfs4-lzma: $(SQUASHFS4_DIR)/.unpacked
	$(MAKE) CXX="$(TOOLS_CXX)" LZMA_DIR="$(SQUASHFS4_EXTERNAL_LZMA_DIR)" \
		-C $(MKSQUASHFS4_DIR) unsquashfs4-lzma
	touch -c $@

$(TOOLS_DIR)/mksquashfs4-lzma: $(MKSQUASHFS4_DIR)/mksquashfs4-lzma
	cp $(MKSQUASHFS4_DIR)/mksquashfs4-lzma $(TOOLS_DIR)/mksquashfs4-lzma

$(TOOLS_DIR)/unsquashfs4-lzma: $(UNSQUASHFS4_DIR)/unsquashfs4-lzma
	cp $(UNSQUASHFS4_DIR)/unsquashfs4-lzma $(TOOLS_DIR)/unsquashfs4-lzma

squashfs4: $(TOOLS_DIR)/mksquashfs4-lzma $(TOOLS_DIR)/unsquashfs4-lzma

squashfs4-source: $(SQUASHFS4_DIR)/.unpacked

squashfs4-clean:
	-$(MAKE) -C $(MKSQUASHFS4_DIR) clean

squashfs4-dirclean:
	$(RM) -r $(SQUASHFS4_DIR)

squashfs4-distclean: squashfs4-dirclean
	$(RM) $(TOOLS_DIR)/mksquashfs4-lzma
	$(RM) $(TOOLS_DIR)/unsquashfs4-lzma
