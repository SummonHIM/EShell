#
# This is free software, licensed under the GNU General Public License v3.0
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=esfshell
PKG_VERSION:=$(if $(value GITHUB_REF_NAME),$(value GITHUB_REF_NAME),master)
PKG_RELEASE:=$(if $(value GITHUB_RUN_NUMBER),$(value GITHUB_RUN_NUMBER),1)

PKG_SOURCE:=$(PKG_VERSION).tar.gz
PKG_SOURCE_GITTYPE:=$(if $(value GITHUB_REF_NAME),tags,heads)
PKG_SOURCE_URL:=https://github.com/SummonHIM/EsurfingShell/archive/refs/$(PKG_SOURCE_GITTYPE)/
PKG_HASH:=skip

TAR_DIR:=$(BUILD_DIR)/EsurfingShell-$(PKG_VERSION)

PKG_MAINTAINER:=SummonHIM <summonhim@qq.com>
PKG_LICENSE:=GPL-3.0

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
	$(INSTALL_BIN) $(TAR_DIR)/esfshell.sh $(1)/usr/bin/esfshell
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(TAR_DIR)/sample/openwrt-etc/init.d/esfshell $(1)/etc/init.d/esfshell
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) $(TAR_DIR)/sample/openwrt-etc/config/esfshell $(1)/etc/config/esfshell
endef

$(eval $(call BuildPackage,esfshell))