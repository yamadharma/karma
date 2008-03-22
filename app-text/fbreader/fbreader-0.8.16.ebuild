# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="FBReader (E-book reader for Linux PDAs and desktop)"
HOMEPAGE="http://www.fbreader.org/"
SRC_URI="http://www.fbreader.org/${PN}-sources-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
# KEYWORDS="x86 amd64 ~arm ~ppc"
KEYWORDS=""

IUSE="qt3 qt4 gtk kde debug"
DEPEND="dev-libs/expat
	app-arch/bzip2
	qt4? ( =x11-libs/qt-4* )
	qt3? ( =x11-libs/qt-3* )
	gtk? ( >=x11-libs/gtk+-2.4 )
	"
RDEPEND="${DEPEND}"

src_compile () {
	cd ${S}

	sed -i "s:INSTALLDIR=/usr/local:INSTALLDIR=/usr:" makefiles/arch/desktop.mk || die "updating desktop.mk failed"
	echo "TARGET_ARCH = desktop" > makefiles/target.mk

	if use qt4  
	then
	# qt4
		echo "UI_TYPE = qt4" >> makefiles/target.mk

		sed -i "s:MOC = moc-qt4:MOC = /usr/bin/moc:" makefiles/arch/desktop.mk || die "updating desktop.mk failed"
		sed -i "s:UILIBS = -lQtGui:UILIBS = -L/usr/lib/qt4 -lQtGui:" makefiles/arch/desktop.mk
	elif use qt3
	then
	# qt3
		echo "UI_TYPE = qt" >> makefiles/target.mk

		sed -i "s:MOC = moc-qt3:MOC = ${QTDIR}/bin/moc:" makefiles/arch/desktop.mk || die "updating desktop.mk failed"
		sed -i "s:QTINCLUDE = -I /usr/include/qt3:QTINCLUDE = -I ${QTDIR}/include:" makefiles/arch/desktop.mk || die "updating desktop.mk failed"
		sed -i "s:UILIBS = -lqt-mt:UILIBS = -L${QTDIR}/lib -lqt-mt:" makefiles/arch/desktop.mk

	else
	# gtk
		echo "UI_TYPE = gtk" >> makefiles/target.mk
	fi
	
	if use debug ; then
		echo "TARGET_STATUS = debug" >> makefiles/target.mk
	else
		echo "TARGET_STATUS = release" >> makefiles/target.mk
	fi

	emake || die "emake failed"
}


src_install()
{
	emake DESTDIR=${D} install || die "install failed"
	doicon ${D}/usr/share/FBReader/icons/FBReader.png
	make_desktop_entry "FBReader" "FBReader" FBReader.png

	if use kde ; then
		cat > FBReader.desktop <<-EOF
			[Desktop Entry]
			Comment=FBReader (E-book reader for Linux PDAs and desktop)
			Icon=FBReader
			MimeType=text/fbreader
			Patterns=*.fb2;
			Type=MimeType
		EOF
		insinto /usr/share/mimelnk/text
                doins FBReader.desktop
		echo "MimeType=text/fbreader" >> ${D}/usr/share/applications/FBReader-fbreader.desktop
	fi
}
