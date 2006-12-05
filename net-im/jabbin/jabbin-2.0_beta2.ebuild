# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by jdkbx
# based on ebuild by Francesco R. (vivo@gentoo.org)

inherit eutils qt3
DESCRIPTION="Jabbin is a Jabber client that allows calls using the VoIP Jabber network."


AUX_PV=a
MY_P=${P/_/}${AUX_PV}

HOMEPAGE="http://www.jabbin.com/"
SRC_URI="mirror://sourceforge/jabbin/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
DEPEND="$(qt_min_version 3.3)
  >=app-crypt/qca-1.0
  media-libs/speex
  net-libs/libjingle
  >=sys-libs/zlib-1.1.4
  dev-libs/jrtplib
  dev-libs/ilbc-rfc3951"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	
	use amd64 && epatch ${FILESDIR}/${P}_amd64.patch

#	epatch ${FILESDIR}/3party.patch
#	sed -i -e "s:3party::g" jabbin.pro 
}

src_compile() {
	qmake jabbin.pro || die "qmake failed"
	emake || die "emake failed"
}

src_install() {
	dodir /usr/bin

	exeinto /usr/bin
	doexe src/jabbin

	dodir /usr/share
	dodir /usr/share/jabbin
	dodir /usr/share/jabbin/certs
	dodir /usr/share/jabbin/iconsets
	dodir /usr/share/jabbin/iconsets/roster
	dodir /usr/share/jabbin/iconsets/system
	dodir /usr/share/jabbin/sound

	into /usr
	insopts -m0644

	insinto /usr/share/jabbin/certs
	doins certs/readme certs/rootcert.xml

	insinto /usr/share/jabbin/sound
	doins sound/*wav

	cd "${S}"
	for f in `find iconsets/ | grep -v .svn`
	do
		dodir /usr/share/jabbin/`dirname $f`
		insinto /usr/share/jabbin/`dirname $f`
		doins $f
	done

#	emake DESTDIR="${D}" install || die "emake install failed"
}

