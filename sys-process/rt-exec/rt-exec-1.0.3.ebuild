# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Test the deterministic/real-time capabilities of your computer."
HOMEPAGE="ftp://ftp.compro.net/public/rt-exec"
SRC_URI="ftp://ftp.compro.net/public/rt-exec/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

IUSE=""
RESTRICT="nomirror"
DEPEND="sys-libs/ncurses"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	sed -i -e 's/#cd/cd/' crunchsys || die "Sed failed"
	cat << EOF > rt-exec-wrapper
#!/bin/bash
# wrapper script for rt-exec binaries 
# --> so binaries will be executed within their directories

# script is inspired by gentoo am-wrapper.sh script
# distributed under GPL v2

caller="\${0##*/}"
rt_exec_binaries_path="/usr/lib/rt-exec"
args="\${@}"

if [ "\${caller}" == "rt-exec-wrapper" ] || [ "\${#caller}" == "0" ]; then
	echo "Don't call this script directly." >&2
	exit 1
fi

cd "\${rt_exec_binaries_path}"
exec ./"\${caller}" \${args}

echo "rt-exec-wrapper: was unable to exec \${caller} !?" >&2
exit 1
EOF
}

src_compile() {
	emake clean veryclean all || die "Compilation failed"
}

src_install() {
	dodoc COPYING README || die "Doc installation failed"
	rm *.c
	exeopts -m0744
	exeinto /usr/lib/rt-exec
	doexe rt-exec-wrapper crunchsys exec go killtasks mon start stop_exec task* || die "Binaries installation failed"
	dosym ../lib/rt-exec/rt-exec-wrapper /usr/sbin/crunchsys
	dosym ../lib/rt-exec/rt-exec-wrapper /usr/sbin/go
	dosym ../lib/rt-exec/rt-exec-wrapper /usr/sbin/mon
	dosym ../lib/rt-exec/rt-exec-wrapper /usr/sbin/start
	dosym ../lib/rt-exec/rt-exec-wrapper /usr/sbin/stop_exec
	insinto /usr/lib/rt-exec
	doins sche* || die "Configuration files installation failed"
}

pkg_postinst() {
	einfo "please read this file"
	einfo "/usr/share/doc/${PF}/README"
	ewarn "NOTE: other than mentioned in the README"
	ewarn "you can call the apps within any directory"
	ewarn "because we've added a wrapper script which hopefully"
	ewarn "solve this limitation"
}
