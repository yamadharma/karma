# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a modification of the official psi ebuild

inherit eutils darcs

#EDARCS_REPO_URI="http://dev.psi-im.org/darcs/psi"
EDARCS_REPO_URI="http://dev.psi-im.org/darcs/psi-jingle/"

IUSE="ssl crypt"
DESCRIPTION="QT 3.x Jabber Client, with Licq-like interface and voice support (Jingle)"
HOMEPAGE="http://psi.affinix.com"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~sparc x86"

DEPEND=">=app-crypt/qca-1.0-r2
	>=x11-libs/qt-3.3.1"

RDEPEND="ssl? ( >=app-crypt/qca-tls-1.0-r2 )
	crypt? ( >=app-crypt/gnupg-1.2.2 )
	dev-libs/expat
	media-libs/speex
	net-libs/ortp"
		    
#dev-libs/ilbc-rfc3951	

src_compile() {
        local myconf="${myconf} --enable-jingle"
	./configure --prefix=/usr ${myconf} || die "Configure failed"

	${QTDIR}/bin/qmake psi.pro \
			QMAKE_CXXFLAGS_RELEASE="${CXXFLAGS} ${extras}" \
			QMAKE_RPATH= \
			|| die "Qmake failed"

	addwrite "$HOME/.qt"
	addwrite "$QTDIR/etc/settings"
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
	if (use jingle); then
    	    dosym /usr/lib/linphone/liblinphone.so /usr/lib/liblinphone.so.1
	fi
}

