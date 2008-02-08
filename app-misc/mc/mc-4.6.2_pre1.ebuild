# Copyright 1999-2005 Gentoo Foundation${WORKDIR}
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mc/mc-4.6.0-r14.ebuild,v 1.4 2005/09/01 20:44:37 sbriesen Exp $

inherit flag-o-matic eutils

MY_P=${P/_pre/-pre}
S=${WORKDIR}/${MY_P}

DESCRIPTION="GNU Midnight Commander cli-based file manager"
HOMEPAGE="http://www.ibiblio.org/mc/"
SRC_URI="ftp://ftp.gnu.org/gnu/mc/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE="7zip X gpm ncurses nls pam samba slang unicode"

PROVIDE="virtual/editor"

RDEPEND=">=sys-fs/e2fsprogs-1.19
	ncurses? ( >=sys-libs/ncurses-5.2-r5 )
	slang? ( >=sys-libs/slang-2.0.5 )
	=dev-libs/glib-2*
	pam? ( >=sys-libs/pam-0.72 )
	gpm? ( >=sys-libs/gpm-1.19.3 )
	samba? ( >=net-fs/samba-3.0.0 )
	X? ( virtual/x11 )
	x86? ( 7zip? ( >=app-arch/p7zip-4.16 ) )
	ppc? ( 7zip? ( >=app-arch/p7zip-4.16 ) )
	amd64? ( 7zip? ( >=app-arch/p7zip-4.16 ) )"
	

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}

	cd ${S}
	
	EPATCH_FORCE="yes" \
	EPATCH_SUFFIX="patch" \
	    epatch ${FILESDIR}/${PV}
	    
	#FIX for slang-2
	sed -i -e "s:slang/slang.h:slang-2/slang.h:g"  acinclude.m4	    
	sed -i -e "s:-lslang:-lslang-2:g"  acinclude.m4	    	
	
	chmod +x autogen.sh
}

