#

EAPI="2"

inherit icemake

DESCRIPTION="udev/devfs workalike, based on Duat"
HOMEPAGE="http://kyuba.org/${PN}"
SRC_URI="http://kyuba.org/files/${P}.tar.bz2"

LICENSE="MIT"

SLOT="0"
KEYWORDS="~ppc x86 amd64"

DEPEND="${DEPEND}
        >=dev-p9p/duat-6"

ICEMAKE_PREFIX="/"
