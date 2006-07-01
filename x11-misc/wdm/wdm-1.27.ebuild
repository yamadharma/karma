# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/x11-misc/wdm/wdm-1.25.ebuild,v 1.3 2003/09/05 23:29:05 msterret Exp $

IUSE="truetype pam png jpeg gif tiff gnustep selinux"

DESCRIPTION="WINGs Display Manager"
HOMEPAGE="http://voins.program.ru/wdm/"
SRC_URI="http://voins.program.ru/${PN}/${P}.tar.bz2"

SLOT="0"
KEYWORDS="x86"
LICENSE="GPL-2"

DEPEND="${RDEPEND}
	virtual/x11
	sys-devel/gettext
	truetype? ( virtual/xft )
	selinux? sys-libs/libselinux"
	
RDEPEND=">=x11-wm/windowmaker-0.65.1"

src_compile () 
{
	local myconf=""
	
	use pam && myconf="${myconf} --enable-pam"
	use png || myconf="${myconf} --disable-png"
	use jpeg || myconf="${myconf} --disable-jpeg"
	use gif || myconf="${myconf} --disable-gif"
	use tiff || myconf="${myconf} --disable-tiff"
	
	myconf="${myconf} `use_enable selinux`"
	myconf="${myconf} `use_enable truetype aafont`"
	
	if use gnustep 
	    then
	    myconf="${myconf} --with-winmgr=wmaker"
	fi
    
	myconf="${myconf} --with-fakehome=/var/cache/wdm" 
	
	econf \
		--exec-prefix=/usr \
		--with-wdmdir=/etc/X11/wdm \
		--with-nlsdir=/usr/share/locale \
		${myconf} || die
	emake || die
}

src_install () 
{
	rm ${D}/etc/pam.d/wdm
	insinto /etc/pam.d
	doins ${FILESDIR}/wdm

	make DESTDIR=${D} install || die
	
	dodir /var/cache/wdm
}