src_compile() {

	if ( use unicode )
	    then
	    # convert files in /lib to UTF-8
	    pushd lib
	    for i in mc.hint mc.hint.es mc.hint.it mc.hint.nl 
	    do
		iconv -f iso-8859-1 -t utf-8 < ${i} > ${i}.tmp
	        mv -f ${i}.tmp ${i}
	    done

	    for i in mc.hint.cs mc.hint.hu mc.hint.pl 
	    do
		iconv -f iso-8859-2 -t utf-8 < ${i} > ${i}.tmp
		mv -f ${i}.tmp ${i}
	    done

	    for i in mc.hint.sr mc.menu.sr 
	    do
		iconv -f iso-8859-5 -t utf-8 < ${i} > ${i}.tmp
		mv -f ${i}.tmp ${i}
	    done

	    iconv -f koi8-r -t utf8 < mc.hint.ru > mc.hint.ru.tmp
	    mv -f mc.hint.ru.tmp mc.hint.ru
	    iconv -f koi8-u -t utf8 < mc.hint.uk > mc.hint.uk.tmp
	    mv -f mc.hint.uk.tmp mc.hint.uk
	    iconv -f big5 -t utf8 < mc.hint.zh > mc.hint.zh.tmp
	    mv -f mc.hint.zh.tmp mc.hint.zh
	    popd

	    # convert man pages in /doc to UTF-8
	    pushd doc

	    pushd ru
	    for i in mc.1.in xnc.hlp 
	    do
		iconv -f koi8-r -t utf-8 < ${i} > ${i}.tmp
		mv -f ${i}.tmp ${i}
	    done
	    popd

	    pushd sr
	    for i in mc.1.in mcserv.8.in xnc.hlp 
	    do
		iconv -f iso-8859-5 -t utf-8 < ${i} > ${i}.tmp
		mv -f ${i}.tmp ${i}
	    done
	    popd

	    for d in es it 
	    do
		for i in mc.1.in xnc.hlp
		do
		    iconv -f iso-8859-3 -t utf-8 < ${d}/${i} > ${d}/${i}.tmp
		    mv -f ${d}/${i}.tmp ${d}/${i}
		done
	    done

	    for d in hu pl 
	    do
		for i in mc.1.in xnc.hlp 
		do
		    iconv -f iso-8859-2 -t utf-8 < ${d}/${i} > ${d}/${i}.tmp
		    mv -f ${d}/${i}.tmp ${d}/${i}
		done
	    done

	    popd
	fi

	append-flags -I/usr/include/gssapi
	use unicode && append-flags -DUTF8=1
	use slang && append-flags -I/usr/include/slang-2
	
	filter-flags -malign-double

	local myconf=""

	if ! use slang && ! use ncurses ; then
		myconf="${myconf} --with-screen=mcslang"
	elif use ncurses && ! use slang ; then
		myconf="${myconf} --with-screen=ncurses"
	else
		use slang && myconf="${myconf} --with-screen=slang"
		! use slang && myconf="${myconf} --with-screen=mcslang"		
		myconf="${myconf} --with-screen=mcslang"		
	fi

	myconf="${myconf} `use_with gpm gpm-mouse`"

	use nls \
	    && myconf="${myconf} --with-included-gettext" \
	    || myconf="${myconf} --disable-nls"

	myconf="${myconf} `use_with X x`"

	use samba \
	    && myconf="${myconf} --with-samba --with-configdir=/etc/samba --with-codepagedir=/var/lib/samba/codepages --with-privatedir=/etc/samba/private" \
	    || myconf="${myconf} --without-samba"

#	econf \
	./autogen.sh \
	    --prefix=/usr \
	    --datadir=/usr/share \
	    --sysconfdir=/usr/share \
	    --libdir=/usr/lib \
	    --with-vfs \
	    --with-gnu-ld \
	    --with-ext2undel \
	    --with-edit \
	    --enable-charset \
	    --enable-extcharset \
	    --with-mcfs \
	    --with-subshell \
	    ${myconf} || die

	emake || die
}

src_install() {
	 cat ${FILESDIR}/chdir-4.6.0.gentoo >>\
		 ${S}/lib/mc-wrapper.sh

	einstall || die

	# install cons.saver setuid, to actually work
	chmod u+s ${D}/usr/libexec/mc/cons.saver

	dodoc ChangeLog AUTHORS MAINTAINERS FAQ INSTALL* NEWS README*

	insinto /usr/share/mc
	doins ${FILESDIR}/mc.gentoo
	doins ${FILESDIR}/mc.ini

	insinto /usr/share/mc/syntax
	doins ${FILESDIR}/ebuild.syntax

	# http://bugs.gentoo.org/show_bug.cgi?id=71275
	rm -f ${D}/usr/share/locale/locale.alias
	
	dodir /etc/profile.d
	exeinto /etc/profile.d
	doexe ${D}/usr/share/mc/bin/mc.sh
	doexe ${D}/usr/share/mc/bin/mc.csh
	
        newinitd ${FILESDIR}/mcserv.rc mcserv

	insinto /etc/pam.d
        newins ${FILESDIR}/mcserv.pamd mcserv
    
	if ( ! use unicode )
	    then
	    # Add Russian and Ukrainian hints and help for CP1251 & UTF-8 locales
	    iconv -fkoi8-r -tcp1251 ${D}/usr/share/mc/mc.hint.ru > ${D}/usr/share/mc/mc.hint.ru_RU.CP1251
	    iconv -fkoi8-u -tcp1251 ${D}/usr/share/mc/mc.hint.uk > ${D}/usr/share/mc/mc.hint.uk_UA.CP1251
	    iconv -fkoi8-r -tcp1251 ${D}/usr/share/mc/mc.hlp.ru >  ${D}/usr/share/mc/mc.hlp.ru_RU.CP1251
	fi
	
	dodoc ${FILESDIR}/*.color	
}
