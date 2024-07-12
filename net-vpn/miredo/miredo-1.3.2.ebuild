# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info systemd

DESCRIPTION="Miredo is an open-source Teredo IPv6 tunneling software"
HOMEPAGE="http://www.remlab.net/miredo/"
SRC_URI="https://gitlab.com/rindeal-ns/abandonware/miredo/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+caps +client nls +assert judy"

RDEPEND="sys-apps/iproute2
	dev-libs/judy
	caps? ( sys-libs/libcap )
	judy? ( dev-libs/judy )
	acct-user/miredo
	acct-group/miredo"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

CONFIG_CHECK="~IPV6 ~TUN" #318777

#tries to connect to external networks (#339180)
RESTRICT="test"

DOCS=( AUTHORS NEWS README TODO THANKS )

src_prepare() {
	default

	# the following step is normally done in `autogen.sh`
	cp "${EPREFIX}"/usr/share/gettext/gettext.h "${S}"/include

	eautoreconf
}

src_configure() {
	econf \
		--enable-miredo-user=miredo \
		--with-runstatedir=/run \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)" \
		$(use_enable assert) \
		$(use_with caps libcap) \
		$(use_enable client teredo-client) \
		$(use_enable nls) 
}

src_install() {
	default
	prune_libtool_files

	insinto /etc/miredo
	doins misc/miredo-server.conf
}

