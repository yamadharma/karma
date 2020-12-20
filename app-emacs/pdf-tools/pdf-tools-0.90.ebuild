# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Emacs support library for PDF files"
HOMEPAGE="https://github.com/politza/pdf-tools"

if [[ "${PV##*.}" == 9999 ]]
then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/politza/pdf-tools.git"
	KEYWORDS="amd64 ~x86"
else
	SRC_URI="https://github.com/politza/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL"
SLOT="0"
IUSE=""


DEPEND="app-text/poppler
	 virtual/pkgconfig
	 media-libs/libpng
	 sys-devel/autoconf
	 sys-devel/automake
	 sys-devel/gcc
	 sys-libs/zlib
	 virtual/commonlisp"
RDEPEND="${DEPEND}"
