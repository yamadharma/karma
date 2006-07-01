# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-libs/openssl/openssl-0.9.6e.ebuild,v 1.4 2002/08/14 04:57:22 murphy Exp $

S=${WORKDIR}/${P}
DESCRIPTION="SSL certs"
#SRC_URI="http://www.openssl.org/source/${P}.tar.gz"
#HOMEPAGE="http://www.openssl.org/"

RDEPEND="sys-devel/make"
DEPEND="${RDEPEND}"
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc sparc sparc64"

#src_unpack() {
#	unpack ${A} ; cd ${S}
#
#	patch -p1 < ${FILESDIR}/${P}-gentoo.diff
#	
#	cp Configure Configure.orig
#	sed -e "s/-O3/$CFLAGS/" -e "s/-m486//" Configure.orig > Configure
#}

#src_compile() {
#	./config --prefix=/usr --openssldir=/usr/share/ssl shared threads || die
#	# i think parallel make has problems
#	make all || die
#}

src_install() {

	#
	insinto /etc/ssl/certs
	doins ${FILESDIR}/share/certs/*
	dosym ./certs/ca-bundle.crt /etc/ssl/cert.pem
}
