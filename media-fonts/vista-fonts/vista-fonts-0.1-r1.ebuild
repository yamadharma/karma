EAPI="2"

inherit font 

DL_HOST=download.microsoft.com
DL_PATH=download/f/5/a/f5a3df76-d856-4a61-a6bd-722f52a5be26
ARCHIVE=PowerPointViewer.exe

DESCRIPTION="Original Vista Fonts"
HOMEPAGE=""
SRC_URI="http://$DL_HOST/$DL_PATH/$ARCHIVE"

FONT_SUPPLIER="microsoft"
S=${WORKDIR}
FONT_S=${WORKDIR}
FONT_SUFFIX="ttf"


LICENSE="MSttfEULA"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""
RESTRICT="nostrip"

DEPEND="app-arch/cabextract"
RDEPEND=""

src_unpack() {
	for exe in ${A} ; do
		echo ">>> Unpacking ${exe} to ${WORKDIR}"
		cabextract --lowercase -F ppviewer.cab "${DISTDIR}"/${exe} > /dev/null \
			|| die "failed to unpack ${exe}"
		cabextract --lowercase -F '*.TT[FC]' ppviewer.cab > /dev/null \
			|| die "failed to unpack ${exe}"
	done
}

src_prepare() {
	mv cambria.ttc cambria.ttf
}

