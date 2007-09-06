# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Userspace NFSv3 server daemon"
HOMEPAGE="http://unfs3.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ~ppc ~ppc64 s390 sh ~sparc x86"
IUSE=""

RDEPEND=">=net-nds/portmap-5b-r6"

DEPEND="${RDEPEND}"

src_compile() {
	econf \
	    --enable-cluster \
	    || die "Configure failed"

	emake || die "Failed to compile"
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc ChangeLog README* NEWS LICENSE CREDITS
	dodoc doc/*
	cp -R contrib ${D}/usr/share/doc/${PF}
	
	insinto /etc
	doins "${FILESDIR}"/exports

	newinitd "${FILESDIR}"/unfsd.initd unfsd
}

pkg_preinst() {
	if [[ -s ${ROOT}/etc/exports ]] ; then
		rm -f "${IMAGE}"/etc/exports
	fi
}
