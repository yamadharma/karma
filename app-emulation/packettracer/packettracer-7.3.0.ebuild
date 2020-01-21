# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils xdg-utils unpacker

DESCRIPTION="Cisco's packet tracer"
HOMEPAGE="https://www.netacad.com/about-networking-academy/packet-tracer"
SRC_URI="
	amd64? ( "PacketTracer_730_amd64.deb" )
"

LICENSE="Cisco_EULA"
SLOT="0"
# KEYWORDS="amd64"
IUSE=""
RESTRICT="fetch mirror strip userpriv"

DEPEND="
	app-arch/gzip
	dev-util/patchelf"
RDEPEND="${DEPEND}
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-libs/icu
	dev-libs/openssl:0=
	media-libs/libpng:1.2
	media-libs/jpeg:8 
"
# media-libs/jpeg:8 for the libjpeg.so.8 SONAME for ABI compat

S="${WORKDIR}"
QA_PREBUILT="opt/packettracer/*"

pkg_nofetch() {
    ewarn "To fetch sources, you need a Cisco account which is"
    ewarn "available if you're a web-learning student, instructor"
    ewarn "or you sale Cisco hardware, etc."
}

src_unpack.qt-installer() {
    # Hack for silent install Qt run installer 
    addpredict /usr/local/bin/packettracer
    addpredict /root/.config/mimeapps.list.new
    addpredict /root/.config/mimeapps.list
    addpredict /etc/profile
    
    for i in ${A}
    do
	cp -L ${DISTDIR}/"$i" ${T}/"$i"
	. ${FILESDIR}/extract-qt-installer ${T}/"$i" ${S}
    done
}


src_prepare() {
    sed -i -e "s#/opt/pt#/opt/${PN}#" bin/Cisco-PacketTracer.desktop
    sed -i -e "s#Application;Network#Network#" bin/Cisco-PacketTracer.desktop
    default_src_prepare
}

src_install_() {
    exeinto /opt/${PN}/bin
    doexe bin/linguist bin/meta bin/PacketTracer7
    rm bin/linguist bin/meta bin/PacketTracer7
    exeinto /opt/${PN}/bin/Linux
    doexe bin/Linux/*
    rm -r bin/Linux
    insinto /usr/share/mime/packages
    doins bin/Cisco-*.xml
    rm bin/Cisco-*.xml
    domenu bin/Cisco-PacketTracer.desktop
    rm bin/Cisco-PacketTracer.desktop
    insinto /opt/${PN}
    doins -r art backgrounds bin extensions help languages saves Sounds templates
    for icon in pka pkt pkz; do
	newicon -s 48x48 -c mimetypes art/${icon}.png application-x-${icon}.png
    done
    # dodoc eula${PV//./}.txt
    dobin "${FILESDIR}/${PN}"
    exeinto /opt/${PN}
    doexe "${FILESDIR}/linguist"
    insinto /etc/profile.d
    doins "${FILESDIR}/${PN}.sh"
    #find "${ED%/}/opt/${PN}/bin" -iname "*.so*" -exec patchelf --set-rpath '$ORIGIN/' {} \;
    for b in PacketTracer7 meta linguist; do
	#patchelf --set-rpath '$ORIGIN/' "${ED%/}/opt/${PN}/bin/${b}"
	pax-mark -m "${ED%/}/opt/${PN}/bin/${b}"
    done
    
    # fperms +x "${EPREFIX}/opt/${PN}/extensions/NetacadExamPlayer/NetacadExamPlayer"
    # fperms +x "${EPREFIX}/opt/${PN}/extensions/NetacadExamPlayer/QtWebEngineProcess"
    # fperms +x "${EPREFIX}"/opt/${PN}/extensions/NetacadExamPlayer/ptplayer/*.*
    # fperms +x "${EPREFIX}"/opt/${PN}/extensions/NetacadExamPlayer/ptplayer/java/bin/*
    # fperms +x "${EPREFIX}"/opt/${PN}/extensions/NetacadExamPlayer/ptplayer/java/lib/*.jar
    # fperms +x "${EPREFIX}"/opt/${PN}/extensions/NetacadExamPlayer/ptplayer/java/lib/ext/*.jar
    # fperms +x "${EPREFIX}/opt/${PN}/extensions/NetacadExamPlayer/ptplayer/java/lib/jexec"
    # fperms +x "${EPREFIX}/opt/${PN}/extensions/ptaplayer/ptaplayer-12.009.jar"
    # fperms +x "${EPREFIX}"/opt/${PN}/extensions/NetacadExamPlayer/ptplayer/java/lib/security/policy/limited/*.jar
    # fperms +x "${EPREFIX}"/opt/${PN}/extensions/NetacadExamPlayer/ptplayer/java/lib/security/policy/unlimited/*.jar
}

src_install() {
    cp -R opt usr ${D}
    mv ${D}/opt/pt ${D}/opt/${PN}

    for b in PacketTracer7 meta linguist
    do
	patchelf --set-rpath '$ORIGIN/' "${ED%/}/opt/${PN}/bin/${b}"
	pax-mark -m "${ED%/}/opt/${PN}/bin/${b}"
    done

    for b in libicudata.so.52 libicui18n.so.52 libicuuc.so.52
    do
	patchelf --set-rpath '$ORIGIN/' "${ED%/}/opt/${PN}/bin/${b}"
    done


    ## 
    dobin "${FILESDIR}/${PN}"
    exeinto /opt/${PN}
    doexe "${FILESDIR}/linguist"
    insinto /etc/profile.d
    doins "${FILESDIR}/${PN}.sh"

    sed -i -e "s:/opt/pt:/opt/${PN}:g" ${D}/opt/${PN}/${PN}
}

pkg_postinst() {
    xdg_desktop_database_update
    xdg_mimeinfo_database_update
}

pkg_postrm() {
    xdg_desktop_database_update
    xdg_mimeinfo_database_update
}

