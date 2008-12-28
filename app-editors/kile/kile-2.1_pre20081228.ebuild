# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

KMNAME="extragear/office"

inherit kde4-base subversion

DESCRIPTION="A Latex Editor and TeX shell for kde"
HOMEPAGE="http://kile.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/trunk/extragear/office/${PN}/@{${PV/2.1_pre/}}"
DEPEND="dev-lang/perl"
RDEPEND="virtual/tex-base
	virtual/latex-base"

# Suggestions:
# app-text/acroread: Display pdf files
# app-text/dvipdfmx: Convert dvi files to pdf
# app-text/dvipng: Convert dvi files to png
# app-text/ghostscript-gpl: Display ps files
# dev-tex/latex2html: Compile latex files as html
# kde-base/okular: View document files
# media-gfx/imagemagick: ?
#PDEPEND="
#	app-text/acroread
#	app-text/dvipdfmx
#	app-text/dvipng
#	app-text/ghostscript-gpl
#	dev-tex/latex2html
#	kde-base/okular:${SLOT}
#	media-gfx/imagemagick"

src_install() {
	kde4-base_src_install

	rm ${D}/usr/kde/4.2/share/icons/hicolor/64x64/actions/preview.png
	rm ${D}/usr/kde/4.2/share/apps/katepart/syntax/bibtex.xml
	rm ${D}/usr/kde/4.2/share/apps/katepart/syntax/latex.xml
}