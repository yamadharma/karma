# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=pam-krb5-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="pam_krb5 module by Russ Allbery"
HOMEPAGE="http://www.eyrie.org/~eagle/software/pam-krb5"
SRC_URI="http://archives.eyrie.org/software/kerberos/${MY_P}.tar.gz"

LICENSE="as-is"
KEYWORDS="x86 amd64"

DEPEND="virtual/krb5
	>=sys-libs/pam-0.78-r2"

src_compile() {
#	export CFLAGS="${CFLAGS} -fPIC"
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make prefix=${D} mandir=${D}/usr/share/man install || die

	dodoc CHANGES* COPYRIGHT NEWS README TODO
}
