# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="gpm nls ncurses slang"

inherit patch extrafiles

MY_PN=mc
MY_P=${MY_PN}-${PV/_/-}
S=${WORKDIR}/${MY_P}

DESCRIPTION="GNU Midnight Commander cli-based file manager. 4.1.x branch"

HOMEPAGE="http://mc.linuxinside.com/cgi-bin/dir.cgi"
SRC_URI="http://mc.linuxinside.com/Releases/${MY_P}.tar.bz2"

DEPEND=">=sys-fs/e2fsprogs-1.19
	ncurses? ( >=sys-libs/ncurses-5.2-r5 )
	>=sys-libs/pam-0.72 
	gpm? ( >=sys-libs/gpm-1.19.3 )
	slang? ( >=sys-libs/slang-1.4.2 )
	samba? virtual/samba
	!app-misc/mc"

KEYWORDS="x86 ppc sparc alpha mips hppa arm"


src_compile () 
{                           
    local myconf=""
    
    if ! use slang && ! use ncurses
	then  
	myconf="${myconf}"
    elif
	use ncurses && ! use slang
	then 
	myconf="${myconf} --with-ncurses --without-included-slang"
    else
#	use slang && myconf="${myconf} --with-included-slang"
	myconf="${myconf} `use_with slang`"	
    fi
    
    myconf="${myconf} `use_with gpm gpm-mouse`"	

    use nls \
	&& myconf="${myconf} --with-included-gettext" \
	|| myconf="${myconf} --disable-nls"
							
    econf \
	--with-vfs \
	--with-gnu-ld \
	--with-ext2undel \
	--with-edit \
	--enable-charset \
	--with-mcfs \
	--with-subshell \
	${myconf} || die
    
    emake || die
}

src_install () 
{                               
#    cat ${FILESDIR}/chdir-4.6.0.gentoo >>\
#	${S}/lib/mc-wrapper.sh
    
    einstall || die
    
    rm -rf ${D}/usr/man ${D}/usr/share/man
    doman ${S}/doc/*.1
    doman ${S}/doc/*.8
    
#	insinto /usr/share/mc
#	doins ${FILESDIR}/mc.gentoo

    dodoc ABOUT-NLS COPYING FAQ INSTALL* NEWS README.* Specfile
    cd ${S}/doc
    dodoc DEVEL FILES LSM lsm.LSM
    
    extrafiles_install
}

#pkg_postinst () 
#{
#    einfo "Add the following line to your ~/.bashrc to"
#    einfo "allow mc to chdir to it's latest working dir at exit"
#    einfo ""
#    einfo "# Midnight Commander chdir enhancement"
#    einfo "if [ -f /usr/share/mc/mc.gentoo ]; then"
#    einfo "	. /usr/share/mc/mc.gentoo"
#    einfo "fi"
#}


# Local Variables:
# mode: sh
# End:

