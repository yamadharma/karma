#

EAPI="2"

inherit icemake

DESCRIPTION="A minimalistic, sexpr-based, non-posix(!), non-ansi(!) libc"
HOMEPAGE="http://kyuba.org/${PN}"
SRC_URI="http://kyuba.org/files/${P}.tar.bz2"

LICENSE="MIT"

SLOT="0"
KEYWORDS="~arm ~ppc x86 amd64"

ICEMAKE_PREFIX="/"
ICEMAKE_TARGETS="curie curie++ syscall"
