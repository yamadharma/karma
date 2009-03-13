# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit etoile-svn

S1=${S}/Frameworks/EtoileFoundation

DESCRIPTION="Foundation framework extensions from the Etoile project"
HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=EtoileFoundation"
# SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

src_prepare() {
	epatch ${FILESDIR}/mkdtemp.patch
	sed -i -e "s/-Werror/& -fgnu89-inline/" etoile.make || die "sed failed"
}
