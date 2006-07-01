#Copyright 2002 Gentoo Technologies, Inc.
#Distributed under the terms of the GNU General Public License, v2 or later
#Author <root@mark.sci.pfu.edu.ru>

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Routing daemon"
SRC_URI="ftp://ftp.zebra.org/pub/zebra/${P}.tar.gz"
HOMEPAGE="http://www.zebra.org"
SLOT="0"
KEYWORDS="x86"

DEPEND=""

RDEPEND=$DEPEND

src_unpack() {

	unpack ${P}.tar.gz
	cd ${S}

}

src_compile() {

	./configure \
		--prefix=/usr \
		--sysconfdir=/etc/zebra \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--enable-vtysh \
		--with-libpam \
		--enable-tcp-zebra \
		--enable-nssa \
		--enable-opaque-lsa \
		--enable-ospf-te \
		|| die "./configure failed"

	emake || die
}

src_install () {

	make DESTDIR=${D} install || die
	
	exeinto /etc/init.d
        newexe ${FILESDIR}/etc/init.d/zebra.rc zebra
        newexe ${FILESDIR}/etc/init.d/ospfd.rc ospfd
	
	dodir /var/log/zebra
	
}



