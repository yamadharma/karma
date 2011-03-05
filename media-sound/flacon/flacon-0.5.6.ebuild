# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="cue2tracks gui alternative"
HOMEPAGE="http://kde-apps.org/content/show.php/Flacon?content=113388"
SRC_URI="http://flacon.googlecode.com/files/${P}.tgz"

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flac mp3 ogg wavpack"
EAPI="2"

RDEPEND="dev-lang/python
	dev-python/PyQt4
	media-sound/shntool
	flac? ( media-libs/flac )
	wavpack? ( media-sound/wavpack )
	ogg? ( media-libs/libogg media-sound/vorbisgain )
	mp3? ( media-sound/lame media-sound/mp3gain )"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
