# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: $

IUSE=""

DESCRIPTION="FUSE (Filesystem in Userspace) is a simple interface for userspace
programs to export a virtual filesystem to the linux kernel.  FUSE
also aims to provide a secure method for non privileged users to
create and mount their own filesystem implementations."
HOMEPAGE="http://www.inf.bme.hu/~mszeredi/avfs"
SRC_URI="mirror://sourceforge/avf/${P}.tar.gz"

DEPEND="virtual/linux-sources"

SLOT="${KV}"

LICENSE="GPL-2"
KEYWORDS="x86 ~alpha ~ppc ~sparc"

check_KV


src_unpack () 
{
    unpack ${A}
    
    cd ${S}
    sed -i -e "/depmod -a/d" kernel/Makefile.in
}

src_compile () 
{
    econf \
	--enable-lib \
	--enable-util \
	--enable-kernel-module \
	--with-kernel=/usr/src/linux \
	${myconf} || die "Configure error"
    
    make || die "Make error"
}

src_install () 
{
    make install DESTDIR=${D} fusemoduledir=/lib/modules/${KV}/fs/fuse

    dodoc AUTHORS BUGS COPYING COPYING.LIB ChangeLog Filesystems INSTALL NEWS README* TODO
}

pkg_postinst ()
{
    if [ "${ROOT}" = / ]
	then
	[ -x /usr/sbin/update-modules ] && /usr/sbin/update-modules
    fi
}

# Local Variables:
# mode: sh
# End:
