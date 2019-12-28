# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/elisp-common.eclass,v 1.51 2008/10/27 21:34:34 ulm Exp $
#
# Copyright 2002-2004 Matthew Kennedy <mkennedy@gentoo.org>
# Copyright 2003      Jeremy Maitin-Shepard <jbms@attbi.com>
# Copyright 2004-2005 Mamoru Komachi <usata@gentoo.org>
# Copyright 2007-2008 Christian Faulhammer <opfer@gentoo.org>
# Copyright 2007-2008 Ulrich Müller <ulm@gentoo.org>
#
# @ECLASS: elisp-common.eclass
# @MAINTAINER:
# Feel free to contact the Emacs team through <emacs@gentoo.org> if you have
# problems, suggestions or questions.
# @BLURB: Emacs-related installation utilities
# @DESCRIPTION:
#
# Usually you want to use this eclass for (optional) GNU Emacs support of
# your package.  This is NOT for XEmacs!
#
# Many of the steps here are sometimes done by the build system of your
# package (especially compilation), so this is mainly for standalone elisp
# files you gathered from somewhere else.
#
# When relying on the emacs USE flag, you need to add
#
#   	emacs? ( virtual/emacs )
#
# to your DEPEND/RDEPEND line and use the functions provided here to bring
# the files to the correct locations.
#
# .SS
# src_compile() usage:
#
# An elisp file is compiled by the elisp-compile() function defined here and
# simply takes the source files as arguments.  The case of interdependent
# elisp files is also supported, since the current directory is added to the
# load-path which makes sure that all files are loadable.
#
#   	elisp-compile *.el || die
#
# Formerly, function elisp-comp() was used for compilation of interdependent
# elisp files.  This usage is considered as obsolete.
#
# Function elisp-make-autoload-file() can be used to generate a file with
# autoload definitions for the lisp functions.  It takes the output file name
# (default: "${PN}-autoloads.el") and a list of directories (default: working
# directory) as its arguments.  Use of this function requires that the elisp
# source files contain magic ";;;###autoload" comments.  See the Emacs Lisp
# Reference Manual (node "Autoload") for a detailed explanation.
#
# .SS
# src_install() usage:
#
# The resulting compiled files (.elc) should be put in a subdirectory of
# /usr/share/emacs/site-lisp/ which is named after the first argument
# of elisp-install().  The following parameters are the files to be put in
# that directory.  Usually the subdirectory should be ${PN}, you can choose
# something else, but remember to tell elisp-site-file-install() (see below)
# the change, as it defaults to ${PN}.
#
#   	elisp-install ${PN} *.el *.elc || die
#
# To let the Emacs support be activated by Emacs on startup, you need
# to provide a site file (shipped in ${FILESDIR}) which contains the startup
# code (have a look in the documentation of your software).  Normally this
# would look like this:
#
#   	;;; csv-mode site-lisp configuration
#
#   	(add-to-list 'load-path "@SITELISP@")
#   	(add-to-list 'auto-mode-alist '("\\.csv\\'" . csv-mode))
#   	(autoload 'csv-mode "csv-mode" "Major mode for csv files." t)
#
# If your Emacs support files are installed in a subdirectory of
# /usr/share/emacs/site-lisp/ (which is recommended), you need to extend
# Emacs' load-path as shown in the first non-comment.
# The elisp-site-file-install() function of this eclass will replace
# "@SITELISP@" by the actual path.
#
# The next line tells Emacs to load the mode opening a file ending with
# ".csv" and load functions depending on the context and needed features.
# Be careful though.  Commands as "load-library" or "require" bloat the
# editor as they are loaded on every startup.  When having a lot of Emacs
# support files, users may be annoyed by the start-up time.  Also avoid
# keybindings as they might interfere with the user's settings.  Give a hint
# in pkg_postinst(), which should be enough.
#
# The naming scheme for this site-init file matches the shell pattern
# "[1-8][0-9]*-gentoo.el", where the two digits at the beginning define the
# loading order (numbers below 10 or above 89 are reserved for internal use).
# So if you depend on another Emacs package, your site file's number must be
# higher!
#
# Best practice is to define a SITEFILE variable in the global scope of your
# ebuild (e.g., right after DEPEND):
#
#   	SITEFILE=50${PN}-gentoo.el
#
# Which is then installed by
#
#   	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
#
# in src_install().  If your subdirectory is not named ${PN}, give the
# differing name as second argument.
#
# .SS
# pkg_postinst() / pkg_postrm() usage:
#
# After that you need to recreate the start-up file of Emacs after emerging
# and unmerging by using
#
#   	pkg_postinst() {
#   		elisp-site-regen
#   	}
#
#   	pkg_postrm() {
#   		elisp-site-regen
#   	}
#
# When having optional Emacs support, you should prepend "use emacs &&" to
# above calls of elisp-site-regen().  Don't use "has_version virtual/emacs"!
# When unmerging the state of the emacs USE flag is taken from the package
# database and not from the environment, so it is no problem when you unset
# USE=emacs between merge and unmerge of a package.
#
# .SS
# Miscellaneous functions:
#
# elisp-emacs-version() outputs the version of the currently active Emacs.

