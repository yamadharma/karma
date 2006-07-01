# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/pike/pike-7.6.6.ebuild,v 1.8 2004/12/29 02:37:04 ribosome Exp $
# Contributions by Emil Skoldberg, Fredrik Mellstrom (see ChangeLog)

inherit fixheadtails flag-o-matic

IUSE="crypt debug doc fftw gdbm gif java jpeg mysql oci8 odbc opengl pdflib postgres scanner sdl tiff truetype zlib perl ffmpeg svg kerberos"
# gtk gtk2 gnome

# S="${WORKDIR}/Pike-v${PV}"
HOMEPAGE="http://pike.ida.liu.se/"
DESCRIPTION="Pike programming language and runtime"
SRC_URI="ftp://ftp.caudium.net/pike/7.6/${P}.tar.gz"
# http://pike.ida.liu.se/pub/pike/all/${PV}/Pike-v${PV}.tar.gz

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="x86 ppc amd64"

DEPEND="crypt?	( dev-libs/nettle )
	zlib?	( sys-libs/zlib )
	pdflib? ( media-libs/pdflib )
	gdbm?	( sys-libs/gdbm )
	java?	( virtual/jdk )
	scanner? ( media-gfx/sane-backends )
	mysql?	( dev-db/mysql )
	postgres? ( dev-db/postgresql )
	gif?	( media-libs/giflib )
	truetype? ( media-libs/freetype )
	jpeg?	( media-libs/jpeg )
	tiff?	( media-libs/tiff )
	kerberos? ( virtual/krb5 )
	opengl?	( virtual/opengl
		virtual/glut )
    	ffmpeg? ( media-video/ffmpeg )		
	sdl?	( media-libs/libsdl )
	fftw?	( =sci-libs/fftw-2* )
	crypt?	( dev-libs/nettle )
	perl?	( dev-lang/perl )
	svg?	( gnome-base/librsvg )
	dev-libs/gmp"

#	gtk?	( =x11-libs/gtk+-1.2* )
#	gtk2?	( =x11-libs/gtk+-2* )

cflag_setup () 
{
	# Set up CFLAGS
#	filter-flags "-funroll-loops"
#	filter-flags "--fomit-frame-pointer"

#	ALLOWED_FLAGS="-march -mcpu -O -O1 -O2 -O3 -pipe -fomit-frame-pointer -g -gstabs+ -gstabs -ggdb"

	is-flag -fstack-protector && filter-flags -fstack-protector
	is-flag -fpie && filter-flags -fpie

	strip-flags
	
	append-flags -fno-pie
	append-flags -fno-stack-protector
}


src_unpack () 
{
	unpack ${A}
	cd ${S}

	use java && epatch ${FILESDIR}/java_config-7.6.patch
	
	# ht_fix_all kills autoheader stuff, so we use ht_fix_file
	find . -iname "*.sh" -or -iname "*.sh.in" -or -iname "Makefile*" | \
	while read i; do
		ht_fix_file $i
	done

        cd ${S}/src
	./run_autoconfig

}

src_compile () 
{
	cflag_setup

	local myconf
	
	
	myconf="${myconf} `use_with debug`"
	myconf="${myconf} `use_with zlib`"
	myconf="${myconf} `use_with mysql`"
	myconf="${myconf} `use_with gdbm`"
	myconf="${myconf} `use_with pdflib libpdf`"
	myconf="${myconf} `use_with odbc`"
	myconf="${myconf} `use_with postgres`"
	myconf="${myconf} `use_with oci8 oracle`"
	myconf="${myconf} `use_with gif`"
	myconf="${myconf} `use_with truetype ttflib`"
	myconf="${myconf} `use_with truetype freetype`"
	myconf="${myconf} `use_with svg`"
	myconf="${myconf} `use_with jpeg jpeglib`"
	myconf="${myconf} `use_with tiff tifflib`"
	myconf="${myconf} `use_with opengl GL`"
	myconf="${myconf} `use_with opengl GLUT`"
	myconf="${myconf} `use_with kerberos krb5`"
	myconf="${myconf} `use_with fftw`"
	myconf="${myconf} `use_with scanner sane`"
	myconf="${myconf} `use_with crypt nettle`"
	myconf="${myconf} `use_with ffmpeg`"
	myconf="${myconf} `use_with perl`"
	myconf="${myconf} `use_with java`"

#	myconf="${myconf} `use_with gtk GTK`"
#	myconf="${myconf} `use_with gtk2 GTK2`"


        if use java
	    then
	    append-ldflags -L`java-config -O`/jre/lib/i386/server -L`java-config -O`/jre/lib/i386/native_threads
	    myconf="${myconf} --with-java-lib-dir=`java-config -O`/jre/lib/i386"
	fi

	einfo 'Gtk+ and Gnome support is disabled for now!'
	einfo 'Gtk+-2 did not work with pike and'
	einfo 'Gtk+-1 just caused too many problems'
	sleep 5
	myconf="${myconf} --without-GTK --without-GTK2 --without-gnome"

	emake CONFIGUREARGS="${myconf} --prefix=/usr --disable-make_conf" all || die

	if use doc 
	    then
	    PATH="${S}/bin:${PATH}" make doc || die
	fi
}

src_install () 
{
	# the installer should be stopped from removing files, to prevent sandbox issues
	sed -i s/rm\(mod\+\"\.o\"\)\;/\{\}/ ${S}/bin/install.pike || die "Failed to modify install.pike"

	if use doc 
	    then
	    make INSTALLARGS="--traditional" buildroot="${D}" install || die
	    einfo "Installing 60MB of docs, this could take some time ..."
	    dohtml -r ${S}/refdoc/traditional_manual ${S}/refdoc/modref
	else
	    make INSTALLARGS="--traditional" buildroot="${D}" install_nodoc || die
	fi
}

