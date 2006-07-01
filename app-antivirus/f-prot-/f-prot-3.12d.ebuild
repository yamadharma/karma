# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-mail/f-prot/f-prot-3.12a.ebuild,v 1.4 2002/08/14 12:05:25 murphy Exp $

MY_P=fp-linux-sb-${PV}
S=${WORKDIR}/${PN}
DESCRIPTION="Frisk Software's f-prot virus scanner"
HOMEPAGE="http://www.f-prot.com/"
SRC_URI="ftp://ftp.f-prot.com/pub/linux/${MY_P}.tar.gz"

# unzip and wget are needed for the check-updates.sh script
RDEPEND=">=app-arch/unzip-5.42-r1
	>=net-misc/wget-1.8.2"

SLOT="0"
LICENSE="F-PROT"
KEYWORDS="x86 sparc sparc64"

src_unpack () {

	unpack ${A}
	cd ${S}
	pwd
	patch -p0 < ${FILESDIR}/patch/${PV}/path.diff

}

src_compile () {
    echo "Nothing to compile."
}

src_install () {
    doman man8/*.8
    dodoc LICENSE CHANGES INSTALL* README

    dodir /opt/f-prot /opt/f-prot/tmp
    insinto /opt/f-prot
    insopts -m 755
    doins f-prot f-prot.sh check-updates.sh checksum
    insopts -m 644
    doins *.DEF ENGLISH.TX0
}
