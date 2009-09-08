# Modified for use with Speed-to-freetz!!!!!!!!!!!!!!!!!!!!!!
# Source from svn://uclibc.org/trunk/builtroot/package/conifg
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Makefile for buildroot2
#
#
# Copyright (C) 1999-2005 by Erik Andersen <andersen@codepoet.org>
#
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
CONFIG=tools/config
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

noconfig_targets:=menuconfig config oldconfig randconfig \
	defconfig allyesconfig allnoconfig  \
	help tools $(TOOLS)

# To put more focus on warnings, be less verbose as default
# Use 'make V=1' to see the full commands
ifdef V
  ifeq ("$(origin V)", "command line")
    KBUILD_VERBOSE=$(V)
  endif
endif
ifndef KBUILD_VERBOSE
  KBUILD_VERBOSE=0
endif

ifeq ($(KBUILD_VERBOSE),1)
  quiet=
  Q=
ifndef VERBOSE
  VERBOSE=1
endif
else
  quiet=quiet_
  Q=@
endif

CONFIG_SHELL:=$(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	else if [ -x /bin/bash ]; then echo /bin/bash; \
	else echo sh; fi; fi)

export CONFIG_SHELL quiet Q KBUILD_VERBOSE VERBOSE

ifndef HOSTAR
HOSTAR:=ar
endif
ifndef HOSTAS
HOSTAS:=as
endif
ifndef HOSTCC
HOSTCC:=gcc
else
endif
ifndef HOSTCXX
HOSTCXX:=g++
endif
ifndef HOSTFC
HOSTFC:=gfortran
endif
ifndef HOSTCPP
HOSTCPP:=cpp
endif
ifndef HOSTLD
HOSTLD:=ld
endif
ifndef HOSTLN
HOSTLN:=ln
endif
ifndef HOSTNM
HOSTNM:=nm
endif
HOSTAR:=$(shell $(CONFIG_SHELL) -c "which $(HOSTAR)" || type -p $(HOSTAR) || echo ar)
HOSTAS:=$(shell $(CONFIG_SHELL) -c "which $(HOSTAS)" || type -p $(HOSTAS) || echo as)
HOSTCC:=$(shell $(CONFIG_SHELL) -c "which $(HOSTCC)" || type -p $(HOSTCC) || echo gcc)
HOSTCXX:=$(shell $(CONFIG_SHELL) -c "which $(HOSTCXX)" || type -p $(HOSTCXX) || echo g++)
HOSTFC:=$(shell $(CONFIG_SHELL) -c "which $(HOSTLD)" || type -p $(HOSTLD) || echo || which g77 || type -p g77 || echo gfortran)
HOSTCPP:=$(shell $(CONFIG_SHELL) -c "which $(HOSTCPP)" || type -p $(HOSTCPP) || echo cpp)
HOSTLD:=$(shell $(CONFIG_SHELL) -c "which $(HOSTLD)" || type -p $(HOSTLD) || echo ld)
HOSTLN:=$(shell $(CONFIG_SHELL) -c "which $(HOSTLN)" || type -p $(HOSTLN) || echo ln)
HOSTNM:=$(shell $(CONFIG_SHELL) -c "which $(HOSTNM)" || type -p $(HOSTNM) || echo nm)
ifndef CFLAGS_FOR_BUILD
CFLAGS_FOR_BUILD:=-g -O2
endif
ifndef CXXFLAGS_FOR_BUILD
CXXFLAGS_FOR_BUILD:=-g -O2
endif
ifndef FCFLAGS_FOR_BUILD
FCFLAGS_FOR_BUILD:=-g -O2
endif
export HOSTAR HOSTAS HOSTCC HOSTCXX HOSTFC HOSTLD


ifeq ($(BR2_HAVE_DOT_CONFIG),y)

# cc-option
# Usage: cflags-y+=$(call cc-option, -march=winchip-c6, -march=i586)
# sets -march=winchip-c6 if supported else falls back to -march=i586
# without checking the latter.
cc-option=$(shell if $(TARGET_CC) $(TARGET_CFLAGS) $(1) -S -o /dev/null -xc /dev/null \
	> /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)

#############################################################
#
# Hide troublesome environment variables from sub processes
#
#############################################################
unexport CROSS_COMPILE
unexport ARCH

#############################################################
#
# Setup the proper filename extensions for the host
#
##############################################################
ifneq ($(findstring linux,$(BR2_GNU_BUILD_SUFFIX)),)
HOST_EXEEXT:=
HOST_LIBEXT:=.a
HOST_SHREXT:=.so
endif
ifneq ($(findstring apple,$(BR2_GNU_BUILD_SUFFIX)),)
HOST_EXEEXT:=
HOST_LIBEXT:=.a
HOST_SHREXT:=.dylib
endif
ifneq ($(findstring cygwin,$(BR2_GNU_BUILD_SUFFIX)),)
HOST_EXEEXT:=.exe
HOST_LIBEXT:=.lib
HOST_SHREXT:=.dll
endif
ifneq ($(findstring mingw,$(BR2_GNU_BUILD_SUFFIX)),)
HOST_EXEEXT:=.exe
HOST_LIBEXT:=.lib
HOST_SHREXT:=.dll
endif

