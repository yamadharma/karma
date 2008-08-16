# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/heimdal/heimdal-0.7.2-r3.ebuild,v 1.14 2007/05/23 01:34:43 cardoe Exp $

WANT_AUTOMAKE=1.8
WANT_AUTOCONF=latest

inherit autotools libtool eutils virtualx toolchain-funcs flag-o-matic

PATCHVER=0.1
PATCH_P=${P}-gentoo-patches-${PATCHVER}

DESCRIPTION="Kerberos 5 implementation from KTH"
HOMEPAGE="http://www.h5l.org/"
SRC_URI="http://www.h5l.org/dist/src/${P}.tar.gz"

LICENSE="three clause BSD style license"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE="ssl berkdb ipv6 ldap X"

RDEPEND="ssl? ( dev-libs/openssl )
	berkdb? ( sys-libs/db )
	ldap? ( net-nds/openldap )
	sys-libs/cracklib
	sys-libs/e2fsprogs-libs
	!virtual/krb5"
DEPEND="${RDEPEND}"
PROVIDE="virtual/krb5"

src_unpack() {
	unpack ${A}
	cd "${S}"

	EPATCH_SUFFIX="patch" epatch "${FILESDIR}"/${PV}

	epatch "${FILESDIR}"/heimdal-1.1-ldapQA.patch
	epatch "${FILESDIR}"/heimdal-1.1-ldapQAplus.patch

	AT_M4DIR="cf" eautoreconf
}

src_compile() {
	local myconf=""

	if use ldap; then
		myconf="${myconf} --with-openldap=/usr"
		#append-flags -DLDAP_DEPRECATED=1
	fi

	econf \
		$(use_with ipv6) \
		$(use_with berkdb berkeley-db) \
		$(use_with ssl openssl) \
		$(use_with X x) \
		--disable-krb4 \
		--enable-kcm \
		--enable-shared \
		--enable-netinfo \
		--enable-pthread-support \
		--libexecdir=/usr/sbin \
		--includedir=/usr/include/heimdal \
		${myconf} || die "econf failed"

	emake || die "emake failed"
}

src_test() {
	addpredict /proc/fs/openafs/afs_ioctl
	addpredict /proc/fs/nnpfs/afs_ioctl

	if use X ; then
		KRB5_CONFIG="${S}"/krb5.conf Xmake check || die
	else
		KRB5_CONFIG="${S}"/krb5.conf make check || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	#dolib lib/kadm5/sample_passwd_check.so

	dodoc ChangeLog README NEWS TODO

	# Begin client rename and install
	for i in {telnetd,ftpd,rshd}
	do
		mv "${D}"/usr/share/man/man8/{,k}${i}.8
		mv "${D}"/usr/sbin/{,k}${i}
	done

	for i in {rcp,rsh,telnet,ftp,su,login}
	do
		mv "${D}"/usr/share/man/man1/{,k}${i}.1
		mv "${D}"/usr/bin/{,k}${i}
	done

	mv "${D}"/usr/share/man/man5/{,k}ftpusers.5
	mv "${D}"/usr/share/man/man5/{,k}login.access.5

	# Create symlinks for the includes
	dosym heimdal/krb5-types.h /usr/include/krb5-types.h
	dosym heimdal/krb5.h /usr/include/krb5.h
	dosym heimdal/asn1_err.h /usr/include/asn1_err.h
	dosym heimdal/krb5_asn1.h /usr/include/krb5_asn1.h
	dosym heimdal/krb5_err.h /usr/include/krb5_err.h
	dosym heimdal/heim_err.h /usr/include/heim_err.h
	dosym heimdal/k524_err.h /usr/include/k524_err.h
	dosym heimdal/krb5-protos.h /usr/include/krb5-protos.h
	
	dosym heimdal/gssapi /usr/include/gssapi
	dosym heimdal/gssapi/gssapi.h /usr/include/gssapi.h

	# Hacky symlinks for silly old SASL checks
	dosym . /usr/include/heimdal/include
	dosym /usr/lib /usr/include/heimdal/lib

	doinitd "${FILESDIR}"/configs/heimdal-kdc
	doinitd "${FILESDIR}"/configs/heimdal-kadmind
	doinitd "${FILESDIR}"/configs/heimdal-kpasswdd
	doinitd "${FILESDIR}"/configs/heimdal-kcm

	insinto /etc
	newins "${FILESDIR}"/configs/krb5.conf krb5.conf.example

	sed -i "s:/lib:/$(get_libdir):" "${D}"/etc/krb5.conf.example || die "sed failed"

	if use ldap; then
		insinto /etc/openldap/schema
		doins "${FILESDIR}"/configs/krb5-kdc.schema
	fi

	# default database dir
	keepdir /var/heimdal
}
