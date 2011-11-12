# Modified for use with Speed-to-freetz!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#
#--------------------------------------------------------------
# Just run 'make menuconfig', configure stuff, then run 'make'.
# You shouldn't need to mess with anything beyond this point...
#--------------------------------------------------------------
CONFIG=tools/kk/scripts/kconfig
CONFIG_CONFIG_IN=Config.in
CONFIG_DEFCONFIG=Firmware.conf
DATE:=$(shell date +%Y%m%d)
SHELL:=/bin/bash
IMAGE:=
LOCALIP:=
RECOVER:=
#FREETZ_BASE_DIR:=$(shell pwd)
HOMEDIR:=$(shell pwd)
TOPDIR:=$(shell pwd)
DL_DIR:=dl
MAKE_DIR:=make
PACKAGES_DIR:=packages
SOURCE_DIR:=source
TOOLS_SOURCE_DIR:=$(HOMEDIR)/source
TOOLS_DIR:=$(HOMEDIR)/tools
SED:=sed
PATCH_TOOL:=$(TOOLS_DIR)/freetz_patch
DL_TOOL:=$(TOOLS_DIR)/freetz_download
include $(TOOLS_DIR)/make/Makefile.in

VERBOSE:=-v

export FREETZ_VERBOSITY_LEVEL
export VERBOSE

TOOLS_CLEAN:=$(patsubst %,%-clean,$(TOOLS))
TOOLS_DIRCLEAN:=$(patsubst %,%-dirclean,$(TOOLS))
TOOLS_DISTCLEAN:=$(patsubst %,%-distclean,$(TOOLS))
TOOLS_SOURCE:=$(patsubst %,%-source,$(TOOLS))

SEDTOOL_CLEAN:=$(patsubst %,%-clean,$(SEDTOOL))
SEDTOOL_DIRCLEAN:=$(patsubst %,%-dirclean,$(SEDTOOL))
SEDTOOL_DISTCLEAN:=$(patsubst %,%-distclean,$(SEDTOOL))
SEDTOOL_SOURCE:=$(patsubst %,%-source,$(SEDTOOL))

noconfig_targets:=menuconfig config oldconfig randconfig \
	defconfig allyesconfig allnoconfig  \
	help sedtool tools $(TOOLS) $(SEDTOOL)

all: menuconfig

# configuration
# ---------------------------------------------------------------------------
$(CONFIG)/mconf:
	$(MAKE) tools

menuconfig: $(CONFIG)/mconf
	@mkdir -p $(CONFIG)/buildroot-config
	@if ! KCONFIG_AUTOCONFIG=$(CONFIG)/buildroot-config/auto.conf \
		KCONFIG_AUTOHEADER=$(CONFIG)/buildroot-config/autoconf.h \
		$(CONFIG)/mconf $(CONFIG_CONFIG_IN); then \
		test -f .config.cmd || rm -f .config; \
	fi
# ---------------------------------------------------------------------------

include $(TOOLS_DIR)/make/*.mk

$(DL_DIR):
	@mkdir -p $(DL_DIR)

$(SOURCE_DIR):
	@mkdir -p $(SOURCE_DIR)

$(TOOLS_SOURCE_DIR):
	@mkdir -p $(TOOLS_SOURCE_DIR)

toolsclean: $(TOOLS_CLEAN)
toolsdirclean: $(TOOLS_DIRCLEAN)
tools: $(DL_DIR) $(SOURCE_DIR) $(TOOLS)

sedtoolclean: $(SEDTOOL_CLEAN)
sedtooldirclean: $(SEDTOOL_DIRCLEAN)
sedtool: $(DL_DIR) $(SOURCE_DIR) $(SEDTOOL)

#############################################################
#
# Cleanup and misc junk
#
#############################################################
clean:
	rm -f .config .config.old
	-$(MAKE) -C $(CONFIG) clean

distclean: clean
	rm -rf sources/*

help:
	@echo 'Cleaning:'
	@echo '  clean                  - delete temporary files created'
	@echo
	@echo
	@echo 'Configuration:'
	@echo '  menuconfig             - interactive curses-based configurator'
	@echo '  oldconfig              - resolve any unresolved symbols in .config'
	@echo
	@echo
	@echo

.PHONY: dummy distclean clean config oldconfig \
	menuconfig defconfig help toolsclean toolsdirclean tools sedtool sedtoolclean sedtooldirclean
	
