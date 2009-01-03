# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils multilib autotools

DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"
SRC_URI="http://jackaudio.org/downloads/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="3dnow altivec alsa celt coreaudio cpudetection dbus doc debug examples ieee1394 mmx netjack oss sse freebob"

RDEPEND="
	>=media-libs/libsndfile-1.0.0
	sys-libs/ncurses
	celt? ( >=media-libs/celt-0.5.0 )
	dbus? ( sys-apps/dbus )
	alsa? ( >=media-libs/alsa-lib-0.9.1 )
	freebob? ( sys-libs/libfreebob )
	ieee1394? ( media-libs/libffado )
	netjack? ( media-libs/libsamplerate )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	if use dbus; then
		epatch "${FILESDIR}/${P}-dbus.patch"
		epatch "${FILESDIR}/${P}-dbus_as-needed.patch"
		eautoreconf
	fi
}

src_compile() {
	# building docs isn't configureable anymore, they are build if doxygen is
	# installed
	local myconf="--with-html-dir=/usr/share/doc/${PF}"

	if use dbus; then
		myconf="${myconf} --enable-dbus --enable-pkg-config-dbus-service-dir"
	fi

	# CPU Detection (dynsimd) uses asm routines which requires 3dnow, mmx and sse.
	if use cpudetection && use 3dnow && use mmx && use sse ; then
		einfo "Enabling cpudetection (dynsimd). Adding -mmmx, -msse, -m3dnow and -O2 to CFLAGS."
		myconf="${myconf} --enable-dynsimd"
		append-flags -mmmx -msse -m3dnow -O2
	fi

	use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	econf \
		$(use_enable freebob) \
		$(use_enable ieee1394 firewire) \
		$(use_enable altivec) \
		$(use_enable alsa) \
		$(use_enable coreaudio) \
		$(use_enable debug) \
		$(use_enable mmx) \
		$(use_enable oss) \
		$(use_enable sse)  \
		--disable-dependency-tracking \
		--with-default-tmpdir=/dev/shm \
		${myconf} || die "configure failed"
	emake || die "compilation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS TODO README

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r "${S}/example-clients"
	fi
}
