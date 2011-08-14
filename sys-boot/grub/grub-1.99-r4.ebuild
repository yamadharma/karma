# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/grub/grub-1.99_rc1.ebuild,v 1.3 2011/04/10 14:34:42 ulm Exp $

# XXX: need to implement a grub.conf migration in pkg_postinst before we ~arch

EAPI="4"

inherit mount-boot eutils flag-o-matic toolchain-funcs bzr

if [[ ${PV} == "9999" ]] ; then
	EBZR_REPO_URI="http://bzr.savannah.gnu.org/r/grub/trunk/grub/"
	inherit autotools bzr
	SRC_URI=""
else
	MY_P=${P/_/\~}
	SRC_URI="ftp://ftp.gnu.org/gnu/${PN}/${MY_P}.tar.gz
		mirror://gentoo/${MY_P}.tar.gz"
	S=${WORKDIR}/${MY_P}
fi

DESCRIPTION="GNU GRUB 2 boot loader"
HOMEPAGE="http://www.gnu.org/software/grub/"

LICENSE="GPL-3"
#use multislot && SLOT="2" || SLOT="0"
SLOT="2"
KEYWORDS="x86 amd64"
IUSE="custom-cflags debug truetype multislot static extras"

RDEPEND=">=sys-libs/ncurses-5.2-r5
	dev-libs/lzo
	truetype? ( media-libs/freetype >=media-fonts/unifont-5 )"
DEPEND="${RDEPEND}
	>=sys-devel/autogen-5.10
	>=dev-lang/python-2.5.2"
[[ ${PV} == "9999" ]] && DEPEND+=" sys-apps/help2man"

export STRIP_MASK="*/grub/*/*.mod"
QA_EXECSTACK="sbin/grub-probe sbin/grub-setup sbin/grub-mkdevicemap bin/grub-script-check bin/grub-fstest"

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		bzr_src_unpack
	else
		unpack ${A}
	fi

	# autogen.sh does more than just run autotools
	# need to eautomake due to weirdness #296013
	if [[ ${PV} == "9999" ]] ; then
		sed -i -e '/^autoreconf/s:^:e:' autogen.sh || die
		(. ./autogen.sh) || die
	fi

	if use extras
	then
		local P_REAL
		for i in 915resolution gpxe lua ntldr-img zfs
		do
			mkdir -p "${S}/grub-extras/${i}"
			cd "${S}/grub-extras/${i}"
			P_REAL=${P}
			P=${P_REAL}/grub-extras/${i}
			EBZR_PROJECT=grub-extras_${i}
			EBZR_REPO_URI="http://bzr.savannah.gnu.org/r/grub-extras/${i}"
			bzr_src_unpack
			P=${P_REAL}
		done
	fi

}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.99-chroot.patch # CHROOT_PATH
	epatch "${FILESDIR}"/${PN}-1.99-lvm_mapper-r1.patch # lvm mapper
	epatch_user

	if use extras
	then
		export GRUB_CONTRIB="grub-extras"
		./autogen.sh
	fi
}

src_compile() {
	use custom-cflags || unset CFLAGS CPPFLAGS LDFLAGS
	use static && append-ldflags -static

	econf \
		--disable-werror \
		--sbindir=/sbin \
		--bindir=/bin \
		--libdir=/$(get_libdir) \
		--disable-efiemu \
		$(use_enable truetype grub-mkfont) \
		$(use_enable debug mm-debug) \
		$(use_enable debug grub-emu) \
		$(use_enable debug grub-emu-usb) \
		$(use_enable debug grub-fstest)
	emake -j1 || die "making regular stuff"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
	cat <<-EOF >> "${D}"/lib*/grub/grub-mkconfig_lib
	GRUB_DISTRIBUTOR="Gentoo"
	EOF
	if use multislot ; then
		sed -i "s:grub-install:grub2-install:" "${D}"/sbin/grub-install || die
		mv "${D}"/sbin/grub{,2}-install || die
		mv "${D}"/sbin/grub{,2}-set-default || die
		mv "${D}"/usr/share/man/man8/grub{,2}-install.8 || die
		mv "${D}"/usr/share/info/grub{,2}.info || die
	fi
}

setup_boot_dir() {
	local boot_dir=$1
	local dir=${boot_dir}/grub

	if [[ ! -e ${dir}/grub.cfg ]] ; then
		einfo "Running: grub-mkconfig -o '${dir}/grub.cfg'"
		grub-mkconfig -o "${dir}/grub.cfg"
	fi

	#local install=grub-install
	#use multislot && install="grub2-install --grub-setup=/bin/true"
	#einfo "Running: ${install} "
	#${install}
}

pkg_postinst() {
	mount-boot_mount_boot_partition

	if use multislot ; then
		elog "You have installed grub2 with USE=multislot, so to coexist"
		elog "with grub1, the grub2 install binary is named grub2-install."
	fi
	setup_boot_dir "${ROOT}"boot

	# needs to be after we call setup_boot_dir
	mount-boot_pkg_postinst
}