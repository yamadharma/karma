# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module latex-package

DESCRIPTION="A modern (La)TeX to XML/HTML conversion tool"
HOMEPAGE="http://dlmf.nist.gov/LaTeXML/"

SRC_URI="http://dlmf.nist.gov/LaTeXML/releases/${P}.tar.gz"

LICENSE="public-domain"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

# Build-time dependencies, such as
#    ssl? ( >=dev-libs/openssl-0.9.6b )
#    >=dev-lang/perl-5.6.1-r1
# It is advisable to use the >= syntax show above, to reflect what you
# had installed on your system when you tested the package.  Then
# other users hopefully won't be caught without the right version of
# a dependency.
DEPEND="virtual/perl-DB_File
		dev-perl/Parse-RecDescent
		dev-perl/File-Which
		>=dev-perl/XML-LibXML-0.61
		>=dev-perl/XML-LibXSLT-1.58
		virtual/perl-Test-Simple
		dev-perl/libwww-perl
		dev-perl/Text-Unidecode
		dev-perl/IO-String
		dev-perl/Archive-Zip
		dev-perl/Image-Size
		media-gfx/imagemagick[perl]"

RDEPEND="${DEPEND}"

#S=${WORKDIR}/${P}

myconf="TEXMF=/usr/share/texmf-site/"

src_install() {
	emake install || die "emake install failed"
	perl_delete_module_manpages
	perl_delete_localpod
	perl_delete_packlist
	rm "${D}/usr/share/texmf-site/tex/latex/latexml/.packlist"
	perl_remove_temppath

	dodoc manual.pdf INSTALL Changes

	perl_link_duallife_scripts
}
