FAKEROOT_VERSION:=1.15.1
FAKEROOT_SOURCE:=fakeroot_$(FAKEROOT_VERSION).orig.tar.bz2
FAKEROOT_SOURCE_MD5:=248c408b1e06e776c5739871b49bd968
FAKEROOT_SITE:=http://ftp.debian.org/debian/pool/main/f/fakeroot
#FAKEROOT_SITE:=http://ftp.debian.org/debian/pool/main/f/fakeroot
# this file uses different paths as the compareable freetz version
#--> 
FAKEROOT_NAME:=fakeroot
FAKEROOT_DESTDIR:=$(TOOLS_DIR)/usr
FAKEROOT_BIN_DIR:=$(FAKEROOT_DESTDIR)/bin
FAKEROOT_LIB_DIR:=$(FAKEROOT_DESTDIR)/lib
FAKEROOT_TARGET_SCRIPT:=$(FAKEROOT_BIN_DIR)/$(FAKEROOT_NAME)
#<--
FAKEROOT_DIR:=$(TOOLS_SOURCE_DIR)/fakeroot-$(FAKEROOT_VERSION)
FAKEROOT_MAKE_DIR:=$(TOOLS_DIR)/make

$(DL_DIR)/$(FAKEROOT_SOURCE): | $(DL_DIR)
	$(DL_TOOL) $(DL_DIR) $(TOOLS_DOT_CONFIG) $(FAKEROOT_SOURCE) $(FAKEROOT_SITE) $(FAKEROOT_SOURCE_MD5)

fakeroot-source: $(DL_DIR)/$(FAKEROOT_SOURCE)

$(FAKEROOT_DIR)/.unpacked: $(DL_DIR)/$(FAKEROOT_SOURCE) | $(TOOLS_SOURCE_DIR)
	tar -C $(TOOLS_SOURCE_DIR) $(VERBOSE) -xjf $(DL_DIR)/$(FAKEROOT_SOURCE)
	$(SED) -i "s,getopt --version,getopt --version 2>/dev/null," \
		$(FAKEROOT_DIR)/scripts/fakeroot.in
	for i in $(FAKEROOT_MAKE_DIR)/patches/*.fakeroot.patch; do \
		$(PATCH_TOOL) $(FAKEROOT_DIR) $$i; \
	done
	touch $@

$(FAKEROOT_DIR)/.configured: $(FAKEROOT_DIR)/.unpacked
	(cd $(FAKEROOT_DIR); rm -rf config.cache; \
		CFLAGS="-O3 -Wall" \
		CC="$(TOOLS_CC)" \
		./configure \
		--prefix=/ \
		--enable-shared \
		$(DISABLE_NLS) \
	);
	touch $(FAKEROOT_DIR)/.configured

$(FAKEROOT_DIR)/faked: $(FAKEROOT_DIR)/.configured
	$(MAKE) -C $(FAKEROOT_DIR)

$(FAKEROOT_TARGET_SCRIPT): $(FAKEROOT_DIR)/faked
	$(MAKE) DESTDIR=$(FAKEROOT_DESTDIR) -C $(FAKEROOT_DIR) install
#--> sp2fr needs it this way
	$(SED) -i -e 's,FAKEROOT_PREFIX,PREFIX,g' $(FAKEROOT_TARGET_SCRIPT)
	$(SED) -i -e 's,FAKEROOT_BINDIR,BINDIR,g' $(FAKEROOT_TARGET_SCRIPT)
#<--
fakeroot: $(FAKEROOT_TARGET_SCRIPT)

fakeroot-clean:
	$(MAKE) -C $(FAKEROOT_DIR) clean

fakeroot-dirclean:
	$(RM) -r $(FAKEROOT_DIR)

fakeroot-distclean:
	$(RM) -r $(FAKEROOT_TARGET_SCRIPT) $(FAKEROOT_BIN_DIR)/faked $(FAKEROOT_LIB_DIR)/libfakeroot*
