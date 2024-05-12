# Copyright 1999-2011 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

# inherit eutils

DESCRIPTION="Emacs Configuration Framework meta package"
HOMEPAGE="https://github.com/yamadharma/ecf"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

IUSE="${IUSE}"

PDEPEND="app-emacs/ecf
	media-fonts/fira-code
	sys-apps/ripgrep
	sys-apps/fd
	media-gfx/ditaa
	dev-tex/LaTeXML
	app-editors/emacs-lsp-booster
"

# Local Variables:
# mode: sh
# End:
