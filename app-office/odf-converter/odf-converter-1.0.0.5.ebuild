# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit rpm eutils versionator fdo-mime gnome2-utils

MY_PV=$(replace_version_separator 3 '-' )
MY_P=${PN}-${MY_PV}
DESCRIPTION="The OpenXML Translator provides support for opening and saving Microsoft OpenXML-formatted word processing documents (.docx) in OpenOffice.org."
HOMEPAGE="http://www.novell.com/"
SRC_URI="http://cdn.novell.com/free/ESrjfdE4U58~/${MY_P}.i586.rpm"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="gnome kde"

RDEPEND="|| ( >=app-office/openoffice-2.0 >=app-office/openoffice-bin-2.0 )"
DEPEND=""
S=${WORKDIR}

src_install() {
	exeinto /usr/$(get_libdir)/openoffice/program/
	doexe usr/lib/ooo-2.0/program/OdfConverter
	insinto /usr/$(get_libdir)/openoffice/
	doins -r usr/lib/ooo-2.0/share
	insinto /usr/
	use kde && doins -r opt/kde3/share
	use gnome && doins -r opt/gnome/share
	insinto /usr/share/mime/
	doins -r usr/share/mime/packages
	dodoc usr/share/doc/packages/odf-converter/*.TXT
	dosym /usr/$(get_libdir)/openoffice/program/OdfConverter /usr/bin/${PN}
}

pkg_postinst() {
	fdo-mime_desktop_database_update
        fdo-mime_mime_database_update
        use gnome && gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
        fdo-mime_mime_database_update
        use gnome && gnome2_icon_cache_update
}
