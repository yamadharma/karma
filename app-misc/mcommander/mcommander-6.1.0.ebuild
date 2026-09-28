# Copyright 2026 Ilia Maslakov
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="M-Commander, a fork of GNU Midnight Commander with loadable panel plugins"
HOMEPAGE="https://github.com/blue-panels/mcommander"
SRC_URI="https://github.com/blue-panels/mcommander/releases/download/v${PV}/mcommander-${PV}.tar.gz"
S="${WORKDIR}/mcommander-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+arcmc +ftp +gpm +magic mongo +samba +sftp +shell-link +shell-ssh2 +slang"
REQUIRED_USE="shell-ssh2? ( shell-link )"

# M-Commander больше не блокирует app-misc/mc, так как устанавливает
# собственные исполняемые файлы (mcommander, mcedit6, mview, mdiff)
# и может сосуществовать с GNU Midnight Commander[reference:1].
COMMON_DEPEND="
	dev-libs/glib:2
	slang? ( sys-libs/slang )
	!slang? ( sys-libs/ncurses:0= )
	gpm? ( sys-libs/gpm )
	magic? ( sys-apps/file )
	samba? ( net-fs/samba )
	ftp? ( net-misc/curl )
	arcmc? ( app-arch/libarchive )
	mongo? ( dev-libs/mongo-c-driver )
	sftp? ( net-libs/libssh2 )
	shell-ssh2? ( net-libs/libssh2 )
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		--disable-static
		--with-screen="$(usex slang slang ncurses)"
		--with-panel-plugins-dir="/usr/$(get_libdir)/mcommander/panel-plugins"
		--with-editor-plugins-dir="/usr/$(get_libdir)/mcommander/editor-plugins"
		--enable-mcterm=yes
		$(use_with gpm gpm-mouse)
		$(use_enable magic mctree-magic)
		$(use_enable samba panel-plugin-samba)
		$(use_enable ftp panel-plugin-ftp)
		$(use_enable arcmc panel-plugin-arcmc)
		$(use_enable mongo panel-plugin-mongo)
		$(use_enable sftp panel-plugin-sftp)
		$(use_enable shell-link panel-plugin-shell-link)
		$(use_enable shell-ssh2 shell-ssh2)
	)
	econf "${myconf[@]}"
}

DOCS=( CHANGELOG.md README.md )

src_install() {
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -delete || die
	einstalldocs
}

pkg_postinst() {
	elog "M-Commander установлен как mcommander (короткий алиас: mc6)."
	elog "Редактор, просмотрщик и diff-просмотрщик доступны как mcedit6, mview и mdiff."
	elog "Пакет может сосуществовать с app-misc/mc, так как использует собственные имена."
}