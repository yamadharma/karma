# Copyright 1999-2005 Gentoo Foundation${WORKDIR}
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit flag-o-matic eutils subversion

ESVN_REPO_URI="http://mc.redhat-club.org/svn/trunk@${PV##*_pre}"

MY_P=${P/_pre/-pre}
S=${WORKDIR}/${MY_P}

DESCRIPTION="GNU Midnight Commander cli-based file manager"
HOMEPAGE="http://www.ibiblio.org/mc/
	http://people.redhat-club.org/slavaz/trac/wiki/ProjectMc"
# SRC_URI="ftp://ftp.gnu.org/gnu/mc/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE="gpm nls samba +unicode X"

PROVIDE="virtual/editor"

RDEPEND=">=dev-libs/glib-2
	>=sys-libs/slang-2.1.3
	gpm? ( sys-libs/gpm )
	X? ( x11-libs/libX11
		x11-libs/libICE
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libSM )
	samba? ( net-fs/samba )
	kernel_linux? ( sys-fs/e2fsprogs )
	app-arch/zip
	app-arch/unzip
	app-arch/p7zip"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	dev-util/pkgconfig"

src_prepare() {

#	epatch "${FILESDIR}"/mc-4.6.0-ebuild-syntax.patch

        # fix *.po files
        pushd po
        for i in *.po; do
            msgfmt $i -o "${i%po}gmo"
        done
        popd
}

src_compile() {
	append-flags -I/usr/include/gssapi

        append-flags "-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE"

        if use unicode; then
                append-flags "-DUTF8=1"
        fi


	filter-flags -malign-double

	local myconf=""

	myconf="${myconf} --with-screen=slang"

	myconf="${myconf} `use_with gpm gpm-mouse`"

	use nls \
	    && myconf="${myconf} --with-included-gettext" \
	    || myconf="${myconf} --disable-nls"

	myconf="${myconf} `use_with X x`"

	use samba \
	    && myconf="${myconf} --with-samba --with-configdir=/etc/samba --with-codepagedir=/var/lib/samba/codepages --with-privatedir=/etc/samba/private" \
	    || myconf="${myconf} --without-samba"

	econf \
	    --prefix=/usr \
	    --datadir=/usr/share \
	    --sysconfdir=/etc \
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

	dodoc ChangeLog AUTHORS MAINTAINERS FAQ INSTALL* NEWS README*

	# Install cons.saver setuid to actually work
	fperms u+s /usr/libexec/mc/cons.saver

	insinto /etc/mc
	doins ${FILESDIR}/mc.gentoo
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
