# Distributed under the terms of the GNU General Public License v2

inherit eutils gnome2 libtool autotools versionator subversion

ESVN_PROJECT=dia

# ESVN_OPTIONS="-r${PV/*_pre}"
ESVN_REPO_URI="http://svn.gnome.org/svn/dia/trunk"

# S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="Diagram/flowchart creation program (source from CVS)"
HOMEPAGE="http://www.gnome.org/projects/dia/"
SRC_URI=""
IUSE="doc gnome png python zlib cairo gnome-print"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
#KEYWORDS=""

RDEPEND=">=x11-libs/gtk+-2.6.0
	>=dev-libs/glib-2.6.0
	>=x11-libs/pango-1.1.5
	>=dev-libs/libxml2-2.3.9
	>=dev-libs/libxslt-1
	>=media-libs/freetype-2.0.95
	dev-libs/popt
	zlib? ( sys-libs/zlib )
	png? ( media-libs/libpng
		>=media-libs/libart_lgpl-2 )
	gnome? ( >=gnome-base/libgnome-2.0
		>=gnome-base/libgnomeui-2.0 )
	gnome-print? ( gnome-base/libgnomeprint )
	cairo? ( x11-libs/cairo )
	python? ( >=dev-lang/python-1.5.2
		>=dev-python/pygtk-1.99 )
	doc? (
		=app-text/docbook-xml-dtd-4.2*
		app-text/docbook-xsl-stylesheets )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.21
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog KNOWN_BUGS NEWS README RELEASE-PROCESS THANKS TODO"

G2CONF="${G2CONF}
	$(use_enable gnome)
	$(use_with python)
	$(use_with cairo)"

DOCS="AUTHORS ChangeLog COPYING KNOWN_BUGS MAINTAINERS NEWS README RELEASE-PROCESS THANKS TODO"

#pkg_setup() {
#	G2CONF="${G2CONF}
#		$(use_enable gnome)
#		$(use_with gnome-print gnomeprint)
#		$(use_with python)
#		$(use_with cairo)
#		$(use_enable doc db2html)"
#}

src_unpack() {
	subversion_src_unpack

	# Disable python -c 'import gtk' during compile to prevent using
	# X being involved (#31589)
	# changed the patch to a sed to make it a bit more portable - AllanonJL
	sed -i -e '/AM_CHECK_PYMOD/d' configure.in

	echo "Running gettextize..."
	glib-gettextize --copy --force

	echo "Running intltoolize"
	intltoolize --copy --force --automake

	echo "Running libtoolize"
	libtoolize --copy --force

	aclocal $ACLOCAL_FLAGS
	autoheader
	automake --add-missing 
	autoconf
}

src_compile() {
	econf \
		$(use_enable gnome) \
		$(use_with gnome-print gnomeprint) \
		$(use_with python) \
		$(use_with cairo) \
		$(use_enable doc db2html)

	emake SWIG=swig
}

