# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Videotrans is a set of scripts that allow its user to reformat existing movies into the VOB format that is used on DVDs."
HOMEPAGE="http://videotrans.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"

IUSE="debug"
DEPEND="  media-video/mplayer
	>=media-video/ffmpeg-0.4.9_p20050906	
       "
RDEPEND="${DEPEND}"

#src_unpack() {
#	unpack ${A}
#
#	cd ${S}
#	epatch ${FILESDIR}/${PN}-1.2-suspend2.patch || die "suspend2 patch failed"
#
#	einfo "The only kernels that will work are gentoo-sources, vanilla-sources, and suspend2-sources."
#	einfo "No other kernels are supported. Kernels like the mm kernels will NOT work."
#
#	convert_to_m ${S}/driver/Makefile
#}

#src_compile() {
#	# Enable verbose debugging information
#	use debug && export DEBUG=3
#
#	cd utils
#	emake || die "Compile of utils failed!"
#
#	linux-mod_src_compile
#
#}

src_install() {
        einfo "Make install"
        make prefix=${D}/usr \
             BINDIR=${D}/usr/bin \
                 LIBDIR=${D}/usr/$(get_libdir) \
             CONFDIR=${D}/usr/share/ \
             DATADIR=${D}/usr/share/ \
             MANDIR=${D}/usr/share/man \
             install || die "Failed to install VideoTrans!"
        einfo "Make install completed"

        dodoc AUTHORS ChangeLog README


	dodoc CHANGES TODO 
	doman *.1  
}

