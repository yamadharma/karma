#
inherit eutils

DESCRIPTION="Merge JPEG files into PDF"
SRC_URI="http://koan.studentenweb.org/software/${P}.tar.bz2"
HOMEPAGE="http://koan.studentenweb.org/software/jpeg2pdf.html"

SLOT="0"
LICENSE="X11/own"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=dev-lang/ruby-1.8.2"

src_install() {
	dodoc LICENSE README
	ruby install.rb config --prefix=${D}/usr
	ruby install.rb install
	rm -f ${D}/usr/bin/test.rb
}
