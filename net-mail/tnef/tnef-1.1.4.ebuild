# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-mail/tnef/tnef-1.1.4.ebuild,v 1.2 2003/02/13 14:42:50 vapier Exp $

DESCRIPTION="Decodes MS-TNEF MIME attachments"
SRC_URI="mirror://sourceforge/tnef/${P}.tar.gz"
HOMEPAGE="http://world.std.com/~damned/software.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc"

DEPEND="virtual/glibc"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	rm -rf ${D}/usr/man
	dodoc AUTHORS BUGS ChangeLog COPYING NEWS README TODO
	doman doc/tnef.1
}