# ELISP_DISABLE_ELC 
# if not empty, `*.elc' files removed
# for multi-instansed emacs installation

# @ECLASS-VARIABLE: SITELISP
# @DESCRIPTION:
# Directory where packages install Emacs Lisp files.
SITELISP=/usr/share/site-lisp/common/packages

# @ECLASS-VARIABLE: SITEETC
# @DESCRIPTION:
# Directory where packages install miscellaneous (not Lisp) files.
SITEETC=/usr/share/site-lisp/common/etc

# @ECLASS-VARIABLE: EMACS
# @DESCRIPTION:
# Path of Emacs executable.
EMACS=/usr/bin/emacs

# @ECLASS-VARIABLE: EMACSFLAGS
# @DESCRIPTION:
# Flags for executing Emacs in batch mode.
# These work for Emacs versions 18-23, so don't change them.
EMACSFLAGS="-batch -q --no-site-file"

# @ECLASS-VARIABLE: BYTECOMPFLAGS
# @DESCRIPTION:
# Emacs flags used for byte-compilation in elisp-compile().
BYTECOMPFLAGS="-L ."

# @FUNCTION: elisp-emacs-version
# @DESCRIPTION:
# Output version of currently active Emacs.

elisp-emacs-version() {
	local ret
	# The following will work for at least versions 18-23.
	echo "(princ emacs-version)" >"${T}"/emacs-version.el
	${EMACS} ${EMACSFLAGS} -l "${T}"/emacs-version.el
	ret=$?
	rm -f "${T}"/emacs-version.el
	if [[ ${ret} -ne 0 ]]; then
		eerror "elisp-emacs-version: Failed to run ${EMACS}"
	fi
	return ${ret}
}

# @FUNCTION: elisp-need-emacs
# @USAGE: <version>
# @RETURN: 0 if true, 1 otherwise
# @DESCRIPTION:
# Test if the eselected Emacs version is at least the major version
# specified as argument.

elisp-need-emacs() {
	local need_emacs=$1
	local have_emacs=$(elisp-emacs-version)
	einfo "Emacs version: ${have_emacs}"
	if ! [[ ${have_emacs%%.*} -ge ${need_emacs%%.*} ]]; then
		eerror "This package needs at least Emacs ${need_emacs%%.*}."
		eerror "Use \"eselect emacs\" to select the active version."
		return 1
	fi
	return 0
}

#
EXPORT_FUNCTIONS pkg_setup

SITELISP=/usr/share/site-lisp/common/packages
SITELISPROOT=/usr/share/site-lisp
SITELISPDOC=/usr/share/site-lisp/doc
SITELISPEMACS=/usr/share/emacs/site-lisp

HAS_ECF=1

# Sandbox issues
for i in /usr/info ${INFOPATH}
do
    addpredict ${i}
done

elisp-common_pkg_setup () {
	if ( has_version 'app-emacs/ecf' )
	    then
            export SITELISP=/usr/share/site-lisp/common/packages
    	    export SITELISPROOT=/usr/share/site-lisp
    	    export SITELISPDOC=/usr/share/site-lisp/doc
    	    export SITELISPEMACS=/usr/share/emacs/site-lisp
            export SITEETC=/usr/share/site-lisp/common/etc

	    export HAS_ECF=1

	    # Sandbox issues
	    for i in ${INFOPATH}
	    do
		addpredict ${i}
	    done
	else
            export SITELISP=/usr/share/emacs/site-lisp
            export SITELISPEMACS=/usr/share/emacs/site-lisp
            export SITEETC=/usr/share/emacs/etc

	    export HAS_ECF=
	fi
}

