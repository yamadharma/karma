# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PV="${PV//./_}"
MY_PV="${MY_PV/_p/p}"
S="${WORKDIR}/${PN}-perso-${MY_PV}"

ADDON_LIST="batik_imagetoolkit jimi_imagetoolkit jeuclid_imagetoolkit"
ADDON_LIST="${ADDON_LIST} dav_vdrive ftp_vdrive"
ADDON_LIST="${ADDON_LIST} sample_customize_xxe"
ADDON_LIST="${ADDON_LIST} xxe_config_pack"
ADDON_LIST="${ADDON_LIST} dita_dtd_config mathml_config sdocbook_config slides_config wxs_config"
ADDON_LIST="${ADDON_LIST} xep_foprocessor xfc_foprocessor fop1_foprocessor"

# ADDON_LIST="${ADDON_LIST} javadoc_format zip_vdrive"
# ADDON_LIST="${ADDON_LIST} xxe_addon_config xxe_configuration_config xxe_gui_config xxe_spreadsheet_functions_config"
# ADDON_LIST="${ADDON_LIST} fop_foprocessor  wxs_config"
# ADDON_LIST="${ADDON_LIST} custom_docbook_config docbook5_plus_include"

# docbook5_config docbook5xi_config

LANGS="de es fr"

for X in ${LANGS}
do
	IUSE="${IUSE} linguas_${X}"
done

for i in ${ADDON_LIST}
do
    SRC_URI_ADDON="${SRC_URI_ADDON} http://www.xmlmind.net/xmleditor/_download/${i}-${MY_PV}.zip"
done

SRC_URI="http://www.xmlmind.net/xmleditor/_download/${PN}-perso-${MY_PV}.tar.gz
	doc? ( http://www.xmlmind.net/xmleditor/_download/${PN}-devdocs-${MY_PV}.tar.gz )
	!minimal? ( ${SRC_URI_ADDON} )"

for Y in ${LANGS1}  
do
	SRC_URI="${SRC_URI} linguas_${Y}? ( http://www.xmlmind.net/xmleditor/_download/${Y}_dictionary-${MY_PV}.zip )"
done

SRC_URI="${SRC_URI} linguas_de? ( http://www.xmlmind.net/xmleditor/_download/de-alt_dictionary-${MY_PV}.zip )"
SRC_URI="${SRC_URI} linguas_fr? ( http://www.xmlmind.net/xmleditor/_download/fr_translation-${MY_PV}.zip )"

DESCRIPTION="The XMLmind XML Editor"
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
	    mv ${D}/${INSTALLDIR}/doc/* ${D}/usr/share/doc/${PF}
	fi
	rm -rf ${D}/${INSTALLDIR}/doc
	
	if ( ! use minimal )
	    then
	    for i in ${ADDON_LIST}
		do
		cp -R ${WORKDIR}/$i ${D}/opt/xxe/addon
	    done
	fi
# apt_format	
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
