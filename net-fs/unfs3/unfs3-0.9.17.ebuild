# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="NFS client and server daemons"
HOMEPAGE="http://nfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ~ppc ~ppc64 s390 sh ~sparc x86"
IUSE=""

RDEPEND=">=net-nds/portmap-5b-r6"

DEPEND="${RDEPEND}"

#src_unpack() {
#	unpack ${P}.tar.gz
#	cd "${S}"
#	epatch "${DISTDIR}"/nfs-utils-${PV}-CITI_NFS4_ALL-${PATCH_V}.dif
#	epatch "${FILESDIR}"/${PN}-1.0.7-man-pages.patch #107991
#	epatch "${FILESDIR}"/${P}-uts-release.patch
#}

src_compile() {
	econf \
	    --enable-cluster \
	    || die "Configure failed"

	emake || die "Failed to compile"
}

src_install() {
	make DESTDIR="${D}" install || die

	# Don't overwrite existing xtab/etab, install the original
	# versions somewhere safe...  more info in pkg_postinst
#	dodir /usr/lib/nfs
#	keepdir /var/lib/nfs/{sm,sm.bak}
#	mv "${D}"/var/lib/nfs/* "${D}"/usr/lib/nfs
#	keepdir /var/lib/nfs

	# Install some client-side binaries in /sbin
#	dodir /sbin
#	mv "${D}"/usr/sbin/rpc.{lockd,statd} "${D}"/sbin/

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
