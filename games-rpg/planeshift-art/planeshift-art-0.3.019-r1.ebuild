# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/planeshift-art/planeshift-art-0.3.019-r1.ebuild,v 1.3 2007/07/10 12:00:00 loux.thefuture Exp $

inherit games eutils

DESCRIPTION="Virtual fantasy world MMORPG"
HOMEPAGE="http://www.planeshift.it/"
MY_P="PlaneShift_CBV0.3.019-x86.bin"
SRC_URI="http://dev.gentooexperimental.org/~loux/distfiles/${MY_P} http://dev.gentooexperimental.org/~loux/distfiles/bronzedoors.zip"

LICENSE="PlaneShift"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=games-rpg/planeshift-0.3.019"

S=${WORKDIR}/art

PLANESHIFT_PREFIX=/opt/planeshift

src_unpack() {
	check_license ${FILESDIR}/PlaneShift
	cp ${DISTDIR}/${MY_P} ${WORKDIR}/.
	chmod +x ${WORKDIR}/${MY_P}
	${WORKDIR}/${MY_P} --prefix ${WORKDIR} --mode unattended
}

src_install() {
	dodir ${PLANESHIFT_PREFIX}/bin
	cp -R ${WORKDIR}/PlaneShift/art ${D}${PLANESHIFT_PREFIX}/bin/.
	cp ${DISTDIR}/bronzedoors.zip ${D}${PLANESHIFT_PREFIX}/bin/art/world/.
	cp -R ${WORKDIR}/PlaneShift/data ${D}${PLANESHIFT_PREFIX}/bin/.

	chgrp -R games "${D}${PLANESHIFT_PREFIX}"
	chmod -R g+rw "${D}${PLANESHIFT_PREFIX}"
}

