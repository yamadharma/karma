# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nam/nam-1.11-r1.ebuild,v 1.1 2007/03/18 16:57:03 cedk Exp $

EAPI="4"

inherit eutils

NS_ALLINONE_PV=2.35-RC7

DESCRIPTION="Network Simulator GUI for NS"
HOMEPAGE="http://www.isi.edu/nsnam/nam"
#SRC_URI="mirror://sourceforge/nsnam/${PN}-src-${PV}.tar.gz"
SRC_URI="http://www.isi.edu/nsnam/dist/release/ns-allinone-${NS_ALLINONE_PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="debug"
DEPEND="|| ( x11-libs/libXmu virtual/x11 )
	>=dev-lang/tcl-8.5
	>=dev-lang/tk-8.5
	>=dev-tcltk/otcl-1.14
	>=dev-tcltk/tclcl-1.20
	debug? ( dev-tcltk/tcl-debug )"
RDEPEND=">=net-analyzer/ns-2.27
	${DEPEND}"

S=${WORKDIR}/ns-allinone-${NS_ALLINONE_PV}/${P}

src_compile() {
	local tclver=$(best_version ">=dev-lang/tcl-8.5")
	einfo "Using ${tclver}"

	local tkver=$(best_version ">=dev-lang/tk-8.5")
	einfo "Using ${tkver}"

	econf \
		--mandir=/usr/share/man \
		--enable-release \
		--with-tcl-ver=${tclver:13} \
		--with-tk-ver=${tkver:12} \
		$(use_enable debug) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	dodir /usr/bin
	emake DESTDIR="${D}" install || die "emake install failed"

	doman nam.1

	dohtml CHANGES.html TODO.html
	dodoc FILES VERSION README
	for i in iecdemos edu ex; do
		docinto ${i}
		dodoc ${i}/*
	done
}
