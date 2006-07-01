# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/sys-devel/gettext/gettext-0.12.1.ebuild,v 1.1 2003/07/14 13:10:49 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GNU locale utilities"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/gettext/gettext.html"
IUSE="nls"
DEPEND="virtual/glibc"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~arm ~mips"

src_compile() {
	local myconf=""
	use nls || myconf="--disable-nls"

	econf \
		--disable-shared \
		--with-included-gettext \
		${myconf} || die

	# Doesn't work with emake
	make || die
}

src_install() {
	einstall \
		lispdir=${D}/usr/share/emacs/site-lisp \
		docdir=${D}/usr/share/doc/${PF}/html \
		|| die

	exeopts -m0755
	exeinto /usr/bin
	doexe misc/gettextize

	#glibc includes gettext; this isn't needed anymore
	rm -rf ${D}/usr/include
	rm -rf ${D}/usr/lib/*.{a,so}

	#again, installed by glibc
	rm -rf ${D}/usr/share/locale/locale.alias

	if [ -d ${D}/usr/doc/gettext ]
	then
		mv ${D}/usr/doc/gettext ${D}/usr/share/doc/${PF}/html
		rm -rf ${D}/usr/doc
   	fi

	dodoc AUTHORS BUGS COPYING ChangeLog DISCLAIM NEWS README* THANKS TODO
}