# The preferred type of libs we build for the target
ifeq ($(BR2_PREFER_STATIC_LIB),y)
LIBTGTEXT=.a
#PREFERRED_LIB_FLAGS:=--disable-shared --enable-static
else
LIBTGTEXT=.so
#PREFERRED_LIB_FLAGS:=--disable-static --enable-shared
endif
PREFERRED_LIB_FLAGS:=--enable-static --enable-shared


#############################################################
#
# Cleanup and misc junk
#
#############################################################
## clean: $(TARGETS_CLEAN)
## 	rm -rf $(STAGING_DIR) $(TARGET_DIR) $(IMAGE)


else # ifeq ($(BR2_HAVE_DOT_CONFIG),y)

all: menuconfig

# configuration
# ---------------------------------------------------------------------------

HOSTCFLAGS=$(CFLAGS_FOR_BUILD)
export HOSTCFLAGS

$(CONFIG)/conf:
	@mkdir -p $(CONFIG)/buildroot-config
	$(MAKE) CC="$(HOSTCC)" -C $(CONFIG) conf
	-@if [ ! -f .config ]; then \
		cp $(CONFIG_DEFCONFIG) .config; \
	fi
$(CONFIG)/mconf:
	@mkdir -p $(CONFIG)/buildroot-config
	$(MAKE) CC="$(HOSTCC)" -C $(CONFIG) conf mconf
	-@if [ ! -f .config ]; then \
		cp $(CONFIG_DEFCONFIG) .config; \
	fi

menuconfig: $(CONFIG)/mconf
	@mkdir -p $(CONFIG)/buildroot-config
	@if ! KCONFIG_AUTOCONFIG=$(CONFIG)/buildroot-config/auto.conf \
		KCONFIG_AUTOHEADER=$(CONFIG)/buildroot-config/autoconf.h \
		$(CONFIG)/mconf $(CONFIG_CONFIG_IN); then \
		test -f .config.cmd || rm -f .config; \
	fi

config: $(CONFIG)/conf
	@mkdir -p $(CONFIG)/buildroot-config
	@KCONFIG_AUTOCONFIG=$(CONFIG)/buildroot-config/auto.conf \
		KCONFIG_AUTOHEADER=$(CONFIG)/buildroot-config/autoconf.h \
		$(CONFIG)/conf $(CONFIG_CONFIG_IN)

oldconfig: $(CONFIG)/conf
	@mkdir -p $(CONFIG)/buildroot-config
	@KCONFIG_AUTOCONFIG=$(CONFIG)/buildroot-config/auto.conf \
		KCONFIG_AUTOHEADER=$(CONFIG)/buildroot-config/autoconf.h \
		$(CONFIG)/conf -o $(CONFIG_CONFIG_IN)

randconfig: $(CONFIG)/conf
	@mkdir -p $(CONFIG)/buildroot-config
	@KCONFIG_AUTOCONFIG=$(CONFIG)/buildroot-config/auto.conf \
		KCONFIG_AUTOHEADER=$(CONFIG)/buildroot-config/autoconf.h \
		$(CONFIG)/conf -r $(CONFIG_CONFIG_IN)

allyesconfig: $(CONFIG)/conf
	cat $(CONFIG_DEFCONFIG) > .config
	@mkdir -p $(CONFIG)/buildroot-config
	@KCONFIG_AUTOCONFIG=$(CONFIG)/buildroot-config/auto.conf \
		KCONFIG_AUTOHEADER=$(CONFIG)/buildroot-config/autoconf.h \
		$(CONFIG)/conf -y $(CONFIG_CONFIG_IN)
	#sed -i -e "s/^CONFIG_DEBUG.*/# CONFIG_DEBUG is not set/" .config

allnoconfig: $(CONFIG)/conf
	@mkdir -p $(CONFIG)/buildroot-config
	@KCONFIG_AUTOCONFIG=$(CONFIG)/buildroot-config/auto.conf \
		KCONFIG_AUTOHEADER=$(CONFIG)/buildroot-config/autoconf.h \
		$(CONFIG)/conf -n $(CONFIG_CONFIG_IN)

defconfig: $(CONFIG)/conf
	@mkdir -p $(CONFIG)/buildroot-config
	@KCONFIG_AUTOCONFIG=$(CONFIG)/buildroot-config/auto.conf \
		KCONFIG_AUTOHEADER=$(CONFIG)/buildroot-config/autoconf.h \
		$(CONFIG)/conf -d $(CONFIG_CONFIG_IN)

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

endif # ifeq ($(BR2_HAVE_DOT_CONFIG),y)

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
	@echo 'See docs/README and docs/buildroot.html for further details'
	@echo

.PHONY: dummy distclean clean config oldconfig \
	menuconfig defconfig help toolsclean toolsdirclean tools
	
