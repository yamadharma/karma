# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Author: Mario Tanev
# Original Author: Akinori Hattori
# Purpose: 
#

inherit scm libtool

ECLASS="svn"
INHERITED="$INHERITED $ECLASS"

DEPEND="$DEPEND
	>=dev-util/subversion-1.2.0"

ESVN="svn.eclass"

## ESVN_STORE_DIR: Central repository for working copies
## ${DISTDIR} is no longer used in portage; we must now use ${PORTAGE_ACTUAL_DISTDIR}
[ -z "${ESVN_STORE_DIR}" ] && ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR}/svn-src"

## ESVN_REPO_URI: Repository URL
[ -z "${ESVN_REPO_URI}" ]  && ESVN_REPO_URI=""

## ESVN_PROJECT: Project name 
#[ -z "${ESVN_PROJECT}" ] && ESVN_PROJECT="${PN/-svn}"

## -- svn_obtain_certificates() ------------------------------------------------ #

function svn_obtain_certificates() {
	debug-print-function $FUNCNAME $*

	## ${DISTDIR} is no longer used in portage; we must now use ${PORTAGE_ACTUAL_DISTDIR}
	_DISTDIR=$PORTAGE_ACTUAL_DISTDIR
	DISTDIR="$HOME/.subversion/auth/svn.ssl.server"
	for URI in $ESVN_CERTIFICATES
	do
		[ ! -f $DISTDIR/`basename $URI` ] && einfo "Obtaining SSL certificate $URI" && `eval $FETCHCOMMAND`
	done
	DISTDIR=$_DISTDIR

}

SCRIPT_DIR="$(dirname $(dirname $(dirname $FILESDIR)))/scripts"

## -- svn_deep_copy() ------------------------------------------------ #

function svn_deep_copy() {
	debug-print-function $FUNCNAME $*

	local item="$1"
	local src="$2"
	local dest="$3"

	debug-print "$FUNCNAME: Deep-copying $item from $src to $dest, omitting .svn*"

	pushd $src >/dev/null
	debug-print `find $item \( -path "*.svn*" -type d ! -name . -prune \) -o \( -exec \cp -p --parents {} $dest/ \;  \) 2>&1`
	popd >/dev/null

}

## -- svn_src_fetch() ------------------------------------------------ #

ESVN_CO_DIR="${ESVN_PROJECT}/${ESVN_REPO_URI##*/}"
function svn_src_fetch() {
	debug-print-function $FUNCNAME $*

	# Check for empty ESVN_REPO_URI
	[ -z "${ESVN_REPO_URI}" ] && die "${ESVN}: ESVN_REPO_URI is empty."

	# check for the protocol.
	case ${ESVN_REPO_URI%%:*} in
		http|https)
			if built_with_use dev-util/subversion nowebdav; then
				eerror "In order to emerge this package, you need to"
				eerror "re-emerge subversion with USE=-nowebdav"
				die "Please run 'USE=-nowebdav emerge subversion'"
			fi
			;;
		svn)	;;
		*)
			die "${ESVN}: fetch from "${ESVN_REPO_URI%:*}" is not yet implemented."
			;;
	esac
	
	if [ ! -d "${ESVN_STORE_DIR}" ]; then
		debug-print "${FUNCNAME}: initial checkout. creating subversion directory"

		addwrite /
		mkdir -p "${ESVN_STORE_DIR}"      || die "${ESVN}: can't mkdir ${ESVN_STORE_DIR}."
		chmod -f o+rw "${ESVN_STORE_DIR}" || die "${ESVN}: can't chmod ${ESVN_STORE_DIR}."
		export SANDBOX_WRITE="${SANDBOX_WRITE%%:/}"
	fi


	# every time
	addwrite "/etc/subversion"
	addwrite "${ESVN_STORE_DIR}"

	if ! has userpriv ${FEATURES}; then
		# -userpriv
		addwrite "/root/.subversion"
	else
		# +userpriv
		ESVN_OPTIONS="${ESVN_OPTIONS} --config-dir ${ESVN_STORE_DIR}/.subversion"
	fi
	
	ARGUMENTS="$ARGUMENTS $ESVN_RUN_ARGS"
	ARGUMENTS="$ARGUMENTS --repository=${ESVN_REPO_URI}"
	ARGUMENTS="$ARGUMENTS --work-base=${ESVN_STORE_DIR}/${ESVN_PROJECT}"
	ARGUMENTS="$ARGUMENTS --revdb-out=${T}/SVNREVS"
	if [ "$ESVN_OFFLINE" ]
	then
		ARGUMENTS="$ARGUMENTS --offline"
	fi
	REVDB_IN="${ROOT}/var/db/pkg/${CATEGORY}/${PF}/SVNREVS"
	if [ -f $REVDB_IN ]; then
		ARGUMENTS="$ARGUMENTS --revdb-in=$REVDB_IN"
		if ( hasq autoskipcvs ${FEATURES} ) || ( hasq logonly ${FEATURES} ); then
			if ( hasq autoskipcvs ${FEATURES} ); then
				ewarn "WARNING: Previous merge of ${CATEGORY}/${PF} exists and autoskipcvs has been set."
				ewarn "WARNING: Emerge will be aborted if there have been no relevant changes since last merge."
				ewarn "WARNING: Note, that this is not, and should not be the default behavior."
				ewarn "WARNING: Items to be inspected are $ESCM_CHECKITEMS"
				ARGUMENTS="$ARGUMENTS --checkrevs"
			else
				ewarn "Log check started for ${CATEGORY}/${PF}"
				ARGUMENTS="$ARGUMENTS --logonly"
			fi
		fi
	elif ( hasq logonly $FEATURES ); then
		ewarn "No previous revision recorded for ${CATEGORY}/${PF}"
		exit 1
	fi
	
	for item in $ESCM_CHECKITEMS; do ARGUMENTS="$ARGUMENTS --check=$item"; done
	for item in $ESCM_DEEPITEMS;	do ARGUMENTS="$ARGUMENTS --deep=$item";		done
	for item in $ESCM_SHALLOWITEMS;	do ARGUMENTS="$ARGUMENTS --shallow=$item";	done

	HELPER="env LANGUAGE=en_US $SCRIPT_DIR/eclass-helper-svn.py"
	${HELPER} ${ARGUMENTS}
	err=$?
	if [ $err -ne 0 ]
	then
		if [ $err -eq 16 ]
		then
			if ( hasq autoskipcvs ${FEATURES} ); then
				ewarn "WARNING: Revisions for ${CATEGORY}/${PF} have not changed since last merge."
				ewarn "WARNING: This merge will be aborted immediately."
				ewarn "WARNING: To avoid this in the FUTURE, unset autoskipcvs from your FEATURES"
			fi
			touch "/tmp/.svn.uptodate.${CATEGORY}.${PF}"
			exit 1
		elif [ $err -eq 17 ]
		then
			ewarn "Log check complete for ${CATEGORY}/${PF}"
			exit 1
		else
			die "${HELPER} ${ARGUMENTS} has failed with exit code $err"
		fi
	fi
}

