# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
NEED_PYTHON=2.4

inherit distutils bash-completion elisp-common eutils versionator

MY_RV=${PV/_/}
LPV="${MY_RV}"
MY_PV=${MY_RV/beta/b}
MY_P="${PN}-${MY_PV}"
SERIES=$(get_version_component_range 1-2)
S=${WORKDIR}/${MY_P}

DESCRIPTION="Bazaar is a next generation distributed version control system."
HOMEPAGE="http://bazaar-vcs.org/"
SRC_URI="http://launchpad.net/bzr/${SERIES}/${LPV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="curl doc emacs kerberos +sftp test"

python_rdep="|| ( >=dev-lang/python-2.5 dev-python/celementtree )
	sftp? ( >=dev-python/paramiko-1.5 )
	curl? ( dev-python/pycurl )
	kerberos? ( dev-python/pykerberos )
	sys-libs/zlib"
DEPEND="dev-python/pyrex
	!=dev-python/pyrex-0.9.6.3
	emacs? ( virtual/emacs )
	test? (
		${python_rdep}
		|| ( dev-python/pyftpdlib dev-python/medusa )
	)"
RDEPEND="${python_rdep}"

PYTHON_MODNAME="bzrlib"
SITEFILE=71${PN}-gentoo.el

DOCS="README NEWS doc/*.txt"

src_prepare() {
	# Don't run lock permission tests when running as root
	epatch "${FILESDIR}"/${PN}-0.90-tests-fix_root.patch
	# Fix permission errors when run under directories with setgid set.
	epatch "${FILESDIR}"/${PN}-0.90-tests-sgid.patch
}

src_compile() {
	distutils_src_compile
	if use emacs; then
		elisp-compile contrib/emacs/bzr-mode.el || die
	fi
}

src_install() {
	distutils_src_install --install-data /usr/share
	if use doc; then
		docinto developers
		dodoc doc/developers/*
		# TODO (when they offer docs in more languages): support LINGUAS
		local dir
		for	dir in `ls doc/en/`; do
			if test -n "`ls doc/en/${dir}`"; then
				docinto en/"${dir}"
				local f
				for f in `ls doc/en/"${dir}"`; do
					if test -d doc/en/"${dir}/${f}"; then
						docinto en/"${dir}/${f}"
						dodoc doc/en/"${dir}/${f}"/*
						docinto en/"${dir}"
					elif test "$f" != "Makefile"; then
						dodoc doc/en/"${dir}/${f}"
					fi
				done
			fi
		done
	fi
	if use emacs; then
		elisp-install ${PN} contrib/emacs/*.el* || die
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
		# don't add automatically to the load-path, so the sitefile
		# can do a conditional loading
		touch "${D}${SITELISP}/${PN}/.nosearch"
	fi
	insinto /usr/share/zsh/site-functions
	doins contrib/zsh/_bzr
	dobashcompletion contrib/bash/bzr.simple bzr
}

pkg_postinst() {
	distutils_pkg_postinst
	bash-completion_pkg_postinst
	if use emacs; then
		elisp-site-regen
		elog "If you are using a GNU Emacs version greater than 22.1, bzr support"
		elog "is already included.  This ebuild does not automatically activate bzr support"
		elog "in versions below, but prepares it in a way you can load it from your ~/.emacs"
		elog "file by adding"
		elog "       (load \"bzr-mode\")"
	fi
}

pkg_postrm() {
	distutils_pkg_postrm
	use emacs && elisp-site-regen
}

src_test() {
	PYTHONPATH="build/lib*" "${python}" "${S}"/bzr --no-plugins selftest \
		|| die
}
