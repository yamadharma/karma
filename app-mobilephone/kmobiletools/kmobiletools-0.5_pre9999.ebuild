# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/kmobiletools/kmobiletools-0.5_pre20060707.ebuild,v 1.1 2006/07/08 17:24:00 flameeyes Exp $

inherit kde subversion

ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/trunk/playground/pim/kmobiletools"
ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/"

DESCRIPTION="KMobiletools is a KDE-based application that allows to control mobile phones with your PC."
HOMEPAGE="http://www.kmobiletools.org/"
LICENSE="GPL-2"

IUSE="kde p2k"
KEYWORDS="amd64 ~ppc x86"

DEPEND="kde? ( kde-base/libkcal
	kde-base/kontact )
	p2k? ( app-mobilephone/p2kmoto )"

S="${WORKDIR}/${PN}"

need-kde 3.3

src_unpack() {
	ESVN_UPDATE_CMD="svn update -N"
	ESVN_FETCH_CMD="svn checkout -N"
	ESVN_REPO_URI=`dirname ${ESVN_REPO_URI}`
	subversion_src_unpack

	S=${WORKDIR}/${PN}/admin
	ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/branches/KDE/3.5/kde-common/admin"
	subversion_src_unpack

	ESVN_UPDATE_CMD="svn up"
	ESVN_FETCH_CMD="svn checkout"
	S=${WORKDIR}/${PN}/kmobiletools
	ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/trunk/playground/pim/kmobiletools"
	subversion_src_unpack
}

src_compile() {
	myconf="${myconf} $(use_enable kde libkcal)
		$(use_enable kde kontact-plugin) --without-gammu
		$(use_enable p2k kioslaves)"

	kde_src_compile
}

