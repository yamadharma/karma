#!/bin/bash
# vim: set et sw=4 sts=4 ts=4 ft=sh :
# $Id$

# Copyright (c) 2006-2007 Mike Kelly <pioto@gentoo.org>
#
# This file is part of the Paludis package manager. Paludis is free software;
# you can redistribute it and/or modify it under the terms of the GNU General
# Public License, version 2, as published by the Free Software Foundation.
#
# Paludis is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place, Suite 330, Boston, MA  02111-1307  USA

# FUNCTIONS #

# appends a line of the form key="value" to the given filename under
# $outputdir. For use on files like bashrc
function append_shell_var() {
    local key="${1}" value="${2}" filename="${outputdir}/${3}"

    [[ -f "${filename}" ]] || cat <<- EOF > "${filename}"
# $(basename ${filename})
# This file created by $(basename ${0})
EOF

    [[ -z "${value}" ]] \
        || echo "${key}=\"${value}\"" >> "${filename}"
}

# appends a line of the form pkgname value to the given filename under
# $outputdir. For use on files like use.conf
function append_pkg_var() {
    local pkgname="${1}" value="${2}" filename="${outputdir}/${3}"

    [[ -f "${filename}" ]] || cat <<- EOF > "${filename}"
# $(basename ${filename})
# This file created by $(basename ${0})
EOF

    [[ -z "${value}" ]] \
        || echo "${pkgname} ${value}" >> "${filename}"
}

# Given a file path, will attempt to determine a sync url for a paludis
# repository config file.
function get_sync_url() {
    local path="${1}"

    if [[ -d "${path}/.svn" ]] ; then
        url=$(env LANG=C svn info "${path}" | grep -i "^url" | cut -d" " -f2)
        case ${url} in
            http://*|https://*)
                echo "svn+${url}"
                ;;
            svn://*|svn+ssh://*)
                echo "${url}"
                ;;
            *)
                return 1
                ;;
        esac
    elif [[ -d "${path}/CVS" ]] ; then
        return 1
    elif [[ -d "${path}/.git" ]] ; then
        url=$(grep -i "^url:" "${path}/.git/remotes/origin" | cut -d" " -f2)
        case ${url} in
            http://*)
                echo "git+${url}"
                ;;
            ssh://*)
                echo "git+${url}"
                ;;
            *)
                return 1
                ;;
            esac
    elif [[ -d "${path}/_darcs" ]] ; then
        url=$( < "${path}/_darcs/prefs/defaultrepo" )
        case ${url} in
            http://?*)
                echo "darcs+${url}"
                ;;
            # some other kind of URL, not supported
            ?*://?*)
                return 1
                ;;
            # needs at least two chars before the colon, otherwise
            # Darcs thinks it's a Windowsesque filename
            ??*:*)
                echo "darcs+ssh://${url}"
                ;;
            # local file
            *)
                return 1
                ;;
        esac
    else
        return 1
    fi
}

# Given a file path, will separate comments from the rest
# and output the result on stdout
function split_comments() {
    sed 's/^\(.\+\)#\(.\+\)$/#\2\n\1/' $1
}

# needs 3 params, value to test, var to show if true, var to show if false
# basically, acts like the ? ... : ... operator in C
qmark_oper() {
    if [[ "${1}" == "y" ]] ; then
        echo "${2}"
    else
        echo "${3}"
    fi
}

canonicalise() {
	case $(uname -s) in
		FreeBSD) realpath $@ ;;
		*) readlink -f $@ ;;
	esac
}

# MAIN #

# Ask the user for an output directory.

echo "Portage2Paludis:"
echo
echo "This script will attempt to convert an existing portage configuration to"
echo "a paludis configuration. It assumes that the portage configuration can"
echo "be found via /etc/make.conf, /etc/make.profile, and /etc/portage/*"
echo
echo "WARNING: This script is still a work in progress. Do not expect it to"
echo "make completely sane decisions when migrating. Always check the produced"
echo "output yourself afterwards. Report any bugs you find to:"
echo "    Mike Kelly <pioto@gentoo.org>"

if [[ "$(id -u)" -ne 0 ]] ; then
    echo
    echo "WARNING: This script will touch some of the repositories directly."
    echo "It is highly recommended that you run it as root."
fi

echo
echo "Please enter where you would like your new paludis configuration to be"
echo "created, or press enter to use the default."
echo
read -e -p "Paludis Config Directory [/etc/paludis]: " outputdir
echo
outputdir="${outputdir:-/etc/paludis}"

if [[ -d "${outputdir}" ]] ; then
    echo "An existing paludis config was found at ${outputdir}." 1>&2
    echo "Aborting." 1>&2
    exit 1
elif [[ -e "${outputdir}" ]] ; then
    echo "A file already exists where you wanted to install your paludis" 1>&2
    echo "configuration. Please remove it and try again. Aborting." 1>&2
    exit 1
