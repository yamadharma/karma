# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/emacs-w3m/emacs-w3m-1.4.1.ebuild,v 1.1 2004/07/08 16:49:20 usata Exp $

inherit elisp

IUSE=""
MY_P="${P/_/}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="emacs-w3m is an interface program of w3m on Emacs."
HOMEPAGE="http://emacs-w3m.namazu.org"
SRC_URI="http://emacs-w3m.namazu.org/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~alpha ~sparc ~ppc"

DEPEND="virtual/emacs
	virtual/w3m"

src_compile() {
	./configure --prefix=/usr \
		--with-lispdir=${SITELISP}/${PN} \
		--with-icondir=${SITELISP}/${PN}/icon

	make || die
}

src_install () {
	make lispdir=${D}/${SITELISP}/${PN} \
		infodir=${D}/usr/share/info \
		ICONDIR=${D}${SITELISP}/${PN}/icon \
		install || die

	make lispdir=${D}/${SITELISP}/${PN} \
		ICONDIR=${D}${SITELISP}/${PN}/icon \
		install-icons || die

	use ecf || elisp-site-file-install ${FILESDIR}/70emacs-w3m-gentoo.el

	dodoc ChangeLog* README*
}

pkg_postinst() {
#	elisp-site-regen
	einfo "Please see /usr/share/doc/${P}/README.gz."
	einfo
	einfo "If you want to use shimbun library, please emerge app-emacs/apel and app-emacs/flim."
	einfo
}

#pkg_postrm() {
#	elisp-site-regen
#}

# Local Variables:
# mode: sh
# End:
