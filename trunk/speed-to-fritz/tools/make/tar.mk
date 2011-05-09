TAR_VERSION:=1.15.1
TAR_SOURCE:=tar-$(TAR_VERSION).tar.bz2
TAR_SOURCE_MD5:=57da3c38f8e06589699548a34d5a5d07
TAR_SITE:=http://ftp.gnu.org/gnu/tar
TAR_DIR:=$(TOOLS_SOURCE_DIR)/tar-$(TAR_VERSION)
TAR_MAKE_DIR:=$(TOOLS_DIR)/make

$(DL_DIR)/$(TAR_SOURCE): | $(DL_DIR)
	$(DL_TOOL) $(DL_DIR) $(TOOLS_DOT_CONFIG) $(TAR_SOURCE) $(TAR_SITE) $(TAR_SOURCE_MD5)

$(TAR_DIR)/.unpacked: $(DL_DIR)/$(TAR_SOURCE) | $(TOOLS_SOURCE_DIR)
	mkdir -p $(TAR_DIR)
	tar -C $(TOOLS_SOURCE_DIR) $(VERBOSE) -xjf $(DL_DIR)/$(TAR_SOURCE)
	for i in $(TAR_MAKE_DIR)/patches/*.tar.patch; do \
		$(PATCH_TOOL) $(TAR_DIR) $$i; \
	done
	touch $@

$(TAR_DIR)/.configured: $(TAR_DIR)/.unpacked
	(cd $(TAR_DIR); rm -rf config.cache; \
		CFLAGS="-O2 -Wall" \
		CC="$(TOOLS_CC)" \
		./configure \
		--prefix=/usr \
		$(DISABLE_NLS) \
	);
	touch $@

$(TAR_DIR)/src/tar: $(TAR_DIR)/.configured
	$(MAKE) CC="$(TOOLS_CC)" \
		-C $(TAR_DIR) all
	touch -c $@

$(TOOLS_DIR)/oldtar/tar: $(TAR_DIR)/src/tar
	$(RM) $(TOOLS_DIR)/oldtar/tar
	$(RM) -r $(TOOLS_DIR)/oldtar
	mkdir $(TOOLS_DIR)/oldtar
	cp $(TAR_DIR)/src/tar $(TOOLS_DIR)/oldtar/tar
	strip $(TOOLS_DIR)/oldtar/tar

tar: $(TOOLS_DIR)/oldtar/tar

tar-source: $(TAR_DIR)/.unpacked

tar-clean:
	-$(MAKE) -C $(TAR_DIR) clean

tar-dirclean:
	$(RM) -r $(TAR_DIR)

tar-distclean: tar-dirclean
	$(RM) $(TOOLS_DIR)/oldtar/tar
	$(RM) -r $(TOOLS_DIR)/oldtar
