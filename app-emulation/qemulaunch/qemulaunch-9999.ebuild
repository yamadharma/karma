# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils

ESVN_REPO_URI="http://svn.gna.org/svn/qemulaunch/trunk"

DESCRIPTION="Qemu Launcher is a Gtk front-end for the Qemu x86 PC emulator."
HOMEPAGE="http://emeitner.f2o.org/qemu_launcher"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# qemu is missing in the dependencies on purpose.
DEPEND=""
RDEPEND="${DEPEND}
		>=dev-perl/gtk2-perl-1.141-r1
		>=dev-perl/gtk2-gladexml-1.006
		>=gnome-base/librsvg-2.16.1-r2"

src_unpack() {
	subversion_src_unpack

	cd "${S}"
	epatch "${FILESDIR}/qemulaunch_makefile_prefix.patch"
	epatch "${FILESDIR}/qemulaunch_launcher_kvm.patch"
}

src_install() {
	make install DESTDIR="${D}" || die "installation failed"
}
