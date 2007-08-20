# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm multilib

MY_P=pam_krb5-${PV}
RH_EXTRAVERSION=1

S=${WORKDIR}/${MY_P}-${RH_EXTRAVERSION}

DESCRIPTION="pam_krb5 module, taken from fedora"
HOMEPAGE="http://fedora.redhat.com"
SRC_URI="mirror://fedora/development/source/SRPMS/${MY_P}-${RH_EXTRAVERSION}.src.rpm"
LICENSE="LGPL-2 BSD"
SLOT="0"

KEYWORDS="x86 amd64"

DEPEND="virtual/krb5
	>=sys-libs/pam-0.78-r2"

src_compile() {
	export CFLAGS="${CFLAGS} -fPIC"
	econf --libdir=/$(get_libdir) \
	    --with-default-use-shmem=sshd --with-default-external=sshd \
	    || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die
	dosym /$(get_libdir)/security/pam_krb5.so /$(get_libdir)/security/pam_krb5afs.so
	rm -f ${D}/$(get_libdir)/security/*.la

	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README TODO
}
