# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# JAVA_PKG_WANT_TARGET=1.8
inherit desktop java-pkg-2

declare -A ARCH_FILES
ARCH_FILES[amd64]="JabRef-portable_linux.tar.gz"

DESCRIPTION="Java GUI for managing BibTeX and other bibliographies"
HOMEPAGE="http://www.jabref.org/"
# SRC_URI="https://www.fosshub.com/JabRef.html?dwl=JabRef-${PV}-portable_linux.tar.gz -> JabRef-${PV}-portable_linux.tar.gz"
SRC_URI="https://github.com/JabRef/jabref/releases/download/v${PV/_alpha/-alpha.}/JabRef-portable_linux.tar.gz  -> JabRef-${PV}-portable_linux.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

RESTRICT="preserve-libs strip"

DEPEND="app-arch/unzip"

RDEPEND=""

S="${WORKDIR}"

src_install() {
	dodir /opt/jabref
	mv ${S}/JabRef/* ${D}/opt/jabref
	dodir /opt/bin
	dosym /opt/jabref/bin/JabRef /opt/bin/jabref-bin
	dosym /opt/jabref/bin/JabRef /opt/bin/jabref
}
