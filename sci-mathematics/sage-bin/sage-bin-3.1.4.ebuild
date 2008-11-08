# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

MY_P="${P/-bin/}"

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography,
and numerical computation."
HOMEPAGE="http://www.sagemath.org"
SRC_URI="x86? ( http://sagemath.org/bin/linux/32bit/${MY_P}-rhel5-32bitIntelXeon-i686-Linux.tar.gz )
	amd64? ( http://sagemath.org/bin/linux/64bit/${MY_P}-fc8-x86_64-Linux.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""

RDEPEND=">=virtual/jre-1.4
	${DEPEND}"

pkg_setup() {
	if use x86
	then 
	    MY_SRC="${MY_P}-rhel5-32bitIntelXeon-i686-Linux" 
	fi

	if use amd64
	then 
	    MY_SRC="${MY_P}-fc8-x86_64-Linux"
	fi
}

src_install() {
	dodir /opt/sage-bin
	mv "${MY_SRC}" "${D}"/opt/sage-bin
	dosym /opt/sage-bin/"${MY_SRC}"/sage /usr/bin/sage
}


pkg_postinst() {
	# Running corrects all paths to the new location
	/usr/bin/sage <<< quit
}

