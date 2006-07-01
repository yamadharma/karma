# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils

IUSE="7zip X gpm ncurses nls pam samba slang unicode"

U7Z_PV="4.16"
U7Z="u7z-${U7Z_PV}beta.tar.bz2"

MY_P=mc-${PV}-dominus

S=${WORKDIR}/${MY_P}

SLOT=0

DESCRIPTION="Fork of popularity file manager GNU Midnight Commander"

HOMEPAGE="http://www.sf.net/projects/mc-dominus"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2
	7zip? ( http://sgh.nightmail.ru/files/u7z/${U7Z} )"

PROVIDE="virtual/editor"

RDEPEND=">=sys-fs/e2fsprogs-1.19
	ncurses? ( >=sys-libs/ncurses-5.2-r5 )
	=dev-libs/glib-2*
	pam? ( >=sys-libs/pam-0.72 )
	gpm? ( >=sys-libs/gpm-1.19.3 )
	slang? ( >=sys-libs/slang-1.4.9-r1 )
	samba? ( >=net-fs/samba-3.0.0 )
	X? ( virtual/x11 )
	x86? ( 7zip? ( >=app-arch/p7zip-4.16 ) )
	ppc? ( 7zip? ( >=app-arch/p7zip-4.16 ) )
	amd64? ( 7zip? ( >=app-arch/p7zip-4.16 ) )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	!app-misc/mc
	!app-misc/mc-mp"


KEYWORDS="x86 amd64 ~ppc ~sparc ~alpha ~mips ~hppa ~arm"

src_unpack () 
{
	if ( use x86 || use amd64 || use ppc ) && use 7zip; then
		unpack ${U7Z}
	fi
	unpack ${MY_P}.tar.bz2
	cd ${S}

#	epatch ${DISTDIR}/${P}-sambalib-3.0.10.patch.bz2

	epatch ${FILESDIR}/${P}-find.patch
	epatch ${FILESDIR}/${P}-cpan-2003-1023.patch
#	epatch ${FILESDIR}/${P}-can-2004-0226-0231-0232.patch.bz2
	epatch ${FILESDIR}/${P}-can-2004-1004-1005-1092-1176.patch.bz2
	epatch ${FILESDIR}/${P}-vfs.patch
	if ( use x86 || use amd64 || use ppc ) && use 7zip; then
		epatch ${FILESDIR}/${P}-7zip.patch
	fi
	epatch ${FILESDIR}/${P}-ftp.patch
#	epatch ${FILESDIR}/${P}-largefile.patch
	epatch ${FILESDIR}/${P}-key.c.patch
	# Fix building with gcc4.
#	epatch ${FILESDIR}/${P}-gcc4.patch

#	if use slang && use unicode; then
#		epatch ${FILESDIR}/${P}-utf8.patch.bz2
#	fi
}

src_compile () 
{
	append-flags -I/usr/include/gssapi
	filter-flags -malign-double

	local myconf=""

	if ! use slang && ! use ncurses ; then
		myconf="${myconf} --with-screen=mcslang"
	elif use ncurses && ! use slang ; then
		myconf="${myconf} --with-screen=ncurses"
	else
		use slang && myconf="${myconf} --with-screen=slang"
	fi

	myconf="${myconf} `use_with gpm gpm-mouse`"

	use nls \
	    && myconf="${myconf} --with-included-gettext" \
	    || myconf="${myconf} --disable-nls"

	myconf="${myconf} `use_with X x`"

	use samba \
	    && myconf="${myconf} --with-samba --with-configdir=/etc/samba --with-codepagedir=/var/lib/samba/codepages --with-privatedir=/etc/samba/private" \
	    || myconf="${myconf} --without-samba"

	econf \
	    --with-vfs \
	    --with-gnu-ld \
	    --with-ext2undel \
	    --with-edit \
		--enable-charset \
	    ${myconf} || die

	emake || die
}

src_install () 
{
	 cat ${FILESDIR}/chdir-5.0.gentoo >>\
		 ${S}/lib/mc-wrapper.sh

	einstall || die

	# install cons.saver setuid, to actually work
	chmod u+s ${D}/usr/lib/mc/cons.saver

	dodoc ChangeLog AUTHORS MAINTAINERS FAQ INSTALL* NEWS README*

	insinto /usr/share/mc
	doins ${FILESDIR}/mc.gentoo
	doins ${FILESDIR}/mc.ini

	if ( use x86 || use amd64 || use ppc ) && use 7zip; then
		cd ../${U7Z_PV}
		exeinto /usr/share/mc/extfs
		doexe u7z
		dodoc readme.u7z
		newdoc ChangeLog ChangeLog.u7z
	fi

	insinto /usr/share/mc/syntax
	doins ${FILESDIR}/ebuild.syntax
	cd ${D}/usr/share/mc/syntax
	epatch ${FILESDIR}/${P}-ebuild-syntax.patch

	# http://bugs.gentoo.org/show_bug.cgi?id=71275
	rm -f ${D}/usr/share/locale/locale.alias
	
#	insinto /etc/pam.d
#        newins ${FILESDIR}/mcserv.pamd mcserv
    
#        exeinto /etc/init.d
#        newexe ${FILESDIR}/mcserv.rc mcserv
}

pkg_postinst() {
	einfo "Add the following line to your ~/.bashrc to"
	einfo "allow mc to chdir to its latest working dir at exit"
	einfo ""
	einfo "# Midnight Commander chdir enhancement"
	einfo "if [ -f /usr/share/mc/mc.gentoo ]; then"
	einfo "	. /usr/share/mc/mc.gentoo"
	einfo "fi"
}

# Local Variables:
# mode: sh
# End:

