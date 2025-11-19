# From https://github.com/quarto-dev/quarto-cli/discussions/5065
EAPI=8
DESCRIPTION="An open-source scientific and technical publishing system"
HOMEPAGE="https://quarto.org/
	https://github.com/quarto-dev/quarto-cli
	"

SRC_URI="https://github.com/quarto-dev/quarto-cli/releases/download/v${PV}/${P}-linux-amd64.tar.gz"

SLOT="0"
#KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="$DEPEND
		dev-texlive/texlive-xetex
"

S="${WORKDIR}/${P}"

RESTRICT="strip"

src_compile() {
	:
}

src_install() {
	insinto /opt/${PN}
	cp -R . ${D}/opt/${PN} || die "Failed to install the package into '/opt/${PN}'"
	dosym /opt/${PN}/bin/quarto /usr/bin/quarto
}
