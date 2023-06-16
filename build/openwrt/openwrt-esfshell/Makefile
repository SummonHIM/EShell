#
# This is free software, licensed under the GNU General Public License v3.0
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=esfshell
PKG_VERSION:=$(if $(value GITHUB_REF_NAME),$(value GITHUB_REF_NAME),master)
PKG_RELEASE:=$(if $(value GITHUB_RUN_NUMBER),$(value GITHUB_RUN_NUMBER),1)
PKG_MAINTAINER:=SummonHIM <summonhim@qq.com>
PKG_LICENSE:=GPL-3.0

ifneq ($(wildcard /artifacts),)
PKG_DIRECTORY:=/artifacts
else
PKG_DIRECTORY:=../..
endif

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=EsurfingShell
  PKGARCH:=all
  DEPENDS:=+bash +curl
endef

define Package/$(PKG_NAME)/description
Esurfing Campus Login Script Based on Bash Shell.
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/esfshell
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_DIRECTORY)/esfshell.sh $(1)/usr/bin/esfshell
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_DIRECTORY)/sample/openwrt-etc/init.d/esfshell $(1)/etc/init.d/esfshell
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) $(PKG_DIRECTORY)/sample/openwrt-etc/config/esfshell $(1)/etc/config/esfshell
endef

$(eval $(call BuildPackage,esfshell))