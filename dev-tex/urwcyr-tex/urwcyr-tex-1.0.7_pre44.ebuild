# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

MY_PN=urw-fonts

MY_PV=${PV/_/}
MY_P=${MY_PN}-${MY_PV}

TEX_PV="0.1.0.1"

DESCRIPTION="URW fonts cyrillized by Valek Filippov"
SRC_URI="ftp://ftp.gnome.ru/fonts/urw/release/${MY_P}.tar.bz2
	https://launchpad.net/urwcyr-tex/trunk/${TEX_PV}/+download/${PN}-${TEX_PV}.tar.bz2"
HOMEPAGE=""
KEYWORDS="x86 amd64"
LICENSE="GPL-3"
SLOT="0"

DEPEND="virtual/tex-base
	dev-lang/perl"

S="${WORKDIR}"

# For TeX fonts
SUPPLIER="public"
BUNDLE="urwcyr"

src_compile ()
{
	cd ${S}
	perl urwren.pl
	sed -ie "/system/s:,\":.\" :g" urwtfm.pl
	perl urwtfm.pl
	    
}

src_install ()
{
	dodir ${TEXMF}
	cp -R tex fonts ${D}${TEXMF}
	
        cd ${S}
	insinto ${TEXMF}/fonts/map/dvips/urwcyr
        doins ${S}/dvips/config/urwcyr.map || die "doins $i failed"

	insinto ${TEXMF}/fonts/enc/dvips/base
        doins ${S}/dvips/base/t2a.enc || die "doins $i failed"

	insinto ${TEXMF}/fonts/map/dvipdfm/context
	doins ${S}/dvipdfm/config/urwpdf.map || die "doins $i failed"

	# /etc/texmf/updmap.d/90urwcyr.cfg
	dodir /etc/texmf/updmap.d
	echo "# URW fonts cyrillized by Valek Filippov" > ${D}/etc/texmf/updmap.d/90urwcyr.cfg
	echo "Map urwcyr.map" >> ${D}/etc/texmf/updmap.d/90urwcyr.cfg
	
	cd ${S}
	dodoc license problem readme*
	cp ${S}/doc/urwcyr/* ${D}/usr/share/doc/${PF}
}


# Local Variables:
# mode: sh
# End:
