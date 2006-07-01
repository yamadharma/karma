# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/sys-apps/grub/grub-0.93.20030118.ebuild,v 1.6 2003/02/24 22:34:59 dragon Exp $

inherit mount-boot eutils

NEWP=grub-${PV%.*}
P_PATCH=grub-${PV}
S=${WORKDIR}/${NEWP}
DESCRIPTION="GNU GRUB boot loader"
SRC_URI="ftp://alpha.gnu.org/gnu/grub/${NEWP}.tar.gz
	mirror://gentoo/${P_PATCH}-gentoo.diff.bz2"
HOMEPAGE="http://www.gnu.org/software/grub/"
KEYWORDS="x86 -ppc -sparc -alpha -mips"
SLOT="0"
LICENSE="GPL-2"
DEPEND=">=sys-libs/ncurses-5.2-r5"
PROVIDE="virtual/bootloader"

src_unpack() {
	unpack ${A} || die
	cd ${S} || die
	# grub-0.93.20030118-gentoo.diff; <woodchip@gentoo.org> (18 Jan 2003)
	# -fixes from grub CVS pulled on 20030118
	# -vga16 patches; mined from Debian's grub-0.93+cvs20030102-1.diff
	# -special-raid-devices.patch
	# -addsyncs.patch
	# -splashimagehelp.patch
	# -configfile.patch
	# -installcopyonly.patch
	epatch ${DISTDIR}/${P_PATCH}-gentoo.diff.bz2
	WANT_AUTOCONF_2_5=1 autoconf || die
}

src_compile() {
  local myconf
  
  mkdir ${S}/diskless
  
  for i in 3c509 3c529 3c595 3c90x \
	3c507 3c503 \
	cs89x0 davicom depca \
	eepro eepro100 \
	epic100 exos205 ni5210 lance \
	ne2100 ne ns8390 rtl8139 \
	ni6510 natsemi ni5010 \
	wd sis900 sk-g16 \
	smc9000 tiara via-rhine w89c840 \
	tulip otulip
  do
    cd ${S}
    
    make distclean
    
    myconf=""
    myconf="${myconf} \
      --enable-pci-direct \
      --enable-diskless"

    myconf="${myconf} \
      --enable-$i"
  
#  myconf="${myconf} \
#    --enable-pci-direct \
#    --enable-3c509 \
#    --enable-3c529 \
#    --enable-3c595 \
#    --enable-3c90x \
#    --enable-cs89x0 \
#    --enable-davicom \
#    --enable-depca \
#    --enable-eepro \
#    --enable-eepro100 \
#    --enable-epic100 \
#    --enable-3c507 \
#    --enable-exos205 \
#    --enable-ni5210  \
#    --enable-lance \
#    --enable-ne2100 \
#    --enable-ni6510 \
#    --enable-natsemi \
#    --enable-ni5010  \
#    --enable-3c503  \
#    --enable-ne \
#    --enable-ns8390 \
#    --enable-wd  \
#    --enable-otulip  \
#    --enable-rtl8139  \
#    --enable-sis900 \
#    --enable-sk-g16 \
#    --enable-smc9000 \
#    --enable-tiara \
#    --enable-tulip \
#    --enable-via-rhine \
#    --enable-w89c840 \
#    --enable-3c503-shmem \
#    --enable-compex-rl2000-fix \
#    --enable-diskless"

	### i686-specific code in the boot loader is a bad idea; disabling to ensure 
	### at least some compatibility if the hard drive is moved to an older or 
	### incompatible system.
    unset CFLAGS

    econf --exec-prefix=/ \
      --disable-auto-linux-mem-opt \
      ${myconf} \
      || die
      
    emake || die
    
    cd ${S}/stage2
#    insinto /usr/share/grub/i386-pc
    cp nbgrub ${S}/diskless/nbgrub.${i}
    cp pxegrub ${S}/diskless/pxegrub.${i}    

#    newins nbgrub nbgrub-${i}    
#    newins pxegrub pxegrub-${i}        
  	
  done

## Ohne diskless option
  
  cd ${S}
  myconf=""
  make distclean

  unset CFLAGS
  econf --exec-prefix=/ \
      --disable-auto-linux-mem-opt \
      ${myconf} \
      || die
      
  emake || die
  
}

src_install() {
	einstall exec_prefix=${D}/ || die

	insinto /boot/grub
	doins ${FILESDIR}/splash.xpm.gz
	newins docs/menu.lst grub.conf.sample

	dodoc AUTHORS BUGS COPYING ChangeLog NEWS README THANKS TODO
	newdoc docs/menu.lst grub.conf.sample
	
	dodir /usr/share/grub/i386-pc/diskless
	cp ${S}/diskless/* ${D}/usr/share/grub/i386-pc/diskless
}

pkg_postinst() {
	[ "$ROOT" != "/" ] && return 0
	/sbin/grub-install --just-copy

	# change menu.lst to grub.conf
	if [ ! -e /boot/grub/grub.conf -a -e /boot/grub/menu.lst ]
	then
		mv /boot/grub/menu.lst /boot/grub/grub.conf
		ln -s grub.conf /boot/grub/menu.lst
		ewarn
		ewarn "*** IMPORTANT NOTE: menu.lst has been renamed to grub.conf"
		ewarn
	fi
}
