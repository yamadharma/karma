# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit etoile-svn toolchain-funcs

S1="${S}/Languages/Smalltalk"

SQLITE="sqlite-3.6.2"
DESCRIPTION="Étoilé's Pragmatic Smalltalk, a Smalltalk JIT compiler which generates code binary-compatible with Objective-C"
HOMEPAGE="http://www.etoile-project.org"
#SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz
#	http://www.sqlite.org/${SQLITE}.tar.gz"

SRC_URI="http://www.sqlite.org/${SQLITE}.tar.gz"


LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="gnustep-libs/etoile-foundation
	gnustep-libs/languagekit"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	subversion_src_unpack
}

src_prepare() {
	sed -i -e "s/-Werror/& -fgnu89-inline/" etoile.make || die "sed failed"

	# Copy updated lempar.c
	cd "${S1}"
	cp "${WORKDIR}/${SQLITE}/tool/lempar.c" .
	# Use our own lemon in GNUmakefile
	sed -i -e "s#@lemon#@./lemon#" GNUmakefile || die "makefile sed failed"
}

src_compile() {
	cd "${S1}"
	# Compile lemon
	$(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} \
		"${WORKDIR}/${SQLITE}/tool/lemon.c" -o lemon \
		|| die "lemon compilation failed"
	# Go on with compilation
	etoile-svn_src_compile
}
