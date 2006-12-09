#!/bin/bash
#
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

TIME_ZONE="America/New_York"
LANGUAGE="English"

echo "defaults write NSGlobalDomain \"Local Time Zone\" ${TIME_ZONE}"
defaults write NSGlobalDomain "Local Time Zone" ${TIME_ZONE}
echo "defaults write NSGlobalDomain NSLanguages \"(${LANGUAGE})\""
defaults write NSGlobalDomain NSLanguages "(${LANGUAGE})"

