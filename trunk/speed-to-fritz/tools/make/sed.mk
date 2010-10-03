SED_VERSION:=4.2.1
SED_SOURCE:=sed-$(SED_VERSION).tar.bz2
SED_SOURCE_MD5:=7d310fbd76e01a01115075c1fd3f455a
SED_SITE:=ftp://ftp.gnu.org/gnu/sed
SED_DIR:=$(TOOLS_SOURCE_DIR)/sed-$(SED_VERSION)

$(DL_DIR)/$(SED_SOURCE): | $(DL_DIR)
	$(DL_TOOL) $(DL_DIR) $(TOOLS_DOT_CONFIG) $(SED_SOURCE) $(SED_SITE) $(SED_SOURCE_MD5)

$(SED_DIR)/.unpacked: $(DL_DIR)/$(SED_SOURCE) | $(TOOLS_SOURCE_DIR)
	mkdir -p $(SED_DIR)
	tar -C $(TOOLS_SOURCE_DIR) $(VERBOSE) -xjf $(DL_DIR)/$(SED_SOURCE)
	touch $@

$(SED_DIR)/.configured: $(SED_DIR)/.unpacked
	(cd $(SED_DIR); rm -rf config.cache; \
		CFLAGS="-O2 -Wall" \
		CC="$(TOOLS_CC)" \
		./configure \
		--prefix=/usr \
		$(DISABLE_NLS) \
	);
	touch $@

$(SED_DIR)/src/sed: $(SED_DIR)/.configured
	$(MAKE) CC="$(TOOLS_CC)" \
		-C $(SED_DIR) all
	touch -c $@

$(TOOLS_DIR)/sed: $(SED_DIR)/src/sed
	$(RM) $(TOOLS_DIR)/sed
	cp -f $(SED_DIR)/sed/sed $(TOOLS_DIR)/sed
	strip $(TOOLS_DIR)/sed

sed: $(TOOLS_DIR)/sed

sed-source: $(SED_DIR)/.unpacked

sed-clean:
	-$(MAKE) -C $(SED_DIR) clean

sed-dirclean:
	$(RM) -r $(SED_DIR)

sed-distclean: sed-dirclean
	$(RM) $(TOOLS_DIR)/sed
