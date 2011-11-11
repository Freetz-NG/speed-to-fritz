
KCONFIG_DIR:=$(TOOLS_DIR)/kk
KCONFIG_MAKE_DIR:=$(TOOLS_DIR)/make
KCONFIG_TARGET_DIR:=$(KCONFIG_DIR)


$(KCONFIG_DIR)/scripts/kconfig/conf: $(KCONFIG_DIR)/.unpacked
	$(MAKE) -C $(KCONFIG_DIR) config

$(KCONFIG_DIR)/scripts/kconfig/mconf: $(KCONFIG_DIR)/.unpacked
	$(MAKE) -C $(KCONFIG_DIR) menuconfig

$(KCONFIG_TARGET_DIR)/conf: $(KCONFIG_DIR)/scripts/kconfig/conf
#	cp $(KCONFIG_DIR)/scripts/kconfig/conf $(KCONFIG_TARGET_DIR)/conf

$(KCONFIG_TARGET_DIR)/mconf: $(KCONFIG_DIR)/scripts/kconfig/mconf
#	cp $(KCONFIG_DIR)/scripts/kconfig/mconf $(KCONFIG_TARGET_DIR)/mconf

kconfig: $(KCONFIG_TARGET_DIR)/conf $(KCONFIG_TARGET_DIR)/mconf

kconfig-dirclean:
kconfig-clean:
	$(RM) \
		$(KCONFIG_DIR)/scripts/basic/.*.cmd \
		$(KCONFIG_DIR)/scripts/kconfig/.*.cmd \
		$(KCONFIG_DIR)/scripts/kconfig/lxdialog/.*.cmd \
		$(KCONFIG_DIR)/scripts/kconfig/*.o \
		$(KCONFIG_DIR)/scripts/kconfig/lxdialog/*.o \
		$(KCONFIG_DIR)/scripts/kconfig/zconf.*.c \
		$(KCONFIG_DIR)/scripts/basic/fixdep \
		$(KCONFIG_DIR)/scripts/kconfig/conf \
		$(KCONFIG_DIR)/scripts/kconfig/mconf


kconfig-distclean:
	$(RM) \
		$(KCONFIG_TARGET_DIR)/conf \
#		$(KCONFIG_TARGET_DIR)/mconf
