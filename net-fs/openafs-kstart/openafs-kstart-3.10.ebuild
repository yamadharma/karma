# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="kerberos-ticket refresher for running services on data in afs"
HOMEPAGE="http://www.eyrie.org/~eagle/software/kstart/"
SRC_URI="http://ftp.debian.org/debian/pool/main/k/kstart/kstart_${PV}.orig.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="net-fs/openafs
		virtual/krb5"
RDEPEND="${DEPEND}"

S="${WORKDIR}/kstart-${PV}"

src_compile() {
	einfo ${S}
	cd ${S}
	econf --disable-k4start --with-aklog=/usr/bin/aklog || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "could not install"
	dobin k5start krenew
	dodoc README NEWS
}

