# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a modification of the official psi ebuild
# Jingle 0.11 doesn't support jingle yet...

inherit eutils darcs qt4

EDARCS_REPOSITORY="http://dev.psi-im.org/darcs/psi"
#EDARCS_REPO_URI="http://dev.psi-im.org/darcs/psi-jingle/"
EDARCS_GET_CMD="get --partial --verbose"

IUSE="kde ssl"
DESCRIPTION="QT 4.x Jabber Client, with Licq-like interface"
HOMEPAGE="http://psi.affinix.com"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~sparc x86"

DEPEND=">=x11-libs/qt-4.1.0"
#>=app-crypt/qca-2.0_beta1

RDEPEND="!net-im/psi"

# I can't make qca-openssl compile on my amd64 and gnupg isn't supported yet
#ssl? ( >=app-crypt/qca-openssl-0.1.20050811 )"
#	crypt? ( >=app-crypt/gnupg-1.2.2 )
		    
#dev-libs/ilbc-rfc3951	

src_compile() {
	local myconf=""
	myconf="${myconf} --enable-jingle"
	myconf="${myconf} --enable-plugins --enable-google-ft"
	./configure-jingle ${myconf} --prefix=/usr --qtdir=/usr
	emake || die "Make failed"
}

src_install() {
	make INSTALL_ROOT="${D}" install || die "Make install failed"

	#this way the docs will also be installed in the standard gentoo dir
	for i in roster system emoticons; do
		newdoc ${S}/iconsets/${i}/README README.${i}
	done;
	newdoc certs/README README.certs
	dodoc README TODO
	dodir /usr/lib
}

