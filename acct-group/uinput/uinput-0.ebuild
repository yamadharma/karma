# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-group udev

ACCT_GROUP_ID=98

src_install() {
	acct-group_src_install

	local udevrules="${T}/60-uinput.rules"
	cat > "${udevrules}" <<-EOF
		KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
	EOF
	udev_dorules "${udevrules}"

	dodir /etc/modules-load.d
	echo "uinput" > ${D}/etc/modules-load.d/uinput.conf
}
