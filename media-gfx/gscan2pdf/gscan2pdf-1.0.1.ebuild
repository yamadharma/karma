# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit perl-app

DESCRIPTION="Create PDF of selected pages with File/Save PDF"
HOMEPAGE="http://gscan2pdf.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="adf cuneiform doc djvu gocr ocropus tesseract unpaper +xdg"

DEPEND="dev-lang/perl[ithreads]
	>=dev-perl/config-general-2.40"

RDEPEND=">=dev-perl/glib-perl-1.100-r1
	dev-perl/Goo-Canvas
	dev-perl/Gtk2-Ex-Simple-List
	dev-perl/Gtk2-ImageView
	>=dev-perl/gtk2-perl-1.043.1
	>=dev-perl/Locale-gettext-1.05
	dev-perl/Log-Log4perl
	dev-perl/PDF-API2
	dev-perl/Proc-ProcessTable
	dev-perl/Readonly-XS
	dev-perl/Sane
	dev-perl/Set-IntSpan
	dev-perl/Test-Perl-Critic
	virtual/perl-Archive-Tar
	media-gfx/imagemagick[perl]
	media-gfx/sane-backends
	media-libs/tiff
	dev-perl/HTML-Parser
	xdg? ( x11-misc/xdg-utils )
	adf? ( media-gfx/sane-frontends )
	cuneiform? ( app-text/cuneiform )
	doc? ( dev-perl/Gtk2-Ex-PodViewer )
	djvu? ( app-text/djvu )
	gocr? ( app-text/gocr )
	ocropus? ( app-text/ocropus )
	tesseract? ( app-text/tesseract )
	unpaper? ( app-text/unpaper )"

src_install() {
	perl-module_src_install
	dodoc History
}

pkg_postinst() {
	ewarn "Thunderbird users can't use the Email to PDF feature"
	ewarn "because xdg-email doesn't support creating new emails"
	ewarn "with attachments in Thunderbird."
}
