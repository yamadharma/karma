#

EAPI="2"

inherit icemake

DESCRIPTION="Communications library (9P2000, etc) based on Curie"
HOMEPAGE="http://kyuba.org/${PN}"
SRC_URI="http://kyuba.org/files/${P}.tar.bz2"

LICENSE="MIT"

DEPEND="${DEPEND}
        >=sys-libs/curie-8"

KEYWORDS="~ppc x86 amd64"
ICEMAKE_PREFIX="/"
SLOT="0"
