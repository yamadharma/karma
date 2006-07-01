# Copyright 1999-2005 Gentoo Foundation${WORKDIR}
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mc/mc-4.6.0-r14.ebuild,v 1.4 2005/09/01 20:44:37 sbriesen Exp $

inherit flag-o-matic eutils cvs
#gnuconfig 

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="cvs.savannah.gnu.org:/sources/mc"
ECVS_USER="anoncvs"
ECVS_AUTH="pserver"
ECVS_MODULE="mc"
ECVS_CO_OPTS="-D ${PV/*_pre}"
ECVS_UP_OPTS="-D ${PV/*_pre}"
ECVS_TOP_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/cvs-src/savannah.gnu.org/mc"

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="GNU Midnight Commander cli-based file manager"
HOMEPAGE="http://www.ibiblio.org/mc/"
#SRC_URI="http://www.ibiblio.org/pub/Linux/utils/file/managers/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE="7zip X gpm ncurses nls pam samba slang unicode"

PROVIDE="virtual/editor"

RDEPEND=">=sys-fs/e2fsprogs-1.19
	ncurses? ( >=sys-libs/ncurses-5.2-r5 )
	=dev-libs/glib-2*
	pam? ( >=sys-libs/pam-0.72 )
	gpm? ( >=sys-libs/gpm-1.19.3 )
	samba? ( >=net-fs/samba-3.0.0 )
	X? ( virtual/x11 )
	x86? ( 7zip? ( >=app-arch/p7zip-4.16 ) )
	ppc? ( 7zip? ( >=app-arch/p7zip-4.16 ) )
	amd64? ( 7zip? ( >=app-arch/p7zip-4.16 ) )"

# FIXME: >=sys-libs/slang-2.0.5 not in portage tree
# 	slang? ( >=sys-libs/slang-2.0.5 )

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	cvs_src_unpack

	tar xjf ${FILESDIR}/mc-4.6.1a-patches.tar.bz2 -C ${WORKDIR}

	cd ${S}
	EPATCH_FORCE="yes" \
	EPATCH_SUFFIX="patch" \
	    epatch ${WORKDIR}/patches
}

src_compile() {
	append-flags -I/usr/include/gssapi
	filter-flags -malign-double

	local myconf=""

	if ! use slang && ! use ncurses ; then
		myconf="${myconf} --with-screen=mcslang"
	elif use ncurses && ! use slang ; then
		myconf="${myconf} --with-screen=ncurses"
	else
# FIXME: >=sys-libs/slang-2.0.5 not in portage tree
#		use slang && myconf="${myconf} --with-screen=slang"
		use slang && myconf="${myconf} --with-screen=mcslang"		
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
    

	# Add Russian and Ukrainian hints and help for CP1251 & UTF-8 locales
	iconv -fkoi8-r -tcp1251 ${D}/usr/share/mc/mc.hint.ru > ${D}/usr/share/mc/mc.hint.ru_RU.CP1251
	iconv -fkoi8-u -tcp1251 ${D}/usr/share/mc/mc.hint.uk > ${D}/usr/share/mc/mc.hint.uk_UA.CP1251
	iconv -fkoi8-u -tcp1251 ${D}/usr/share/mc/mc.hlp.ru >  ${D}/usr/share/mc/mc.hlp.ru_RU.CP1251
	iconv -fkoi8-r -tutf8   ${D}/usr/share/mc/mc.hint.ru > ${D}/usr/share/mc/mc.hint.ru_RU.UTF-8
	iconv -fkoi8-u -tutf8   ${D}/usr/share/mc/mc.hint.uk > ${D}/usr/share/mc/mc.hint.uk_UA.UTF-8
	iconv -fkoi8-r -tutf8 ${D}/usr/share/mc/mc.hlp.ru >  ${D}/usr/share/mc/mc.hlp.ru_RU.UTF-8
	
	dodoc ${FILESDIR}/*.color	
}
