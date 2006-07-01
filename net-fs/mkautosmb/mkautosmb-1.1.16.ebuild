# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Makes the local SMB network browsable from Linux."
HOMEPAGE="http://haywire.fatalunity.com/software"
SRC_URI="http://haywire.fatalunity.com/software/mkautosmb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="
	>=dev-lang/python-2.1
	net-fs/samba
	>=sys-fs/autofs-3.1.3"

#src_unpack() {
#	unpack ${A}
#	cd ${S}/siefs
#	cp Makefile.in Makefile.in.orig
#	sed -e "s:-rm -f /sbin/mount.siefs:-mkdir \$(DESTDIR)/sbin/:" Makefile.in.orig > Makefile.in.2 || die "sed 1 failed"
#	sed -e "s:-ln -s \$(DESTDIR)\$(bindir)/siefs /sbin/mount.siefs:-ln -s ..\$(bindir)/siefs \$(DESTDIR)/sbin/mount.siefs:" Makefile.in.2 > Makefile.in || die "sed 2 failed"
#}

src_install () 
{
	make DESTDIR=${D} install || die "make install failed"
	dodoc COPYING ChangeLog README TODO shares.excl-example smbpasswd-example
}
