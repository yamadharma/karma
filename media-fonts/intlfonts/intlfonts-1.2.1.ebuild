# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/intlfonts/intlfonts-1.2.1.ebuild,v 1.11 2006/11/26 23:47:34 flameeyes Exp $

inherit font

IUSE="X bdf"

DESCRIPTION="International X11 fixed fonts"
HOMEPAGE="http://www.gnu.org/directory/intlfonts.html"
SRC_URI="ftp://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc s390 sh sparc x86 ~x86-fbsd"

FONT_SUFFIX="pcf"
if ( use bdf )
    then
    FONT_SUFFIX="${FONT_SUFFIX} bdf"
fi

src_compile() {
	cd ${S}
	econf --with-fontdir=/usr/share/fonts/pcf/public/${PN} || die
}

src_install() {
	make install fontdir=${D}/usr/share/fonts/pcf/public/${PN} || die
	find ${D}/usr/share/fonts/pcf/public/${PN} -name '*.pcf' | xargs gzip -9
	use bdf || rm -rf ${D}/usr/share/fonts/pcf/public/${PN}/bdf
	if ( use bdf )
	    then
	    mkdir -p ${D}/usr/share/fonts/bdf/public/${PN}
	    mv -f ${D}/usr/share/fonts/pcf/public/${PN}/bdf/* ${D}/usr/share/fonts/bdf/public/${PN}
	    rm -rf ${D}/usr/share/fonts/pcf/public/${PN}/bdf
	else
	    rm -rf ${D}/usr/share/fonts/pcf/public/${PN}/bdf
	fi	    
	dodoc ChangeLog NEWS README
	dodoc Emacs.ap
	for suffix in ${FONT_SUFFIX}; do
		set_FONTDIR ${suffix}
		font_xfont_config
		font_xft_config
		font_fontconfig
		font_fontpath_dir_config
	done
}
