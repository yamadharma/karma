# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs
RESTRICT="nomirror"
DESCRIPTION="Give unpriviledged users access to realtime scheduling"
HOMEPAGE="http://www.physics.adelaide.edu.au/~jwoithe"
SRC_URI="http://www.physics.adelaide.edu.au/~jwoithe/${P}.tgz"

LICENSE="GPLv2"
SLOT="0"
KEYWORDS="x86 ppc amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack(){
	unpack "${A}"
	cd "${S}"
	# patch DESTDIR and manpage location
	sed -i -e 's:\(\$(PREFIX)\):\$(DESTDIR)\1:g' \
		 -e	's:\(\$(SYSCONFDIR)\):\$(DESTDIR)\1:g' \
		 -e 's:\(man\/\):\/share\/\1:g' Makefile
cat << EOF >> set_rlimits.conf

# example settings (gentoo proaudio overlay)
@audio  /usr/bin/jackd          nice=-1 rtprio=85
@audio  /usr/bin/qjackctl       nice=-1 rtprio=84
@audio  /usr/bin/ardour         nice=-1 rtprio=83
@audio  /usr/bin/hydrogen       nice=-1 rtprio=82
@audio  /usr/bin/jackeq         nice=-1 rtprio=81
@audio  /usr/bin/jack-rack      nice=-1 rtprio=80
@audio  /usr/bin/jamin          nice=-1 rtprio=79
@audio  /usr/bin/qsynth         nice=-1 rtprio=78
@audio  /usr/bin/rosegarden     nice=-1 rtprio=77
@audio  /usr/bin/seq24          nice=-1 rtprio=76
@audio  /usr/bin/specimen       nice=-1 rtprio=75
@audio  /usr/bin/vkeybd         nice=-1 rtprio=74
@audio  /usr/bin/zynaddsubfx    nice=-1 rtprio=73
@audio	/usr/bin/ams		nice=-1	rtprio=72
@audio	/usr/bin/amsynth	nice=-1	rtprio=71
EOF
}

src_compile(){
	emake clean 
	$(tc-getCC) -Wall ${CFLAGS} -g -o set_rlimits set_rlimits.c || die "compilation failed"
}

src_install(){
	make PREFIX="/usr" DESTDIR="${D}" install || die "install failed"
	dodoc COPYING AUTHORS README
	prepall
	prepalldocs
}

