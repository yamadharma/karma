# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ECLASS="openoffice-ext"
INHERITED="$INHERITED $ECLASS"

inherit eutils multilib

# list of extentions
# OOO_EXTENSIONS="" 
# list of extentions identifier (Openoffice view)
# OOO_EXTENSIONS_ID=""

add_extension() {
  echo -n "Adding extension $1..."
  INSTDIR=`mktemp -d`
  /usr/lib/openoffice/program/unopkg add --shared $1 \
    "-env:UserInstallation=file:///$INSTDIR" \
    "-env:JFW_PLUGIN_DO_NOT_CHECK_ACCESSIBILITY=1"
#     '-env:UNO_JAVA_JFW_INSTALL_DATA=$ORIGIN/../share/config/javasettingsunopkginstall.xml' \    
  if [ -n $INSTDIR ]; then rm -rf $INSTDIR; fi
  echo " done."
}

flush_unopkg_cache() {
    /usr/lib/openoffice/program/unopkg list --shared > /dev/null 2>&1
}

remove_extension() {
  if /usr/lib/openoffice/program/unopkg list --shared $1 >/dev/null; then
    echo -n "Removing extension $1..."
    INSTDIR=`mktemp -d`
    /usr/lib/openoffice/program/unopkg remove --shared $1 \
      "-env:UserInstallation=file://$INSTDIR" \
      "-env:JFW_PLUGIN_DO_NOT_CHECK_ACCESSIBILITY=1"
#       '-env:UNO_JAVA_JFW_INSTALL_DATA=$ORIGIN/../share/config/javasettingsunopkginstall.xml' \
    if [ -n $INSTDIR ]; then rm -rf $INSTDIR; fi
    echo " done."
    flush_unopkg_cache
  fi
}

openoffice-ext_src_install() {
	insinto /usr/$(get_libdir)/openoffice/share/extension/install
	for i in ${OOO_EXTENSIONS}
	do
		doins ${i}.oxt
	done
}

openoffice-ext_pkg_postinst() {
	for i in ${OOO_EXTENSIONS}
	do
		add_extension /usr/$(get_libdir)/openoffice/share/extension/install/${i}.oxt
	done

}

openoffice-ext_pkg_prerm() {
	for i in ${OOO_EXTENSIONS_ID}
	do
		remove_extension ${i}
	done
}

EXPORT_FUNCTIONS src_install pkg_postinst pkg_prerm