fi
mkdir -p "${outputdir}" || exit 1

echo "Starting with Paludis 0.12.0, 3 optional caches were added:"
echo
echo "  A names cache, which makes finding a category/package name faster when"
echo "  just given the package name."
echo
echo "  A provides cache, which makes searching for which packages provide"
echo "  a given virtual faster."
echo
echo "  A locally-generated metadata cache. Before, Paludis could use a"
echo "  metadata cache that already existed, but now it can also generate"
echo "  one on-the-fly, caching metadata for subsequent runs." 
echo
echo "Before enabling any of these, read: http://paludis.pioto.org/cachefiles.html"
echo

read -n1 -p "Enable names cache? [y/N] " names_cache
echo
names_cache=${names_cache:-n}

read -n1 -p "Enable provides cache? [y/N] " provides_cache
echo
provides_cache=${provides_cache:-n}

read -n1 -p "Enable local metadata cache (write_cache)? [y/N] " write_cache
echo
write_cache=${write_cache:-n}
[[ "${write_cache}" == "y" ]] && mkdir -p "/var/cache/paludis/metadata"

echo "* Configuration Files:"

echo -n "Generating use.conf (Pass 1 of 3)... "
append_pkg_var "*" "$(source /etc/make.conf ; echo ${USE})" "use.conf"
echo "done."

echo -n "Generating use.conf (Pass 2 of 3)... "
for x in $(portageq envvar USE_EXPAND) ; do
    val_x=$(source "/etc/make.conf" ; echo ${!x})
    if [[ -n "${val_x}" ]] ; then
        append_pkg_var "*" "${x}: -* ${val_x}" "use.conf"
    fi
done
echo "done."

echo -n "Generating use.conf (Pass 3 of 3)... "
[[ -f "/etc/portage/package.use" ]] \
    && split_comments "/etc/portage/package.use" >>"${outputdir}/use.conf"
echo "done."

echo -n "Generating bashrc (Pass 1 of 1)... "
cflags="$(portageq envvar CFLAGS)"
cxxflags="$(portageq envvar CXXFLAGS)"
[[ "${cxxflags}" == "${cflags}" ]] && cxxflags="\${CFLAGS}"
append_shell_var "export CHOST" "$(portageq envvar CHOST)" "bashrc"
append_shell_var "export CFLAGS" "${cflags}" "bashrc"
append_shell_var "export CXXFLAGS" "${cxxflags}" "bashrc"
append_shell_var "export LDFLAGS" "$(portageq envvar LDFLAGS)" "bashrc"
append_shell_var "export MAKEOPTS" "$(portageq envvar MAKEOPTS)" "bashrc"
append_shell_var "export KBUILD_OUTPUT" "$(portageq envvar KBUILD_OUTPUT)" "bashrc"
echo "done."

echo -n "Generating keywords.conf (Pass 1 of 2)... "
append_pkg_var "*" "$(portageq envvar ACCEPT_KEYWORDS)" "keywords.conf"
echo "done."

echo -n "Generating keywords.conf (Pass 2 of 2)... "
[[ -f "/etc/portage/package.keywords" ]] \
    && split_comments "/etc/portage/package.keywords" >>"${outputdir}/keywords.conf"
echo "done."

echo -n "Generating mirrors.conf (Pass 1 of 1)... "
mirrors=
for m in $(portageq envvar GENTOO_MIRRORS) ; do
    mirrors="${mirrors} ${m}/distfiles"
done
append_pkg_var "*" "${mirrors}" "mirrors.conf"
echo "done."

echo -n "Generating package_mask.conf (Pass 1 of 1)... "
cat << EOF >"${outputdir}/package_mask.conf"
# package_mask.conf
# This file created by $(basename ${0})
EOF
[[ -f "/etc/portage/package.mask" ]] \
    && split_comments "/etc/portage/package.mask" >>"${outputdir}/package_mask.conf"
echo "done."

echo -n "Generating package_unmask.conf (Pass 1 of 1)... "
cat << EOF >"${outputdir}/package_unmask.conf"
# package_unmask.conf
# This file created by $(basename ${0})
EOF
[[ -f "/etc/portage/package.unmask" ]] \
    && split_comments "/etc/portage/package.unmask" >>"${outputdir}/package_unmask.conf"
echo "done."

echo -n "Generating licenses.conf stub (Pass 1 of 1)... "
cat << EOF >"${outputdir}/licenses.conf"
# licenses.conf
# This is a stub, it accepts all licenses.
# This file created by $(basename ${0})
* *
EOF
echo "done."

echo
echo "* Standard Repositories:"
mkdir "${outputdir}/repositories"

