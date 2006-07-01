# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/eximstate/eximstate-1.1.ebuild,v 1.2 2005/12/22 19:23:05 egore Exp $

DESCRIPTION="monitors the size of the queue on an Exim mail server"
HOMEPAGE="http://www.olliecook.net/projects/eximstate/"
SRC_URI="${HOMEPAGE}releases/${P}.tar.gz"

KEYWORDS="~x86 ~sparc"
SLOT="0"
LICENSE="GPL-2"

DEPEND="rrdtool"
IUSE=""
PROVIDE=""

src_compile() {
	#if [ "$EXIMSTATE_OPTS" == "server" ] ; then
	#	myconf="--with-rrdtool"
	#else
	#	myconf=" --without-server"
	#fi
	myconf="--with-rrdtool"

	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var/eximstate \
		${myconf} || die "configure failed"

	emake || die "compile problem"
}

src_install() {
	emake -e DESTDIR=${D} install || die "emake install failed"
}

