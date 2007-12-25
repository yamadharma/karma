# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PN="RutilT"
MY_P="${MY_PN}v${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Manage wireless interfaces, particularly Ralink devices"
HOMEPAGE="http://cbbk.free.fr/bonrom/"
SRC_URI="http://cbbk.free.fr/bonrom/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="gksu kdesu"

DEPEND=">=x11-libs/gtk+-2.6.0
	|| ( virtual/linux-sources sys-kernel/linux-headers )"
RDEPEND="${DEPEND}
	gksu? ( x11-libs/gksu )
	kdesu? ( kde-base/kdesu )"

src_compile() {
	if use gksu || use kdesu; then
		LAUNCHER=external
	else
		LAUNCHER=built-in
	fi
	./configure.sh --prefix=/usr --launcher="$LAUNCHER" \
		--kernel_sources=/usr/src/linux ${EXTRA_ECONF} \
		|| die "configure.sh failed"
	emake OPTIONS="${CFLAGS}" || die "emake failed"
}

src_install() {
	# need to fix Makefile to use DESTDIR
	emake install PREFIX="${D}/usr" || die "emake install failed"
	insinto /usr/share/applications; doins ${S}/${PN}.desktop
}