portdir="$(portageq envvar PORTDIR)"
echo -n "Generating gentoo.conf (${portdir}) (Pass 1 of 1)... "
profile="$(canonicalise /etc/make.profile)"
cat << EOF >"${outputdir}/repositories/gentoo.conf"
location = \${ROOT}${portdir}
sync = $(portageq envvar SYNC)
profiles = \${ROOT}${profile}
distdir = $(portageq envvar DISTDIR)
format = ebuild
names_cache = $(qmark_oper "${names_cache}" "\${location}/.cache/names" "/var/empty")
write_cache = $(qmark_oper "${write_cache}" "/var/cache/paludis/metadata" "/var/empty")
EOF
echo "done."

echo -n "Generating installed.conf (/var/db/pkg) (Pass 1 of 1)... "
cat << EOF >"${outputdir}/repositories/installed.conf"
location = \${ROOT}/var/db/pkg/
format = vdb
names_cache = $(qmark_oper "${names_cache}" "\${location}/.cache/names" "/var/empty")
provides_cache = $(qmark_oper "${provides_cache}" "\${location}/.cache/provides" "/var/empty")
EOF
echo "done."

if [[ ! -e /var/db/pkg/world ]] ; then
    echo -n "Creating /var/db/pkg/world -> /var/lib/portage/world symlink..."
    ln -s /var/lib/portage/world /var/db/pkg/world
    echo "done."
fi

portdir_overlay="$(portageq envvar PORTDIR_OVERLAY)"

echo
echo "* Overlays:"

[[ -z "${portdir_overlay}" ]] && echo "No overlays to configure."

# Needed for repo_name matching
shopt -s extglob

for o in ${portdir_overlay}; do
    # Get our repo_name
    [[ -f "${o}/profiles/repo_name" ]] \
        && repo_name=$(< "${o}/profiles/repo_name")

    if [[ -z "${repo_name}" ]] ; then
        mkdir -p "${o}/profiles"
        echo
        echo "The repository at \"${o}\""
        echo "is not complete. It needs to have a name. (Set in the"
        echo "profiles/repo_name file). Please enter one now."
        echo
        echo "Legal characters are: The letters A-Z (upper and lower case),"
        echo "the digits 0-9, and the symbols - (\"dash\"), + (\"plus\"),"
        echo "and _ (\"underscore\")."
        echo
        read -e -p "Name for ${o}: " repo_name
        echo "${repo_name}" > "${o}/profiles/repo_name"
    fi
    while [[ "${repo_name}" != +([A-Za-z0-9+_-]) ]] ; do
        echo
        echo "Invalid name; try again."
        read -e -p "Name for ${o}: " repo_name
        echo "${repo_name}" > "${o}/profiles/repo_name"
    done

    if [[ -f "${outputdir}/repositories/${repo_name}.conf" ]] ; then
        echo "While trying to generate a config for the repo called" 1>&2
        echo "\"${repo_name}\", we found we had already generated a config" 1>&2
        echo "for a config of the same name. You will have to finish" 1>&2
        echo "configuring your overlays on your own. For more info, see:" 1>&2
        echo "http://paludis.berlios.de/ConfigurationFiles.html" 1>&2
        exit 1
    fi

    echo -n "Generating ${repo_name}.conf (${o}) (Pass 1 of 1)... "

    sync_url=$(get_sync_url "${o}")

    eclassdirs="${portdir}/eclass"
    [[ -d "${o}/eclass" ]] && eclassdirs="${eclassdirs} ${o}/eclass"

    cat << EOF >"${outputdir}/repositories/${repo_name}.conf"
location = \${ROOT}${o}
sync = ${sync_url}
profiles = \${ROOT}${profile}
eclassdirs = ${eclassdirs}
distdir = $(portageq envvar DISTDIR)
format = ebuild
names_cache = $(qmark_oper "${names_cache}" "\${location}/.cache/names" "/var/empty")
write_cache = $(qmark_oper "${write_cache}" "/var/cache/paludis/metadata" "/var/empty")
EOF
    echo "done."
done

# Not needed anymore
shopt -u extglob

if [[ -f "/etc/portage/bashrc" ]] ; then
    echo "This script did not copy your customized Portage bashrc." 1>&2
    echo "You must make any desired changes to Paludis' bashrc yourself." 1>&2
fi

echo
echo 'Complete!'
echo "You now have a new paludis config in: ${outputdir}"
echo
echo "Don't forget to double check the configuration yourself before using it."
if [[ "${names_cache}" == "y" ]] ; then
    echo
    echo "Your names caches will be created the next time you run:"
    echo
    echo "  paludis --sync"
    echo "    or"
    echo "  paludis --regenerate-installable-cache"
fi
if [[ "${provides_cache}" == "y" ]] ; then
    echo
    echo "Your provides cache will be created the next time you install"
    echo "or uninstall a package with Paludis, or the next time you run:"
    echo
    echo "  paludis --regenerate-installed-cache"
fi
