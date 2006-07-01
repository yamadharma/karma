# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="SMB network Unix filesystem hierarchy interconnector using the fuse filesystem in user space."
HOMEPAGE="http://yarick.territory.ru/fusemb"
SRC_URI="http://yarick.territory.ru/fusemb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=">=sys-fs/fuse-2.2
	=net-fs/samba-3*"

#src_unpack() {
#	unpack ${A}
#	cd ${S}/siefs
#	cp Makefile.in Makefile.in.orig
#	sed -e "s:-rm -f /sbin/mount.siefs:-mkdir \$(DESTDIR)/sbin/:" Makefile.in.orig > Makefile.in.2 || die "sed 1 failed"
#	sed -e "s:-ln -s \$(DESTDIR)\$(bindir)/siefs /sbin/mount.siefs:-ln -s ..\$(bindir)/siefs \$(DESTDIR)/sbin/mount.siefs:" Makefile.in.2 > Makefile.in || die "sed 2 failed"
#}

src_compile ()
{
    econf || die "Configuration error"
    emake || die "Compilation error"
}

src_install () 
{
	make DESTDIR=${D} install || die "make install failed"
	dodoc README fusemb.conf.sample AUTHORS 
}
