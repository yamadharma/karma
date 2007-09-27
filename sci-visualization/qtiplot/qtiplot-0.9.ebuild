# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/qtiplot/qtiplot-0.8.5.ebuild,v 1.1 2006/05/26 14:58:54 cryos Exp $

inherit eutils multilib 

DESCRIPTION="Qt based clone of the Origin plotting package"
HOMEPAGE="http://soft.proindependent.com/qtiplot.html"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="python doc"

LANGUAGES="de es fr ru sv"
for LANG in ${LANGUAGES}; do
	IUSE="${IUSE} linguas_${LANG}"
done

SRC_URI="http://soft.proindependent.com/src/${P/_/}.tar.bz2
	doc? ( http://soft.proindependent.com/doc/manual-en.tar.bz2
		linguas_es? ( http://soft.proindependent.com/doc/manual-es.zip ) )"

S=${WORKDIR}/${P/_/}

DEPEND=">=x11-libs/qt-4.2
	=x11-libs/qwt-5*
	>=x11-libs/qwtplot3d-0.2.6
	>=sci-libs/gsl-1.6
	>=sys-libs/zlib-1.2.3
	sci-libs/liborigin
	dev-cpp/muParser
	python? ( =dev-lang/python-2.4* 
		dev-python/sip 
		dev-python/PyQt4 )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-qmake.patch" || die "epatch qtiplot.pro failed"

	mv "${PN}.pro" "${PN}.pro.orig"
	tr -d '\r' < "${PN}.pro.orig" | sed -e 's|3rdparty/qwt||' > "${PN}.pro"
	cd qtiplot
	mv "${PN}.pro" "${PN}.pro.orig"
	tr -d '\r' < "${PN}.pro.orig" \
		| sed -e '/^[[:space:]#]*win32:/d' -e 's/^\([[:space:]]*\)unix:/\1/' \
		> "${PN}.pro"

	sed -i -e "s|_LIBDIR_|/usr/$(get_libdir)|" ${PN}.pro || die "sed failed."

	cd ${S}/fitPlugins/fitRational0
	mv fitRational0.pro fitRational0.pro.orig
	tr -d '\r' < fitRational0.pro.orig \
		| sed -e '/^[[:space:]#]*win32:/d' -e 's/^\([[:space:]]*\)unix:/\1/' \
		> fitRational0.pro
	sed -i -e 's|/usr/lib$${libsuff}|_LIBDIR_|' fitRational0.pro
	sed -i -e "s|_LIBDIR_|/usr/$(get_libdir)|" fitRational0.pro
	cd ${S}/fitPlugins/fitRational1
	mv fitRational1.pro fitRational1.pro.orig
	tr -d '\r' < fitRational1.pro.orig \
		| sed -e '/^[[:space:]#]*win32:/d' -e 's/^\([[:space:]]*\)unix:/\1/' \
		> fitRational1.pro
	sed -i -e 's|/usr/lib$${libsuff}|_LIBDIR_|' fitRational1.pro
	sed -i -e "s|_LIBDIR_|/usr/$(get_libdir)|" fitRational1.pro
}

src_compile() {
	/usr/bin/qmake "${PN}.pro"
	emake || die 'emake failed.'
}

src_install() {
	make_desktop_entry qtiplot qtiplot qtiplot Graphics
	dobin qtiplot/qtiplot || die 'Binary installation failed'
	if use doc; then
		insinto "/usr/share/doc/${PF}"
		doins -r "${WORKDIR}/manual-en"
		use linguas_es && doins -r "${WORKDIR}/manual-es"
	fi
}