elisp-disable-elc() {
	elisp-common_pkg_setup
	if [ -n "$ELISP_DISABLE_ELC" ]
	    then
	    cd ${D}
	    for i in `find . -name '*.elc' -print`
	    do
		rm -f $i
	    done
	fi
}

# @FUNCTION: elisp-compile
# @USAGE: <list of elisp files>
# @DESCRIPTION:
# Byte-compile Emacs Lisp files.
#
# This function uses GNU Emacs to byte-compile all ".el" specified by its
# arguments.  The resulting byte-code (".elc") files are placed in the same
# directory as their corresponding source file.
#
# The current directory is added to the load-path.  This will ensure that
# interdependent Emacs Lisp files are visible between themselves, in case
# they require or load one another.

elisp-compile() {
	ebegin "Compiling GNU Emacs Elisp files"
	${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS} -f batch-byte-compile "$@"
	eend $? "elisp-compile: batch-byte-compile failed"
}

# #FUNCTION: elisp-comp
# #USAGE: <list of elisp files>
# #DESCRIPTION:
# Byte-compile interdependent Emacs Lisp files.
# THIS FUNCTION IS DEPRECATED.
#
# This function byte-compiles all ".el" files which are part of its
# arguments, using GNU Emacs, and puts the resulting ".elc" files into the
# current directory, so disregarding the original directories used in ".el"
# arguments.
#
# This function manages in such a way that all Emacs Lisp files to be
# compiled are made visible between themselves, in the event they require or
# load one another.

