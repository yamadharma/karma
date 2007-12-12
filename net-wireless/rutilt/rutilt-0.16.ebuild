# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-info gnome2-utils

MY_PN="RutilT"
MY_P="${MY_PN}v${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Manage wireless interfaces, particularly Ralink devices"
HOMEPAGE="http://cbbk.free.fr/bonrom/"
SRC_URI="http://cbbk.free.fr/bonrom/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="builtin-launcher debug gnome kde"

both_DEPEND=">=x11-libs/gtk+-2.6.0"
DEPEND="${both_DEPEND}
	dev-util/pkgconfig
	virtual/linux-sources"
RDEPEND="${both_DEPEND}
	gnome? ( x11-libs/gksu )
	kde? ( kde-base/kdesu )"

src_compile() {
	if use gnome || use kde; then
		LAUNCHER=external
	elif use builtin-launcher; then
		LAUNCHER=built-in
	else
		LAUNCHER=disabled
	fi
	./configure.sh --prefix=/usr \
		--launcher=${LAUNCHER} \
		--kernel_sources=${KERNEL_DIR} \
		$(use debug && echo "--debug") \
		${EXTRA_ECONF} \
		|| die "configure.sh failed"
	emake OPTIONS="${CFLAGS}" || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS README INSTALL
}

pkg_postinst() {
	if use gnome || use kde; then
		elog "Using external launcher."
	elif use builtin-launcher; then
		elog "Launcher will be installed setuid.  This may be a security risk."
	else
		elog "No launcher enabled.  You will need to run RutilT as root to "
		elog "connect to a wireless network."
	fi
	use gnome && gnome2_icon_cache_update
}
