# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

FONT_SUPPLIER="urwcyr"
FONT_BUNDLE="base35"

IUSE="tetex"

inherit font latex-package


MY_PN=urw-fonts

MY_PV=${PV/_/}
MY_P=${MY_PN}-${MY_PV}

TEX_PV="01c"

DESCRIPTION="URW fonts cyrillized by Valek Filippov"
SRC_URI="ftp://ftp.gnome.ru/fonts/urw/release/${MY_P}.tar.bz2
	tetex? ( ftp://ftp.gnome.ru/fonts/urw/urw-TeX-${TEX_PV}.tbz2 )"
HOMEPAGE=""
KEYWORDS="x86 amd64"
LICENSE="GPL-2,LGPL,LPPL-1.2"
SLOT="0"

DEPEND="virtual/tetex
	dev-lang/perl"

S="${WORKDIR}"

FONT_FORMAT="type1"

FONT_SUFFIX="afm pfb"

FONT_S="${S}"

# For TeX fonts
SUPPLIER="public"
BUNDLE="urwcyr"

src_unpack ()
{
	unpack ${A}
	cd ${S}
	tar xjvf ${FILESDIR}/urw-tex-ot1.tar.bz2
}

src_compile ()
{
	if ( use tetex )
	then
    	    cd ${S}
    	    ./build.sh

	    cd ${S}/dvips/config
	    mv -f urw-cm-super-t1.map urw-t1.map
	    mv -f urw-cm-super-t2a.map urw-t2a.map

	    cd ${S}/tex/latex/urwcyr
	    for fd in ot1*.fd; do
		cp $fd $(echo $fd|sed -e "s/^o//")
	    done

	    for fd in t1*.fd; do
		sed -i -e "s/[oO]\([tT]1\)/\1/" $fd
	    done
	fi
}

src_install ()
{
	font_src_install

	if ( use tetex )     
	then
	    cd ${S}
	    
	    for each in tex/latex/urwcyr fonts/afm/public/urwcyr fonts/tfm/public/urwcyr fonts/type1/public/urwcyr
	    do
		cd ${S}
		cd $each
		latex-package_src_install
	    done
	    
	    cd ${S}
	    insinto ${TEXMF}/fonts/map/dvips/urwcyr
	    doins ${S}/dvips/config/urw-t1.map || die "doins failed"
	    doins ${S}/dvips/config/urw-t2a.map || die "doins failed"
#	    doins ${S}/dvips/config/urwcyr.map || die "doins $i failed"
#
	    insinto ${TEXMF}/fonts/map/dvipdfm/context
	    doins ${S}/dvipdfm/config/urwpdf.map || die "doins $i failed"

	    # /etc/texmf/updmap.d/90urwcyr.cfg
	    dodir /etc/texmf/updmap.d
	    echo "# URW fonts cyrillized by Valek Filippov" > ${D}/etc/texmf/updmap.d/90urwcyr.cfg
	    echo "Map urw-t1.map" >> ${D}/etc/texmf/updmap.d/90urwcyr.cfg
	    echo "Map urw-t2a.map" >> ${D}/etc/texmf/updmap.d/90urwcyr.cfg
	
	    cd ${S}
	    dodoc license problem readme
	    cp ${S}/doc/urwcyr/* ${D}/usr/share/doc/${PF}
	fi
}


# Local Variables:
# mode: sh
# End:
