
inherit kde

AUX_PV=a
MY_P=${P/_/}${AUX_PV}

DESCRIPTION="Jabbin is an Open Source Jabber client program that allows free PC to PC calls using the VoIP system over the Jabber network."
HOMEPAGE="http://www.jabbin.com/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

S=${WORKDIR}/${MY_P}

DEPEND="=x11-libs/qt-3*
    sys-libs/zlib
    app-crypt/qca
    net-libs/libjingle
    dev-libs/jrtplib"

RDEPEND="=x11-libs/qt-3*
    sys-libs/zlib
    app-crypt/qca
    net-libs/libjingle
    dev-libs/jrtplib"

src_unpack() {
	kde_src_unpack

	# FIX svn bug
	cd ${S}
	chmod +x configure
#	sed -i -e "s:3party::g" jabbin.pro 
#	unpack "${PN}-2.0beta.tar.bz2"
#	mv -v "${PN}-2.0beta" "${P}"
}

src_compile() {
	QMAKE=/usr/qt/3/bin/qmake QTDIR=/usr/qt/3 qmake QTDIR=/usr/qt/3 QMAKE=/usr/qt/3/bin/qmake jabbin.pro || die
	QMAKE=/usr/qt/3/bin/qmake QTDIR=/usr/qt/3 make QTDIR=/usr/qt/3 QMAKE=/usr/qt/3/bin/qmake qmake || die
	QMAKE=/usr/qt/3/bin/qmake QTDIR=/usr/qt/3 make QTDIR=/usr/qt/3 QMAKE=/usr/qt/3/bin/qmake || die
}

#src_install() {
#	dobin src/jabbin
#	dodoc README INSTALL COPYING
#	dodir /usr/share/jabbin
#	rsync -rlptDv --exclude=.svn --exclude=readme sound iconsets "${D}"/usr/share/jabbin/
#} 