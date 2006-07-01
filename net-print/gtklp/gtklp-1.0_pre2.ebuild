# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit libtool

DESCRIPTION="A GUI for cupsd"
SRC_URI="mirror://sourceforge/gtklp/${P/_/}.src.tar.gz"
HOMEPAGE="http://gtklp.sourceforge.net"

SLOT="0"
KEYWORDS="x86 ~ppc ~sparc"
LICENSE="GPL-2"
IUSE="nls ssl gtk2"

DEPEND="gtk2? ( >=x11-libs/gtk+-2 )
	!gtk2? ( =x11-libs/gtk+-1.2* )
	>=net-print/cups-1.1.10
	nls? ( sys-devel/gettext )
	ssl? ( dev-libs/openssl )"

S=${WORKDIR}/${P/_/}

src_compile () 
{
	elibtoolize

	local myconf

	# nls fix
	sed -i -e "s:#include <cups/language.h>:#ifndef _LOCALE_H\n#define _LOCALE_H\n#endif\n#include <cups/language.h>:" libgtklp/libgtklp.h
	
	use gtk2 \
		|| myconf="${myconf} --enable-gtk1"
	    
	use nls \
		&& myconf="${myconf} --enable-nls" \
		|| myconf="${myconf} --disable-nls"

	use ssl \
		&& myconf="${myconf} --enable-ssl" \
		|| myconf="${myconf} --disable-ssl"

	econf ${myconf} || die "configure failed"
	emake || die "parallel make failed"
}

src_install () 
{
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog README NEWS TODO KNOWN_BUGS

	use nls || rm -rf ${D}/usr/share/locale
}
