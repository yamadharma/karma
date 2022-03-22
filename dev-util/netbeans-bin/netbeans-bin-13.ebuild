# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ANT_TASKS="ant-apache-bsf"

MY_PN=${PN/-bin/}

if [ ${PV} = "9999" ]; then
	EGIT_REPO_URI="https://github.com/apache/netbeans.git"
else
	KEYWORDS="amd64"
	SRC_URI="mirror://apache/netbeans/netbeans/${PV}/netbeans-${PV}-bin.zip"
	S="${WORKDIR}"/${MY_PN}
fi

inherit java-pkg-2 java-ant-2 desktop xdg $([[ ${PV} = "9999" ]] && echo git-r3)

DESCRIPTION="Apache Netbeans IDE"
HOMEPAGE="https://netbeans.apache.org/"
LICENSE="Apache-2.0"
SLOT="$(ver_cut 1-1)"
IUSE=""

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jdk-11"

JAVA_PKG_BSFIX="off"
INSTALL_DIR=/usr/share/${MY_PN}-${SLOT}

src_prepare() {
	default
}

src_compile() {
	default
}

QA_PREBUILT="
	usr/share/netbeans-standalone-11/ide/bin/nativeexecution/Linux-x86_64/process_start
	usr/share/netbeans-standalone-11/ide/bin/nativeexecution/Linux-x86_64/stat
	usr/share/netbeans-standalone-11/ide/bin/nativeexecution/Linux-x86_64/pty_open
	usr/share/netbeans-standalone-11/ide/bin/nativeexecution/Linux-x86_64/sigqueue
	usr/share/netbeans-standalone-11/ide/bin/nativeexecution/Linux-x86_64/unbuffer.so
	usr/share/netbeans-standalone-11/ide/bin/nativeexecution/Linux-x86_64/killall
	usr/share/netbeans-standalone-11/ide/bin/nativeexecution/Linux-x86_64/pty
	usr/share/netbeans-standalone-11/profiler/lib/deployed/jdk16/linux-amd64/libprofilerinterface.so
	usr/share/netbeans-standalone-11/profiler/lib/deployed/jdk15/linux-amd64/libprofilerinterface.so
	usr/share/netbeans-standalone-11/profiler/lib/deployed/cvm/linux/libprofilerinterface_g.so
	usr/share/netbeans-standalone-11/profiler/lib/deployed/cvm/linux/libprofilerinterface.so
	usr/share/netbeans-standalone-11/platform/modules/lib/amd64/linux/libjnidispatch-440.so
	usr/share/netbeans-standalone-11/profiler/lib/deployed/jdk16/linux-amd64/libprofilerinterface.so
"

src_install() {
	insinto ${INSTALL_DIR}
	doins -r .

	rm -fr "${ED}"/${INSTALL_DIR}/ide/bin/nativeexecution/{Linux-{sparc_64,x86},MacOSX-{x86_64,x86},SunOS-{sparc,sparc_64,x86,x86_64},Windows-{x86,x86_64}} || die "Failed to remove unused binaries"
	find "${ED}"/${INSTALL_DIR}/ \( -name *.exe -o -name *.cmd -o -name *.bat \) -type f -exec rm {} + || die "Failed to remove unused binaries"
	rm -fr "${ED}"/${INSTALL_DIR}/profiler/lib/deployed/jdk15/{hpux-pa_risc2.0{,w},linux,mac,solaris-{amd64,i386,sparc{,v9}},windows{,-amd64}} || die "Failed to remove unused libraries"
	rm -fr "${ED}"/${INSTALL_DIR}/profiler/lib/deployed/jdk16/{hpux-pa_risc2.0{,w},linux{,-arm,-arm-vfp-hflt},mac,solaris-{amd64,i386,sparc{,v9}},windows{,-amd64}} || die "Failed to remove unused libraries"
	rm -fr "${ED}"/${INSTALL_DIR}/profiler/lib/deployed/cvm/windows || die "Failed to remove unused libraries"
	rm -fr "${ED}"/${INSTALL_DIR}/platform/modules/lib/{i386,x86} || die "Failed to remove unused libraries"
	find "${ED}"/${INSTALL_DIR}/ -name *.dll -type f -exec rm {} + || die "Failed to remove unused libraries"

	find "${ED}/${INSTALL_DIR}" -name "*.so*" -type f -exec chmod +x {} \; || die "Change .so permission failed"
	exeinto ${INSTALL_DIR}/ide/bin/nativeexecution/Linux-x86_64/
	doexe ide/bin/nativeexecution/Linux-x86_64/{process_start,stat,pty_open,sigqueue,killall,pty}
	exeinto ${INSTALL_DIR}/java/maven/bin
	doexe java/maven/bin/mvn{,Debug,yjp}
	exeinto ${INSTALL_DIR}/extide/ant/bin
	doexe extide/ant/bin/{ant{,Run,Run.pl},complete-ant-cmd.pl,runant.{pl,py}}

	dodoc DEPENDENCIES NOTICE
	dosym ${INSTALL_DIR}/bin/netbeans /usr/bin/${MY_PN}-${SLOT}
	fperms 755 ${INSTALL_DIR}/bin/netbeans

	insinto /etc/${MY_PN}-${SLOT}
	doins etc/*
	rm -fr "${ED}"/${INSTALL_DIR}/etc
	dosym ../../../../etc/${MY_PN}-${SLOT} ${INSTALL_DIR}/etc
	sed -i -e "s/#netbeans_jdkhome.*/netbeans_jdkhome=\$\(java-config -O\)/g" "${ED}"/etc/${MY_PN}-${SLOT}/netbeans.conf || die "Failed to set set Netbeans JDK home"

	if [[ -e "${ED}"/${INSTALL_DIR}/bin/netbeans ]]; then
		sed -i -e "s:\"\$progdir\"/../etc/:/etc/${MY_PN}-${SLOT}/:" "${ED}"/${INSTALL_DIR}/bin/netbeans
		sed -i -e "s:\"\${userdir}\"/etc/:/etc/${MY_PN}-${SLOT}/:" "${ED}"/${INSTALL_DIR}/bin/netbeans
	fi

	dodir /usr/share/icons/hicolor/32x32/apps
	dosym ${INSTALL_DIR}/nb/netbeans.png /usr/share/icons/hicolor/32x32/apps/${MY_PN}-${SLOT}.png

	make_desktop_entry ${MY_PN}-${SLOT} "Netbeans ${PV}" ${MY_PN}-${SLOT} Development

	mkdir -p  "${ED}"/${INSTALL_DIR}/nb/config || die
	echo "NBGNT" > "${ED}"/${INSTALL_DIR}/nb/config/productid || die
}
