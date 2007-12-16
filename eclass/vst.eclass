# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Tom "gimpel" Kuther
# Purpose: VST support handling
#

ECLASS="vst"
INHERITED="$INHERITED $ECLASS"

DEPEND="vst? ( =media-libs/vst-sdk-2.3* )
	app-arch/zip"

# returns 0 if answer is yes, 1 otherwhise
agree_vst() {
	local ANSWER="no"
	einfo "Are you building ${P} for personal use (rather than distribution to others)?"
	einfo "Type [yes/no] - (default: no)"
	
	read ANSWER
	if [ "$ANSWER" == "y" ] || [ "$ANSWER" == "yes" ];then
		einfo "OK, VST support will be enabled"
		return 0
	else
		eerror "You cannot build ${P} with VST support for distribution to others."
		eerror "It is a violation of several different licenses"

		eerror "use: USE=-vst emerge ${PN}"
		eerror "to disable vst support"
		return 1
	fi
}
