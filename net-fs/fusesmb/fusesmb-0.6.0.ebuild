# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: $

inherit extrafiles

IUSE=""

DESCRIPTION="A tool for mounting the network neighbourhood."
HOMEPAGE="http://hannibal.lr-s.tudelft.nl/~vincent/fusesmb/"
SRC_URI="http://hannibal.lr-s.tudelft.nl/~vincent/fusesmb/download/${P}.tar.gz"

DEPEND="sys-fs/fuse
	>=net-fs/samba-3"
	
RDEPEND="${DEPEND}	
	>=dev-lang/python-2.3"
    
SLOT="0"

LICENSE="GPL-2"
KEYWORDS="x86 ~alpha ~ppc ~sparc"

src_compile () 
{
    econf \
	${myconf} || die "Configure error"
    
    make || die "Make error"
}

src_install () 
{
    make install DESTDIR=${D}

    dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
    
    extrafiles_install
}

pkg_postinstall ()
{
    einfo "Create a directory where you would to have your <mountpoint> e.g:"
    einfo "mkdir ~/net"
    einfo "after that:"
    einfo "fusermount <mountpoint> fusesmb &"
    einfo ""
    einfo "Add the following line to crontab:"
    einfo "*/30 * * * * fusesmbcache &> /dev/null"
}

# Local Variables:
# mode: sh
# End:
