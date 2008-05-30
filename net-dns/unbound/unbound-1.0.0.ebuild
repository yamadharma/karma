# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Validating, recursive, and caching DNS resolver"
HOMEPAGE="http://unbound.net"
SRC_URI="http://unbound.net/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug libevent static threads"

RDEPEND="dev-libs/openssl
		libevent? ( dev-libs/libevent )"
#		ldns? ( >=net-dns/ldns-1.3.0 )"

DEPEND="${RDEPEND}
		sys-devel/flex
		app-doc/doxygen"

pkg_setup() {
	ebegin "Creating unbound group and user"
	enewgroup unbound 53
	enewuser unbound 53 -1 /etc/unbound unbound
	eend ${?}
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${PV}-config.patch" || die "patch failed"
}

src_compile() {
	econf $(use_enable debug) \
		$(use_enable debug lock-checks) \
		$(use_enable debug alloc-checks) \
		$(use_enable static static-exe) \
		$(use_with libevent) \
		$(use_with threads pthreads) || die "econf failed"
#		$(use_with ldns) \
#	use ldns || emake -C ldns-src/ldns-1.3.0_pre_20080229
	use ldns || emake -C ldns-src/ldns-1.3.0_pre_20080229
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "einstall failed"
	newinitd "${FILESDIR}/unbound.initd" unbound
	dodoc doc/README doc/CREDITS doc/TODO doc/Changelog doc/FEATURES
	dodoc doc/ietf67-design-02.odp doc/ietf67-design-02.pdf
	dodoc doc/requirements.txt doc/plan
	dodoc doc/example.conf
	doman doc/libunbound.3 doc/unbound-checkconf.8
	doman doc/unbound-host.1 doc/unbound.8 doc/unbound.conf.5
}
