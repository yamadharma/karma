# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2


EAPI=8

# JAVA_PKG_WANT_TARGET=1.8
inherit desktop java-pkg-2

declare -A ARCH_FILES
ARCH_FILES[amd64]="JabRef-${PV}-portable_linux.tar.gz"

DESCRIPTION="Java GUI for managing BibTeX and other bibliographies"
HOMEPAGE="http://www.jabref.org/"
# SRC_URI="https://www.fosshub.com/JabRef.html?dwl=JabRef-${PV}-portable_linux.tar.gz -> JabRef-${PV}-portable_linux.tar.gz"
SRC_URI="https://github.com/JabRef/jabref/releases/download/v${PV}/JabRef-${PV}-portable_linux.tar.gz"


LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

# RESTRICT="fetch preserve-libs strip"
RESTRICT="preserve-libs strip"

DEPEND="app-arch/unzip"

RDEPEND=""

S="${WORKDIR}"

pkg_nofetch() {
	local a
	einfo "Please download these files and move them to your distfiles directory:"
	einfo
	for a in ${A} ; do
		[[ ! -f ${DISTDIR}/${a} ]] && einfo "  ${a}"
	done
	einfo
	einfo "https://www.fosshub.com/JabRef.html"
	einfo
}

src_install() {
	dodir /opt/jabref
	mv ${S}/JabRef/* ${D}/opt/jabref
	dodir /opt/bin
	dosym /opt/jabref/bin/JabRef /opt/bin/jabref-bin
	dosym /opt/jabref/bin/JabRef /opt/bin/jabref
}
