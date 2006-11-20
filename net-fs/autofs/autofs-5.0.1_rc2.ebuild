# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvs/root/autofs/gentoo/net-fs/autofs/autofs-5.0.0.ebuild,v 1.1 2006/03/30 02:09:51 raven Exp $

inherit eutils

IUSE="ldap"

MY_P=${P/_/-}

DESCRIPTION="Kernel based automounter"
HOMEPAGE="http://www.linux-consulting.com/Amd_AutoFS/autofs.html"
SRC_URI_BASE="mirror://kernel/linux/daemons/${PN}/v5"


SRC_PATCHES_URI=`while read patch  
    do 
    echo ${SRC_URI_BASE}/$patch 
done < ${FILESDIR}/patch_list-${PV}`

SRC_URI="${SRC_URI_BASE}/${MY_P}.tar.bz2
	    ${SRC_PATCHES_URI}"
DEPEND="virtual/libc
		ldap? ( >=net-nds/openldap-2.0 )"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~alpha ~ppc ~sparc amd64 ~ia64 ~ppc64"

S=${WORKDIR}/${P%%_*}

src_unpack() {
	unpack ${MY_P}.tar.bz2

	cd ${S}
	while read patch  
	    do 
	    epatch ${DISTDIR}/${patch}
	done < ${FILESDIR}/patch_list-${PV}

	cd ${S}
	autoconf || die "Autoconf failed"

	cd ${S}/daemon
#	sed -i 's/LIBS \= \-ldl/LIBS \= \-ldl \-lnsl \$\{LIBLDAP\}/' Makefile || die "LIBLDAP change failed"
}

src_compile() {
	local myconf
	use ldap || myconf="--without-openldap"

	myconf="${myconf} --with-mapdir=/etc/autofs"
	myconf="${myconf} --with-confdir=/etc/conf.d"

	econf ${myconf} || die
	sed -i -e '/^\(CFLAGS\|CXXFLAGS\|LDFLAGS\)[[:space:]]*=/d' Makefile.rules || die "Failed to remove (C|CXX|LD)FLAGS"
	emake || die "make failed"
}

src_install() {
	into /usr
	dosbin daemon/automount
	exeinto /usr/lib/autofs
	insopts -m 755
	doexe modules/*.so

	dodoc COPYING COPYRIGHT README* CHANGELOG CREDITS
	cd ${S}/samples
	docinto samples ; dodoc auto.misc auto.net auto.smb auto.master
	cd ${S}/patches
	docinto patches ; dodoc *.patch
	cd ${S}/man
#	sed -i 's:\/etc\/:\/etc\/autofs\/:g' *.8 *.5 *.in || die "Failed to update path in manpages"
	doman auto.master.5 autofs.5 autofs.8 automount.8

	dodir /etc/autofs /etc/init.d /etc/conf.d /var/run/autofs
	insopts -m 644
	insinto /etc/autofs ; doins ${FILESDIR}/auto.master
	insinto /etc/autofs ; doins ${FILESDIR}/auto.home
	insinto /etc/autofs ; doins ${FILESDIR}/auto.misc
	insinto /etc/autofs ; doins ${FILESDIR}/autofs_ldap_auth.conf
	insopts -m 755
	insinto /etc/autofs ; doins ${FILESDIR}/auto.smb
	exeinto /etc/autofs ; doexe ${FILESDIR}/auto.net # chmod 755 is important!

	exeinto /etc/init.d ; newexe ${FILESDIR}/autofs.init autofs
	insinto /etc/conf.d ; newins ${FILESDIR}/autofs.conf autofs
	if use ldap; then
		cd ${S}/samples
		docinto samples ; dodoc ldap* auto.master.ldap
		#insinto /etc/openldap/schema ; doins autofs.schema
		#exeinto /usr/lib/autofs ; doexe autofs-ldap-auto-master
	fi

	keepdir /var/run/autofs
}

pkg_postinst() {
	einfo "Note: If you plan on using autofs for automounting"
	einfo "remote NFS mounts without having the NFS daemon running"
	einfo "please add portmap to your default run-level."
	echo ""
	einfo "Also the normal autofs status has been renamed stats"
	einfo "as there is already a predefined Gentoo status"
}
