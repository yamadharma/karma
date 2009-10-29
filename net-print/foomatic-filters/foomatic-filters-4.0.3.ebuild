# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Foomatic wrapper scripts"
HOMEPAGE="http://www.linuxprinting.org/foomatic.html"
SRC_URI="http://www.linuxprinting.org/download/foomatic/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="cups"

RDEPEND="cups? ( >=net-print/cups-1.1.19 )
	!cups? (
		|| (
			app-text/enscript
			app-text/a2ps
			app-text/mpage
		)
	)
	dev-lang/perl
	virtual/ghostscript"
DEPEND="${RDEPEND}"

pkg_setup() {
	if use cups; then
		CUPS_SERVERBIN="$(cups-config --serverbin)"
	else
		CUPS_SERVERBIN=""
	fi

	export CUPS_BACKENDS=${CUPS_SERVERBIN}/backend \
		CUPS_FILTERS=${CUPS_SERVERBIN}/filter CUPS=${CUPS_SERVERBIN}/

}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dosym /usr/bin/foomatic-rip /usr/bin/lpdomatic

	if use cups; then
		dosym /usr/bin/foomatic-gswrapper "${CUPS_SERVERBIN}/filter/foomatic-gswrapper"
		dosym /usr/bin/foomatic-rip "${CUPS_SERVERBIN}/filter/cupsomatic"
	else
		rm -r "${D}"/${CUPS_SERVERBIN}/filter
		rm -r "${D}"/${CUPS_SERVERBIN}/backend
	fi
}
