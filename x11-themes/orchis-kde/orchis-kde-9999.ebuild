# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Orchis themes for kde plasma"
HOMEPAGE="https://github.com/vinceliuice/Orchis-kde"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vinceliuice/Orchis-kde.git"
	KEYWORDS="amd64 ~x86"
else
	SRC_URI="https://github.com/vinceliuice/Orchis-kde/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		x11-themes/kvantum"
BDEPEND=""

src_install() {
	    AURORAE_DIR="/usr/share/aurorae/themes"
	    SCHEMES_DIR="/usr/share/color-schemes"
	    PLASMA_DIR="/usr/share/plasma/desktoptheme"
	    LOOKFEEL_DIR="/usr/share/plasma/look-and-feel"
	    KVANTUM_DIR="/usr/share/Kvantum"
	    WALLPAPER_DIR="/usr/share/wallpapers"

	    dodir ${AURORAE_DIR}
	    dodir ${SCHEMES_DIR}
	    dodir ${PLASMA_DIR}
	    dodir ${LOOKFEEL_DIR}
	    dodir ${KVANTUM_DIR}
	    dodir ${WALLPAPER_DIR}

	    insinto ${AURORAE_DIR}
            doins -r aurorae/*

	    insinto ${SCHEMES_DIR}
	    doins -r color-schemes/*.colors

	    insinto ${KVANTUM_DIR}
	    doins -r Kvantum/*

	    insinto ${PLASMA_DIR}
	    doins -r plasma/desktoptheme/*

	    insinto ${PLASMA_DIR}/Orchis/colors 
	    doins -r color-schemes/Orchis.colors

	    insinto ${PLASMA_DIR}/Orchis-dark/colors 
	    doins -r color-schemes/OrchisDark.colors

	    insinto ${LOOKFEEL_DIR}
	    doins -r plasma/look-and-feel/*

	    insinto ${WALLPAPER_DIR}
	    doins -r wallpaper/*

	    insinto /usr/share/sddm/themes
	    doins -r sddm/Orchis
}
