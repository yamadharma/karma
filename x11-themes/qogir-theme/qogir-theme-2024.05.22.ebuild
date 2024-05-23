# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Qogir is a flat Design theme for GTK"
HOMEPAGE="https://github.com/vinceliuice/Qogir-theme"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}"
else
	SRC_URI="${HOMEPAGE}/archive/${PV//./-}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
	S="${WORKDIR}/Qogir-theme-${PV//./-}"
fi

LICENSE="GPL-3"
RESTRICT="mirror"
SLOT="0"

DEPEND="x11-libs/gtk+:2
	>=x11-libs/gtk+-3.18:3
	x11-themes/gtk-engines-murrine"
RDEPEND="${DEPEND}"

src_install(){
	dodir /usr/share/themes
	./install.sh --dest "${ED}/usr/share/themes" --theme "default" --icon "gentoo" --libadwaita || die
}