## -- svn_src_extract() ------------------------------------------------ #

function svn_src_extract() {
	debug-print-function $FUNCNAME $*
	src_to_workdir "$ESVN_STORE_DIR/$ESVN_CO_DIR" svn_deep_copy
}

## -- svn_src_bootstrap() ------------------------------------------------ #

function svn_src_bootstrap() {
	debug-print-function $FUNCNAME $*

	local patch lpatch

	cd $S

	if [ "${ESVN_PATCHES}" ]; then
		for patch in ${ESVN_PATCHES}; do
			if [ -f "${patch}" ]; then
				epatch ${patch}

			else
				for lpatch in ${FILESDIR}/${patch}; do
					if [ -f "${lpatch}" ]; then
						epatch ${lpatch}

					else
						die "${ESVN}; ${patch} is not found"

					fi
				done
			fi
		done
		echo
	fi
	
	if [ "${ESVN_BOOTSTRAP}" ]
	then
		einfo "Bootstrapping with ${ESVN_BOOTSTRAP}"

		if [ -f "${ESVN_BOOTSTRAP}" -a -x "${ESVN_BOOTSTRAP}" ]; then
			einfo "   bootstrap with a file: ${ESVN_BOOTSTRAP}"
			eval "./${ESVN_BOOTSTRAP}" || die "${ESVN}: can't execute ESVN_BOOTSTRAP."
		else
			einfo "   bootstrap with commands: ${ESVN_BOOTSTRAP}"
			eval "${ESVN_BOOTSTRAP}" || die "${ESVN}: can't eval ESVN_BOOTSTRAP."
		fi
	fi
}

## -- svn_src_unpack() ------------------------------------------------ #

function svn_src_unpack() {
	debug-print-function $FUNCNAME $*
	svn_src_fetch || die "${ESVN}: unknown problem in svn_src_fetch()."
	svn_src_extract || die "${ESVN}: unknown problem in svn_src_extract()."
	svn_src_bootstrap || die "${ESVN}: unknown problem in svn_src_bootstrap()."
}

## -- svn_pkg_postinst() ------------------------------------------------ #

function svn_pkg_postinst() {
	debug-print-function $FUNCNAME $*
	cp $T/SVNREVS "${ROOT}/var/db/pkg/${CATEGORY}/${PF}/"
}

# Export unpack
EXPORT_FUNCTIONS src_unpack pkg_postinst
