# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/xxe/xxe-2.11.ebuild,v 1.2 2005/08/23 17:50:39 flameeyes Exp $

MY_PV="${PV/./}"
MY_PV="${MY_PV/_p/p}"
S="${WORKDIR}/${PN}-std-${MY_PV}"
DESCRIPTION="The XMLmind XML Editor"
SRC_URI="http://www.xmlmind.net/xmleditor/_download/${PN}-std-${MY_PV}.tar.gz
	doc?	http://www.xmlmind.net/xmleditor/_download/${PN}-devdocs-${MY_PV}.tar.gz
	!minimal? ( http://www.xmlmind.net/xmleditor/_download/batik_imagetoolkit-${MY_PV}.tar.gz
	http://www.xmlmind.net/xmleditor/_download/jimi_imagetoolkit-${MY_PV}.tar.gz
	http://www.xmlmind.net/xmleditor/_download/apt_format-${MY_PV}.tar.gz
	http://www.xmlmind.net/xmleditor/_download/javadoc_format-${MY_PV}.tar.gz )"
HOMEPAGE="http://www.xmlmind.com/xmleditor/index.html"
IUSE="doc minimal"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~ppc amd64"

RESTRICT="nostrip nomirror"
RDEPEND=">=virtual/jre-1.4.1"
DEPEND=""
INSTALLDIR=/opt/${PN}

src_install() {
	dodir ${INSTALLDIR}
	cp -pPR ${S}/* ${D}/${INSTALLDIR}

	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}" > ${D}/etc/env.d/10xxe

	insinto /usr/share/applications
	doins ${FILESDIR}/xxe.desktop
	
	if ( use doc )
	    then
	    dodir /usr/share/doc/${PF}
	    cp -R ${WORKDIR}/doc/* ${D}/usr/share/doc/${PF}
	fi
	
	if ( ! use minimal )
	    then
	    for i in batik_imagetoolkit jimi_imagetoolkit apt_format javadoc_format
		do
		cp -R ${WORKDIR}/$i ${D}/opt/xxe/addon
	    done
	fi
}

pkg_postinst() {
	einfo
	einfo "XXE has been installed in /opt/xxe, to include this"
	einfo "in your path, run the following:"
	eerror "    /usr/sbin/env-update && source /etc/profile"
	einfo
	ewarn "If you need special/accented characters, you'll need to export LANG"
	ewarn "to your locale.  Example: export LANG=es_ES.ISO8859-1"
	ewarn "See http://www.xmlmind.com/xmleditor/user_faq.html#linuxlocale"
	einfo
}
