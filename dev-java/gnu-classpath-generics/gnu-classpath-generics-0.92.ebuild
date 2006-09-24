# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2

MY_P="classpath-${PV}-generics"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Free core class libraries for use with virtual machines and compilers for the Java programming language"
SRC_URI="ftp://ftp.gnu.org/gnu/classpath/${MY_P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/classpath"

LICENSE="GPL-2-with-linking-exception"
KEYWORDS="amd64 ~ppc x86"
SLOT="0"
IUSE="alsa debug dssi examples gconf gtk xml"

# Add the doc use flag after the upstream build system is improved
# See their bug 24025

RDEPEND=">=virtual/jdk-1.4
	!dev-java/gnu-classpath
	alsa? ( media-libs/alsa-lib )
	dssi? ( >=media-libs/dssi-0.9 )
	gtk? ( >=x11-libs/gtk+-2.8
		>=dev-libs/glib-2.10
		>=x11-libs/cairo-1.2.2
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXtst )
	gconf ( >=gnome-base/gconf-2.14 )
	xml? ( >=dev-libs/libxml2-2.6.8 >=dev-libs/libxslt-1.1.11 )"
DEPEND="app-arch/zip
	dev-java/gcj-jdk
	gtk? ( x11-libs/libXrender
		x11-proto/xextproto
		x11-proto/xproto )
	${RDEPEND}"

pkg_setup() {
	java-pkg-2_pkg-setup

	[[ "$(java-config -f)" =~ "gcj-jdk" ]] \
		|| die "gcj-jdk required!"

	ewarn "If you see this package failing with something like: \"double out of range\""
	ewarn "in the ecj error message you lost!"
	ewarn
	ewarn "You hit this gcc bug:"
	ewarn "http://gcc.gnu.org/bugzilla/show_bug.cgi?id=28096"
}

src_compile() {
	local compiler="--with-ecj=javac"

# disabled for now... see above.
#		$(use_with   doc   gjdoc) \
	econf ${compiler} \
		--includedir=/usr/include/classpath \
		--enable-jni \
		--disable-plugin \
		--disable-dependency-tracking \
		$(use_enable alsa) \
		$(use_enable cairo gtk-cairo) \
		$(use_enable debug) \
		$(use_enable examples) \
		$(use_enable gtk gtk-peer) \
		$(use_enable gconf gconf-peer) \
		$(use_enable xml xmlj) \
		$(use_enable dssi) \
		|| die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS BUGS ChangeLog* HACKING NEWS README THANKYOU TODO

	rm -fr ${D}/usr/bin/
	rm -f ${D}/usr/lib/security/classpath.security
	rm -f ${D}/usr/lib/logging.properties
}

pkg_postinst() {
	if use gtk && use cairo; then
		einfo "GNU Classpath was compiled with preliminary cairo support."
		einfo "To use that functionality set the system property"
		einfo "gnu.java.awt.peer.gtk.Graphics to Graphics2D at runtime."
	fi
}
