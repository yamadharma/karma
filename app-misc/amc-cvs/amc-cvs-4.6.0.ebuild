# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

#ECVS_SERVER="subversions.gnu.org:/cvsroot/emacs"
#ECVS_MODULE="emacs"
#ECVS_USER="anoncvs"
#ECVS_CVS_OPTIONS="-dP"

ECVS_SERVER="mplayerhq.hu:/cvsroot/arpi"
ECVS_MODULE="amc-4.6"
#ECVS_BRANCH="SAMBA_3_0"
ECVS_USER="anonymous"
ECVS_CVS_OPTIONS="-dP"
ECVS_ANON="yes"


inherit cvs

S=${WORKDIR}/${ECVS_MODULE}

IUSE="gpm nls samba ldap ssl ncurses X slang"

#MY_P=${P/_/-}
#S=${WORKDIR}/${MY_P}

DESCRIPTION="AMC (originally Advanced Midnight Commander) is branch of the well-known Midnight Commander"
HOMEPAGE="http://www.MPlayerHQ.hu/~arpi/amc"
#SRC_URI="http://www.ibiblio.org/pub/Linux/utils/file/managers/${PN}/${MY_P}.tar.gz"
SRC_URI=""

DEPEND=">=sys-apps/e2fsprogs-1.19
	ncurses? ( >=sys-libs/ncurses-5.2-r5 )
	=dev-libs/glib-2*
	>=sys-libs/pam-0.72 
	dev-util/pkgconfig
	gpm? ( >=sys-libs/gpm-1.19.3 )
	slang? ( >=sys-libs/slang-1.4.2 )
	samba? ( virtual/samba )
	X? ( virtual/x11 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

#src_unpack()
#{
#  unpack ${A}
  
#  cd ${S}/vfs/samba
#  sed -e "s:-I/usr/local/ssl/include:-I/usr/include/openssl:" \
#    -e "s:=L/usr/local/ssl/lib:-L/usr/lib:" \
#    configure.in > configure.in.tmp
#  mv -f configure.in.tmp configure.in

#  sed -e 's:CFLAGS="-I${withval}/include $CFLAGS":CFLAGS="-I${withval} -I${withval}/include $CFLAGS":' \
#    -e 's:LDFLAGS="-L${withval}/lib $LDFLAGS":LDFLAGS="-L/usr/lib -L${withval}/lib $LDFLAGS":' \
#    configure.in > configure.in.tmp
#  mv -f configure.in.tmp configure.in

#  autoconf
    
#}
	
src_compile() {                           
	local myconf=""
	
	if ! use slang && ! use ncurses
	    then  
		myconf="${myconf} --with-screen=mcslang"
	    elif
		use ncurses && ! use slang
	    then 
		myconf="${myconf} --with-screen=ncurses"
	    else
		use slang && myconf="${myconf} --with-screen=slang"
	fi

	use gpm \
	    && myconf="${myconf} --with-gpm-mouse" \
	    || myconf="${myconf} --without-gpm-mouse"

	use nls \
	    && myconf="${myconf} --with-included-gettext --enable-charset" \
	    || myconf="${myconf} --disable-nls"
							
	use X \
	    && myconf="${myconf} --with-x" \
	    || myconf="${myconf} --without-x"
	
	use samba \
	    && myconf="${myconf} --with-samba --with-configdir=/etc/samba
				--with-codepagedir=/var/lib/samba/codepages" \
	    || myconf="${myconf} --without-samba"

	use samba \
	    && myconf="${myconf} --with-samba --with-configdir=/etc/samba" \
	    || myconf="${myconf} --without-samba"
	    
	if use samba && use ldap  
	then
	  myconf="${myconf} --with-ldap"    
	fi
	
#	if use samba && use ssl  
#	then
#	  myconf="${myconf} --with-ssl --with-sslinc=/usr/include/openssl"
# 	  CFLAGS="-I/usr/include/openssl $CFLAGS"
#	  LDFLAGS="-L/usr/lib $LDFLAGS"
#	fi
 
	
	econf \
	    --with-vfs \
	    --with-gnu-ld \
	    --with-ext2undel \
	    --with-edit \
	    --with-mcfs \
	    --with-subshell \
	    ${myconf} || die

	
	emake || die
}

src_install() {                               
	einstall
	
	dodoc ABOUT-NLS COPYING* ChangeLog AUTHORS MAINTAINERS FAQ INSTALL* NEWS README*
}

