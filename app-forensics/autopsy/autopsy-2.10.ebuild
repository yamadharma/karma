# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a small modification of the official autopsy ebuild

inherit eutils

DESCRIPTION="A graphical interface to the digital forensic analysis tools in The Sleuth Kit."
HOMEPAGE="http://www.sleuthkit.org/autopsy/"
SRC_URI="mirror://sourceforge/autopsy/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~s390 ~sparc x86"
IUSE=""

# Runtime depend on grep and file deliberate
RDEPEND="dev-lang/perl
	>=app-forensics/sleuthkit-2
	sys-apps/grep
	sys-apps/file"
DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}

	echo "#!/usr/bin/perl -wT" > autopsy
	echo "use lib '/usr/lib/autopsy/';" >> autopsy
	echo "use lib '/usr/lib/autopsy/lib/';" >> autopsy
	cat base/autopsy.base >> autopsy
	sed -i 's:conf.pl:/etc/autopsy.pl:' autopsy lib/Main.pm
}

src_compile() {
	einfo "nothing to compile"
}

src_install() {
	insinto /usr/lib/autopsy
	doins autopsy
	insinto /usr/lib/autopsy/help
	doins help/*
	insinto /usr/lib/autopsy/lib
	doins lib/*
	insinto /usr/lib/autopsy/pict
	doins pict/*
	insinto /etc
	doins ${FILESDIR}/autopsy.pl

	dodir /usr/bin
	dosym /usr/lib/autopsy/autopsy /usr/bin/autopsy
	fperms +x /usr/lib/autopsy/autopsy

	doman man/man1/autopsy.1
	dodoc CHANGES.txt README.txt TODO.txt docs/sleuthkit-informer-13.txt
}
