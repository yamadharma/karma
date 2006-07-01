# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: $

MY_P=${P/_/}

S=${WORKDIR}/${MY_P}
DESCRIPTION="An agent/software robot and a high level policy language for building expert systems to administrate and configure large computer networks"
SRC_URI="ftp://ftp.iu.hio.no/pub/cfengine/${MY_P}.tar.gz"
HOMEPAGE="http://www.iu.hio.no/cfengine/"

DEPEND="virtual/glibc
	>=sys-libs/db-3.2*
	dev-libs/openssl"

RDEPEND="${DEPEND}"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"

src_compile() 
{
    local myconf
    myconf="--with-berkeleydb=/usr --with-workdir=/var/lib/cfengine"
    econf ${myconf} || die
    emake || die
}

src_install () 
{
    emake DESTDIR=${D} install || die
    dodoc AUTHORS ChangeLog COPYING DOCUMENTATION NEWS README TODO
    dohtml doc/*.html
    doinfo doc/*.info*
    docinto examples; dodoc ${D}/usr/share/cfengine/*.example
    rm -rf ${D}/usr/share/cfengine ${D}/usr/doc
    #
    exeinto /etc/init.d
    newexe ${FILESDIR}/rc/cfengine.rc-2 cfengine
}

pkg_postinst() 
{
# {{{ key generation
	
    /usr/sbin/cfkey
	
# }}}

    mkdir -p /var/lib/cfengine/bin
    cp /usr/sbin/cfagent /var/lib/cfengine/bin/cfagent
}

# Local Variables:
# mode: sh
# End:
