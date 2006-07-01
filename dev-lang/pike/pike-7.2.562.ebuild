# Copyright 1999-2003 Gentoo Technologies, Inc., Emil Sköldberg (see ChangeLog)
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-lang/pike/pike-7.4.28.ebuild,v 1.4 2003/10/02 19:30:29 scandium Exp $

inherit flag-o-matic patch extrafiles

# -fomit-frame-pointer breaks the compilation
filter-flags -fomit-frame-pointer

IUSE="debug static doc zlib readline mysql gdbm postgres java gtk gtk2 gnome opengl perl truetype pdflib ssl sdl svg"

addpredict /usr/lib/pike

PREBUILD_P=pike-7.2.492

HOMEPAGE="http://pike.ida.liu.se/"
DESCRIPTION="Pike programming language and runtime"
SRC_URI="ftp://ftp.caudium.net/pike/7.2/unofficial/${PREBUILD_P}.tar.gz
	ftp://ftp.caudium.net/pike/7.2/${P}.tar.gz"

LICENSE="GPL-2 | LGPL-2.1 | MPL-1.1"
SLOT="0"
KEYWORDS="~x86 ~ppc"

DEPEND=">=sys-devel/autoconf-2.13 
	sys-devel/gcc
	sys-devel/make
	sys-apps/sed
	>=sys-libs/zlib-1.1.4 
	readline? ( >=sys-libs/readline-4.1 >=sys-libs/ncurses-5.2 )
	dev-libs/gmp
	mysql? dev-db/mysql
	postgres? ( >=dev-db/postgresql-7 )
	ssl?	( dev-libs/openssl )
	java?	virtual/jdk
	media-libs/tiff
	media-libs/jpeg
	media-libs/giflib
	truetype?	( media-libs/freetype )
	media-libs/libpng
	gtk?	( =x11-libs/gtk+-1.2* )
	gtk2?	( =x11-libs/gtk+-2* )
	perl?	>=dev-lang/perl-5.8
	pdflib? ( >=media-libs/pdflib-4.0.1-r2 )
	sdl? ( >=media-libs/libsdl-1.2 )
	opengl? ( virtual/opengl )
	svg?	gnome-base/librsvg
	dev-lang/nasm"

S="${WORKDIR}/${P}"
PREBUILD_S="${WORKDIR}/${PREBUILD_P}"
#B="${WORKDIR}/${PN}"	# Build dir

src_unpack ()
{
    patch_src_unpack
    
    cd ${S}/src
    ./run_autoconfig
}

src_compile() 
{
#    mkdir ${B}
    
    local myconf
    local cppflags
    local ldflags
    
    cppflags="${CPPFLAGS}"
    cppflags="${cppflags} -I/usr/include"

    ldflags="${LDFLAGS} -R/usr/lib -L/usr/lib -R/usr/X11R6/lib -L/usr/X11R6/lib"

    einfo 'Gtk+ and Gnome support is disabled for now!'
    einfo 'Gtk+-2 did not work with pike and'
    einfo 'Gtk+-1 just caused too many problems'
    sleep 5
#    myconf="${myconf} `use_with gtk GTK`"
#    myconf="${myconf} `use_with gtk2 GTK2`"
#    myconf="${myconf} `use_with gnome`"    
    myconf="${myconf} --without-GTK --without-GTK2 --without-gnome"

    cd ${PREBUILD_S}/src
    
    LDFLAGS=${ldflags} \
    CPPFLAGS=${cppflags} \
	./configure --prefix=${T}/prebuild \
	--with-double-precision \
	--with-long-double-precision \
	--with-poll \
	--with-gmp \
	--with-bignums \
	--with-zlib \
	--with-max-fd=65000 \
	--with-security \
	--with-threads \
	--disable-make_conf --without-ffmpeg \
	${myconf} || die "Configure error"
    
    emake || die "Make error"
    
    make depend
    
    make \
	prefix=${T}/prebuild \
	INSTALLARGS="--traditional" \
	install
    
    if use java
	then
	ldflags="${ldflags} -L`java-config -O`/jre/lib/i386/server -L`java-config -O`/jre/lib/i386/native_threads"
	myconf="${myconf} --with-java-lib-dir=`java-config -O`/jre/lib/i386"
    fi
    
    if use postgres
	then
	myconf="${myconf} --with-postgres --with-postgres-include-dir=/usr/include/postgresql --with-libpq-dir=/usr/lib"
	cppflags="${cppflags} -I/usr/include/postgresql/server"
    fi
    
    if use truetype
	then
	myconf="${myconf} --with-freetype --with-ttflib"
	cppflags="${cppflags} -I/usr/include/freetype2"
#    include-path="${include-path} /usr/include/freetype2"
    fi
    
    if use ssl
	then
	myconf="${myconf} --with-ssleay"
	cppflags="${cppflags} -I/usr/include/openssl"
    fi
    
    myconf="${myconf} `use_with mysql`"
    myconf="${myconf} `use_with perl`"  
    myconf="${myconf} `use_with zlib`"    
    myconf="${myconf} `use_with debug`"   
    myconf="${myconf} `use_with static static-linking`"     
    myconf="${myconf} `use_with gdbm`"    
    myconf="${myconf} `use_with svg`"        
#    myconf="${myconf} `use_with opengl lib-MesaGL`"        
    myconf="${myconf} `use_with pdflib libpdf`"

    

#    export LDFLAGS=-static

#	# We have to use --disable-make_conf to override make.conf settings
#	# Otherwise it may set -fomit-frame-pointer again
#	# disable ffmpeg support because it does not compile
#	emake CONFIGUREARGS="${myconf} --prefix=/usr --disable-make_conf --without-ffmpeg" || die
#
#	# only build documentation if 'doc' is in USE
#	if use doc; then
#		PATH="${S}/bin:${PATH}" make doc || die
#	fi

    
    cd ${S}/src
    
    PATH="${T}/prebuild/bin:${PATH}" \
    LDFLAGS=${ldflags} \
    CPPFLAGS=${cppflags} \
	./configure --prefix=/usr \
	--with-double-precision \
	--with-long-double-precision \
	--with-poll \
	--with-gmp \
	--with-bignums \
	--with-zlib \
	--with-max-fd=65000 \
	--with-security \
	--with-threads \
	--disable-make_conf --without-ffmpeg \
	${myconf} || die "Configure error"
    
#    --with-include-path=${include-path} \

#  sed -e "s:^buildroot=$:buildroot=${D}:g" Makefile >  Makefile.tmp
#  mv -f Makefile.tmp Makefile
 
    cd ${S}/src
    make depend
    
    PATH="${T}/prebuild/bin:${PATH}" \
	emake || die "Make error"
    
#    make verify || die "Not verifyed"

#    # only build documentation if 'doc' is in USE
#    if use doc 
#	then
#	PATH="${S}/bin:${PATH}" make doc || die
#    fi
}


src_install () 
{
    addpredict /usr/lib/pike
    cd ${S}/src
    
    make \
	buildroot=${D} \
	prefix=/usr \
	INSTALLARGS="--traditional" \
	install

    if ( use doc )
	then
	dodir /usr/share/doc/${PF}/tutorial
	cp -R ${S}/tutorial ${D}/usr/share/doc/${PF}/tutorial
    fi
    

#    if ( use doc )
#	then
#	einfo "Installing 60MB of docs, this could take some time ..."
#	dohtml -r ${S}/refdoc/traditional_manual ${S}/refdoc/modref
#    fi
}

# Local Variables:
# mode: sh
# End:
