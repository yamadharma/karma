EAPI=6

inherit eutils

VERSION="5.0.0AB.7"
DESCRIPTION="Linux port of windows defragmenter utility"
HOMEPAGE="http://jp-andre.pagesperso-orange.fr/advanced-ntfs-3g.html"
SRC_URI="http://jp-andre.pagesperso-orange.fr/ultradefrag-${VERSION}.zip"

S="${WORKDIR}/${PN}-${VERSION}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-fs/ntfs3g
	sys-libs/ncurses[tinfo]"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}.patch
}

src_compile() {
	cd src
	emake
}

src_install() {
	dosbin src/udefrag
}
