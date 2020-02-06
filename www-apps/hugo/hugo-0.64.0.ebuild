# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit go-module bash-completion-r1

# The fork with prefetched vendor packages using `go mod vendor`
EGO_PN="github.com/g4s8/hugo"
GIT_COMMIT="6608f1557054a7d0230dff260c1b66bc19e65ec8"
KEYWORDS="~amd64"

DESCRIPTION="The world's fastest framework for building websites"
HOMEPAGE="https://gohugo.io https://github.com/gohugoio/hugo"
#SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/gohugoio/hugo/releases/download/v${PV}/hugo_extended_${PV}_Linux-64bit.tar.gz"
LICENSE="Apache-2.0 Unlicense BSD BSD-2 MPL-2.0"
SLOT="0"
IUSE="+bash-completion doc +sass"

RESTRICT="test"

S=${WORKDIR}

src_install() {
	dobin hugo
	if use bash-completion ; then
		dobashcomp ${FILES}/hugo || die
	fi
	dodoc README*
}
