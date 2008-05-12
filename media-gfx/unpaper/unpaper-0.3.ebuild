DESCRIPTION="a post-processing tool for scanned sheets of paper"
HOMEPAGE="http://unpaper.berlios.de/"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	./make.sh || die 'make.sh failed'
}

src_install() {
	sed -i 's,^\(INST_DIR=\).*$,\1'"${D}/bin," make.sh
	mkdir "${D}/bin"
	./make.sh install || die 'make.sh install failed'
	
	dodoc CHANGELOG
	dodoc LICENSE
	dodoc README
	dohtml -a html,png,odg,js,css,gif -r doc/*
}