elisp-comp() {
	# Copyright 1995 Free Software Foundation, Inc.
	# François Pinard <pinard@iro.umontreal.ca>, 1995.
	# Originally taken from GNU autotools.

	ewarn "Function elisp-comp is deprecated and may be removed in future."
	ewarn "Please use function elisp-compile instead, or report a bug about"
	ewarn "${CATEGORY}/${PF} at <http://bugs.gentoo.org/>."
	echo

	[ $# -gt 0 ] || return 1

	ebegin "Compiling GNU Emacs Elisp files"

	local tempdir=elc.$$
	mkdir ${tempdir}
	cp "$@" ${tempdir}
	pushd ${tempdir}

	echo "(add-to-list 'load-path \"../\")" > script
	${EMACS} ${EMACSFLAGS} -l script -f batch-byte-compile *.el
	local ret=$?
	mv *.elc ..

	popd
	rm -fr ${tempdir}

	eend ${ret} "elisp-comp: batch-byte-compile failed"
}

# @FUNCTION: elisp-make-autoload-file
# @USAGE: [output file] [list of directories]
# @DESCRIPTION:
# Generate a file with autoload definitions for the lisp functions.

elisp-make-autoload-file() {
	local f="${1:-${PN}-autoloads.el}"
	shift
	ebegin "Generating autoload file for GNU Emacs"

	sed 's/^FF/\f/' >"${f}" <<-EOF
	;;; ${f##*/} --- autoloads for ${P}

	;;; Commentary:
	;; Automatically generated by elisp-common.eclass
	;; DO NOT EDIT THIS FILE

	;;; Code:
	FF
	;; Local Variables:
	;; version-control: never
	;; no-byte-compile: t
	;; no-update-autoloads: t
	;; End:
	;;; ${f##*/} ends here
	EOF

	${EMACS} ${EMACSFLAGS} \
		--eval "(setq make-backup-files nil)" \
		--eval "(setq generated-autoload-file (expand-file-name \"${f}\"))" \
		-f batch-update-autoloads "${@-.}"

	eend $? "elisp-make-autoload-file: batch-update-autoloads failed"
}

# @FUNCTION: elisp-install
# @USAGE: <subdirectory> <list of files>
# @DESCRIPTION:
# Install files in SITELISP directory.

elisp-install() {
	local subdir="$1"
	shift
	ebegin "Installing Elisp files for GNU Emacs support"
	( # subshell to avoid pollution of calling environment
		insinto "${SITELISP}/${subdir}"
		doins "$@"
	)
	eend $? "elisp-install: doins failed"
}

# @FUNCTION: elisp-site-file-install
# @USAGE: <site-init file> [subdirectory]
# @DESCRIPTION:
# Install Emacs site-init file in SITELISP directory.

elisp-site-file-install() {
	local sf="${T}/${1##*/}" my_pn="${2:-${PN}}" ret
	ebegin "Installing site initialisation file for GNU Emacs"
	cp "$1" "${sf}"
	sed -i -e "s:@SITELISP@:${SITELISP}/${my_pn}:g" \
		-e "s:@SITEETC@:${SITEETC}/${my_pn}:g" "${sf}"
	( # subshell to avoid pollution of calling environment
		insinto "${SITELISP}/site-gentoo.d"
		doins "${sf}"
	)
	ret=$?
	rm -f "${sf}"
	eend ${ret} "elisp-site-file-install: doins failed"
}

# @FUNCTION: elisp-site-regen
# @DESCRIPTION:
# Regenerate the site-gentoo.el file, based on packages' site
# initialisation files in the /usr/share/emacs/site-lisp/site-gentoo.d/
# directory.
#
# Note: Before December 2007, site initialisation files were installed
# in /usr/share/emacs/site-lisp/.  For backwards compatibility, this
# location is still supported when generating site-gentoo.el.

elisp-site-regen() {
	local sitelisp=${ROOT}${EPREFIX}${SITELISP}
	local sf i line null="" page=$'\f'
	local -a sflist

	if [[ ! -d ${sitelisp} ]]; then
		eerror "elisp-site-regen: Directory ${sitelisp} does not exist"
		return 1
	fi

	if [[ ! -d ${T} ]]; then
		eerror "elisp-site-regen: Temporary directory ${T} does not exist"
		return 1
	fi

	ebegin "Regenerating site-gentoo.el for GNU Emacs (${EBUILD_PHASE})"

	# Until January 2009, elisp-common.eclass sometimes created an
	# auxiliary file for backwards compatibility. Remove any such file.
	rm -f "${sitelisp}"/00site-gentoo.el

	for sf in "${sitelisp}"/[0-9][0-9]*-gentoo.el \
		"${sitelisp}"/site-gentoo.d/[0-9][0-9]*.el
	do
		[[ -r ${sf} ]] || continue
		# sort files by their basename. straight insertion sort.
		for ((i=${#sflist[@]}; i>0; i--)); do
			[[ ${sf##*/} < ${sflist[i-1]##*/} ]] || break
			sflist[i]=${sflist[i-1]}
		done
		sflist[i]=${sf}
	done

	cat <<-EOF >"${T}"/site-gentoo.el
	;;; site-gentoo.el --- site initialisation for Gentoo-installed packages

	;;; Commentary:
	;; Automatically generated by elisp-common.eclass
	;; DO NOT EDIT THIS FILE

	;;; Code:
	EOF
	# Use sed instead of cat here, since files may miss a trailing newline.
	sed '$q' "${sflist[@]}" </dev/null >>"${T}"/site-gentoo.el
	cat <<-EOF >>"${T}"/site-gentoo.el

	${page}
	(provide 'site-gentoo)

	;; Local ${null}Variables:
	;; no-byte-compile: t
	;; buffer-read-only: t
	;; End:

	;;; site-gentoo.el ends here
	EOF

	if cmp -s "${sitelisp}"/site-gentoo.el "${T}"/site-gentoo.el; then
		# This prevents outputting unnecessary text when there
		# was actually no change.
		# A case is a remerge where we have doubled output.
		rm -f "${T}"/site-gentoo.el
		eend
		einfo "... no changes."
	else
		mv "${T}"/site-gentoo.el "${sitelisp}"/site-gentoo.el
		eend
		case ${#sflist[@]} in
			0) ewarn "... Huh? No site initialisation files found." ;;
			1) einfo "... ${#sflist[@]} site initialisation file included." ;;
			*) einfo "... ${#sflist[@]} site initialisation files included." ;;
		esac
	fi

	return 0
}
