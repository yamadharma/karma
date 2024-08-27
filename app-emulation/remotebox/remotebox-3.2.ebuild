# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Open Source VirtualBox Client with Remote Management"
HOMEPAGE="http://remotebox.knobgoblin.org.uk/"

MY_P="RemoteBox-${PV}"
SRC_URI="http://remotebox.knobgoblin.org.uk/downloads/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0/5.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.10
	x11-libs/gtk+:3
	dev-perl/SOAP-Lite
	dev-perl/libwww-perl
	dev-perl/Gtk2
	x11-misc/xdg-utils
	"
RDEPEND="${DEPEND}"


src_prepare() {
    # Call default handler
    default

    # Change paths
    sed -i -e "s|^\(use lib \"\).*\(\";\)$|\1/usr/share/remotebox\2|" remotebox || die
    sed -i -e "s|^\(our \$sharedir = \"\).*\(\";\)$|\1/usr/share/remotebox\2|" remotebox || die
    sed -i -e "s|^\(our \$docdir\)  \( = \"\).*\(\";\)$|\1\2/usr/share/doc/${P}\3|" remotebox || die

    # Cleanup comments
    sed -i -e "/^# \^\^\^.*$/d" remotebox || die
    sed -i -e "/^# \*\*\*.*$/d" remotebox || die
}

src_install() {
    # Install executable
    dobin remotebox || die

    # Install resources
    insinto /usr && doins -r share || die

    # Install documents
    dodoc docs/COPYING docs/changelog.txt || die

    # Install .desktop file
    domenu packagers-readme/remotebox.desktop || die

    # Install application icon
    doicon share/remotebox/icons/remotebox.png || die
}

pkg_postinst() {
    elog "This version of RemoteBox requires VirtualBox 7.0.x running on the server"
    elog "For details, refer to http://remotebox.knobgoblin.org.uk/documentation.cgi"
}
