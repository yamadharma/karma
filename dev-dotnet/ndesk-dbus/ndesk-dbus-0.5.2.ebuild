# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mono multilib

MY_PN="dbus-sharp"
MY_P="${MY_PN}-${PV}"
GLIB_PV="0.3"
GLIB_PN="${MY_PN}-glib"
GLIB_P="${GLIB_PN}-${GLIB_PV}"
GLIB_S="${WORKDIR}/${GLIB_P}"

DESCRIPTION="a C# implementation of D-Bus."
HOMEPAGE="http://www.ndesk.org/DBusSharp"
SRC_URI="http://www.ndesk.org/archive/${MY_PN}/${MY_P}.tar.gz
	glib? ( http://www.ndesk.org/archive/${MY_PN}/${GLIB_P}.tar.gz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="glib"
#IUSE="examples"

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e "s:@prefix@:/usr:" \
		-e "/^libdir/s:lib$:$(get_libdir):" \
		${PN}-1.0.pc.in > ${PN}-1.0.pc || die "sed failed"
	if use glib ; then
		sed -e "s:@prefix@:/usr:" \
		-e "s:mono/lib/:mono/:" \
		-e "/^libdir/s:lib$:$(get_libdir):" \
		${GLIB_S}/${PN}-glib-1.0.pc.in > ${GLIB_S}/${PN}-glib-1.0.pc \
		|| die "sed failed"
	fi
}

src_compile() {
	emake || die "emake install failed"

	if use glib ; then
		emake -C ${GLIB_S} DBUS_SHARP_PREFIX=${S} || die "emake failed"
	fi
}

src_install() {
	emake -C src DESTDIR="${D}" prefix=/usr install || die "emake install failed"
	dodoc README COPYING || die

	if use glib ; then
		emake -C ${GLIB_S}/glib DESTDIR="${D}" prefix=/usr \
			DBUS_SHARP_PREFIX=${S} install || die "emake install failed"
	fi

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}-1.0.pc || die
	if use glib ; then
		doins ${GLIB_S}/${PN}-glib-1.0.pc || die
	fi
}
