#Copyright 2002 Gentoo Technologies, Inc.
#Distributed under the terms of the GNU General Public License, v2 or later
#Author <root@mark.sci.pfu.edu.ru>

IUSE="doc ipv6"

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Routing daemon"
SRC_URI="ftp://bird.network.cz/pub/bird/${P}.tar.gz 
doc?	ftp://bird.network.cz/pub/bird/${PN}-doc-${PV}.tar.gz"
HOMEPAGE="http://bird.network.cz"
SLOT="0"
KEYWORDS="x86"

DEPEND=""

RDEPEND=$DEPEND


src_compile() 
{
	local myconf
	myconf="${myconf} `use_enable ipv6`"
	econf \
		--prefix=/usr \
		--sysconfdir=/etc/bird \
		--localstatedir=/var/lib/bird \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--enable-client \
		--with-protocols=all \
		|| die "./configure failed"

	make || die

#	if ( use doc ) 
#	then
#	  make docs
#	fi
	
}

src_install () 
{

	make prefix=${D}/usr \
	    sysconfdir=${D}/etc/bird \
	    localstatedir=${D}/var/lib/bird \
	    install || die

	if ( use doc ) 
	then
	  make docdir=${D}/usr/share/doc/${P} install-docs
	fi

	exeinto /etc/init.d
        doexe ${FILESDIR}/etc/init.d/bird
	
}



