DESCRIPTION="open source document analysis and OCR system"
HOMEPAGE="http://www.ocropus.org"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="aspell libedit lua sdl"
DEPEND="
	|| ( dev-util/jam dev-util/ftjam )
	media-libs/libpng:1.2
	media-libs/jpeg
	media-libs/tiff
	>app-text/tesseract-2.00
	aspell? ( app-text/aspell )
	lua? (
		sdl? (
			media-libs/libsdl
			media-libs/sdl-gfx
			media-libs/sdl-image
		)
		libedit? ( dev-libs/libedit )
	)
"
RDEPEND="${DEPEND}"

src_compile() {
	econf \
		--with-tesseract=/usr \
		$(use_with aspell) \
		$(use_with lua ocroscript) \
		$(use_with sdl SDL) \
		|| die "econf failed"
	jam -q || die "jam failed"
}

src_install() {
	sed -i 's,^\(INSTALL_DIR = \).*$,\1'"${D}/bin ;," Jamfile
	jam -q install || die "jam install failed"
}
