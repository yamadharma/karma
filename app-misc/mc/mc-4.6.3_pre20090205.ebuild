# Copyright 1999-2005 Gentoo Foundation${WORKDIR}
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_BRANCH=GENTOO-4.6.2

# EGIT_BRANCH=0f5da6e180861162e949efeb89fd89b0bd8285bf

inherit flag-o-matic eutils git

EGIT_REPO_URI=http://git.midnight-commander.org/mc.git

MY_P=${P/_pre/-pre}
S=${WORKDIR}/${MY_P}

DESCRIPTION="GNU Midnight Commander cli-based file manager"
HOMEPAGE="www.midnight-commander.org"
# SRC_URI="ftp://ftp.gnu.org/gnu/mc/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE="gpm nls samba +unicode X"

PROVIDE="virtual/editor"

RDEPEND=">=dev-libs/glib-2
	unicode? ( >=sys-libs/slang-2.1.3 )
	!unicode? ( sys-libs/ncurses )
	gpm? ( sys-libs/gpm )
	X? ( x11-libs/libX11
		x11-libs/libICE
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libSM )
	samba? ( net-fs/samba )
	kernel_linux? ( sys-fs/e2fsprogs )
	app-arch/zip
	app-arch/unzip"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	dev-util/pkgconfig"

src_prepare() {
	./autogen.sh

#{{{ convert files in /lib to UTF-8

	if use unicode
	then
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

#}}}
}

src_configure() {
	append-flags -I/usr/include/gssapi
	append-flags "-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE"
	filter-flags -malign-double

	local myconf="--with-vfs --with-ext2undel --with-edit"
#	myconf+=" --enable-charset --enable-extcharset"

	myconf+ =" --enable-background --enable-netcode"

	if use unicode
	then
		myconf+=" --enable-utf8 --with-screen=slang"
		append-flags "-DUTF8=1"
	else
		myconf+=" --disable-utf8 --with-screen=ncurses"
		ewarn "Non UTF-8 setup is deprecated."
		ewarn "You are highly encouraged to use UTF-8 compatible system locale."
	fi

	use nls \
	    && myconf="${myconf} --with-included-gettext" \
	    || myconf="${myconf} --disable-nls"

	use samba \
		&& myconf+=" --with-samba --with-configdir=/etc/samba --with-codepagedir=/var/lib/samba/codepages --with-privatedir=/etc/samba/private" \
		|| myconf+=" --without-samba"

	econf --disable-dependency-tracking \
		$(use_with gpm gpm-mouse) \
		$(use_with X x) \
		${myconf}
}

src_install() {
#	 cat ${FILESDIR}/chdir-4.6.0.gentoo >>\
#		 ${S}/lib/mc-wrapper.sh

	einstall || die

	# Install cons.saver setuid to actually work
	fperms u+s /usr/libexec/mc/cons.saver

	dodoc ChangeLog AUTHORS MAINTAINERS FAQ INSTALL* NEWS README*

#	insinto /usr/share/mc
#	doins ${FILESDIR}/mc.gentoo
#	doins ${FILESDIR}/mc.ini

# http://bugs.gentoo.org/show_bug.cgi?id=71275
	rm -f ${D}/usr/share/locale/locale.alias
	
	dodir /etc/profile.d
	exeinto /etc/profile.d
	doexe ${D}/usr/share/mc/bin/mc.sh
	doexe ${D}/usr/share/mc/bin/mc.csh

	newinitd ${FILESDIR}/mcserv.rc mcserv
	insinto /etc/pam.d
	newins ${FILESDIR}/mcserv.pamd mcserv

	dodoc ${FILESDIR}/*.color
}
