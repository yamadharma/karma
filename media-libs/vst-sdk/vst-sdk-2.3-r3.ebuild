# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# install proprietary Steinberg VST SDK 2.3 to "/opt/${MY_P}"
# bug #61290

inherit eutils

RESTRICT="nostrip fetch"

DESCRIPTION="Steinberg VST Plug-Ins SDK 2.3 - win32"
HOMEPAGE="http://ygrabit.steinberg.de/~ygrabit/public_html"
IUSE="doc"

SRC_URI="vstsdk${PV}.zip"

LICENSE="STEINBERG SOFT-UND HARDWARE GMBH"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="app-arch/unzip"

BASE="/opt"
S="${WORKDIR}/${MY_P}"
MY_P="${P//-/}"

pkg_nofetch() {
	einfo "Please go to ${HOMEPAGE}"
	einfo " or http://www.steinberg.de/532+M52087573ab0.html"
	einfo "- Look for a link called: VST Plug-Ins SDK.."
	einfo "- Download the VST-SDK for version ${PV}" 
	einfo "- Extract the archive and put the inner archive ${A}"
	einfo "  into: ${DISTDIR}"
	einfo
	einfo "If above Homepage no longer provide ${A}"
	einfo "You can try to search for ${A} with e.g. google"
	einfo 
	einfo "Please redigest your ebuild if you get digest errors:"
	einfo "ebuild ${EBUILD} digest"
	einfo
}

src_unpack() {
	unpack ${MY_P}.zip || die
	sed -e :a -e 's/<[^>]*>//g;/</N;//ba' ${S}/VST\ Licensing\ Agreement.html > ${S}/VST_Licensing_Agreement.txt
	check_license "${S}/VST_Licensing_Agreement.txt"
	rm -f "${S}/VST_Licensing_Agreement.txt"
	find -type d -name 'CVS' -exec rm -rf {} \;
	find -type f -exec chmod 0644 {} \;
	find -type d -exec chmod 0755 {} \;
}

src_compile() {
	einfo "nothing to compile :)"
}

include_path="/usr/include/vst"
src_install() {
	header_path="source/common"
		
	use doc && dodir "${BASE}"
	dodir "${include_path}"
	mv ${S}/${header_path}/* ${D}/"${include_path}"
	rmdir "${header_path}"
	use doc && mv "${S}/" "${D}/${BASE}"
	use doc && dosym  "${include_path}" "${BASE}/${MY_P}/${header_path}"
	if use !doc ;then
		dodir "${BASE}/${MY_P}"
		mv ${S}/*Licensing\ Agreement* "${D}/${BASE}/${MY_P}"
	fi
	fowners -R root:root . 

}

pkg_postinst() {
	echo
	einfo "Finished installing Steinberg VST Plug-Ins SDK  into"
	einfo "${BASE}/${MY_P} and headers here: ${include_path}"
	einfo "DO NOT IGNORE THE IMPLICATIONS OF THIS LICENSE"
	einfo "${BASE}/${MY_P}/VST Licensing Agreement.html"
	einfo "${BASE}/${MY_P}/VST licensing agreement.rtf"
}
