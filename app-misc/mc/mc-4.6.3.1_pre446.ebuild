# Copyright 1999-2005 Gentoo Foundation${WORKDIR}
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools flag-o-matic subversion

ESVN_REPO_URI="http://mc.redhat-club.org/svn/trunk@${PV##*_pre}"

DESCRIPTION="GNU Midnight Commander cli-based file manager"
HOMEPAGE="http://people.redhat-club.org/slavaz/trac/wiki/ProjectMc"
# SRC_URI="http://people.redhat-club.org/inf/mc-slavaz/source/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE="+7zip -attrs +background +editor ext2undel -dnotify gpm +network nls samba +unicode +vfs X"

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
	ext2undel? ( sys-fs/e2fsprogs )
	app-arch/zip
	app-arch/unzip
	7zip? ( app-arch/p7zip )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	dev-util/pkgconfig"

src_prepare() {
	# we need this to fix autoreconf
	mkdir config
	touch config/config.rpath
	eautoreconf
}

src_configure() {
	local myconf=""

	append-flags -I/usr/include/gssapi
	append-flags "-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE"
	filter-flags -malign-double

	# check for conflicts (currently doesn't compile with --without-vfs)
	use vfs || {
		use network || use samba && \
		die "VFS is required for network or samba support."
        }

	use attrs && {
		myconf+=" --enable-preserve-attrs"
		ewarn "'Preserve Attributes' support is currently BROKEN. Use at your own risk."
	}

	use dnotify && {
		myconf+=" --enable-dnotify"
		ewarn "Support for dnotify is currently BROKEN. Use at your own risk."
	}

	use nls \
	    && myconf="${myconf} --with-included-gettext" \
	    || myconf="${myconf} --disable-nls"

	use samba \
		&& myconf+=" --with-samba --with-configdir=/etc/samba --with-codepagedir=/var/lib/samba/codepages --with-privatedir=/etc/samba/private" \
		|| myconf+=" --without-samba"

	if use unicode 
	then
		myconf+=" --enable-utf8 --with-screen=slang"
		append-flags "-DUTF8=1"
	else
		myconf+=" --disable-utf8 --with-screen=ncurses"
		ewarn "Non UTF-8 setup is deprecated."
		ewarn "You are highly encouraged to use UTF-8 compatible system locale."
	fi

	subversion_wc_info
	export MCREVISION="r$ESVN_WC_REVISION"

	econf \
	    --prefix=/usr \
	    --datadir=/usr/share \
	    --sysconfdir=/etc \
	    --with-gnu-ld \
	    $(use_with ext2undel) \
	    $(use_enable nls) \
	    $(use_with editor edit) \
	    $(use_enable network netcode) \
	    $(use_enable background) \
	    $(use_with gpm gpm-mouse) \
	    $(use_with vfs) \
	    $(use_with X x) \
	    --enable-charset \
	    --enable-extcharset \
	    --with-mcfs \
	    --with-subshell \
	    ${myconf} || die
}

src_install() {
	einstall || die

	dodoc ChangeLog AUTHORS MAINTAINERS FAQ INSTALL* NEWS README*

	# Install cons.saver setuid to actually work
	fperms u+s /usr/libexec/mc/cons.saver

	insinto /etc/mc
	doins ${FILESDIR}/mc.gentoo
#	doins ${FILESDIR}/mc.ini

	# http://bugs.gentoo.org/show_bug.cgi?id=71275
	rm -f ${D}/usr/share/locale/locale.alias

	newinitd ${FILESDIR}/mcserv.rc mcserv

	insinto /etc/pam.d
        newins ${FILESDIR}/mcserv.pamd mcserv

	dodoc ${FILESDIR}/*.color
}
