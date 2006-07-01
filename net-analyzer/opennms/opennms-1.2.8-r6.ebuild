# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Maintainer: 
#
# This ebuild use ebuild from http://portage.boxed.no/net-analyzer/opennms/ - The site http://gentoo.zugaina.org/ only host a copy.
#
# Honorable mention to Roderick Greening for many great improvements and
# spotting numerous typoohs and whopping me to fix up my mess :)
# (In fact, most of the changes from the lst 1.2.3-ebuild to this is his work)
#
# The pkg_config bits are generously lifted from the ebuild submitted by
# jeffrey@crawford.homeunix.net at http://bugs.gentoo.org/show_bug.cgi?id=51441
#

inherit eutils

DESCRIPTION="OpenNMS is a higly robust and flexible NMS tool"
SRC_URI="mirror://sourceforge/opennms/opennms-source-${PV}-1.tar.gz"
HOMEPAGE="http://opennms.org"
LICENSE="GPL-2"
SLOT="0"

IUSE="doc"

S="${WORKDIR}/opennms-${PV}-1/source/"

RDEPEND=">=virtual/jdk-1.4.2
		 >=www-servers/tomcat-5.0.27
		 >=dev-db/postgresql-7.4
		 >=dev-java/jdbc3-postgresql-7.4
		 >=dev-java/log4j-1.2
		 >=net-analyzer/rrdtool-1.0.40
		 >=net-misc/curl-7.11
		 >=dev-perl/Getopt-Mixed-1.008
		 >=dev-java/ant-tasks-1.6.2"

#>=dev-java/sun-jdk-1.4.2.05

DEPEND="${RDEPEND}"

KEYWORDS="x86 amd64"

OPENNMS_DIR="/opt/opennms"

INST_LOGDIR="/var/log/opennms"
INST_SHAREDIR="/var/share/opennms"
INST_PIDDIR="/var/run/opennms"
INST_PIDFILE="${INST_PIDDIR}/opennms.pid"

TOMCAT_V=tomcat5

INST_PREFIX="-Dinstall.prefix=${D}"
INST_DIR="-Dinstall.dir=${OPENNMS_DIR}"
INST_LOG="-Dinstall.logs.dir=${INST_LOGDIR}"
INST_SHARE="-Dinstall.share.dir=${INST_SHAREDIR}"
INST_PID="-Dinstall.pid.file=${INST_PIDFILE}"
INST_DOC="-Dinstall.docs.dir=/usr/share/doc/${P}"
INST_ETC="-Dinstall.etc.dir=/etc/opennms"

PG_INCLUDE="-Dbuild.postgresql.include.dir=/usr/include/postgresql/server"

ANT_TARGETS="check all"

ANT_OPTS=" -v \
		  ${INST_PREFIX} \
		  ${INST_DIR} \
		  ${INST_SHARE} \
		  ${INST_LOG} \
		  ${INST_PID} \
		  ${INST_DOC} \
		  ${INST_ETC} \
		  ${PG_INCLUDE}"


# Todos:
#
# howto for port other than 8080
# parm for remote db?
# parm for remote tomcat?
# 
# turn logfiles down to INFO?
# Fix umask for log4j?
# /etc/conf.d/opennms hack
#
# FIXME: classpath in o.conf myst include opennms-lib
# FIXME: -DIPv4,etc in o.conf
# 
# Grep install-tree for things root.root
# install opennms.xml into tomat5-conf-caaline-localhost

pkg_setup() {
	if [ -f ${OPENNMS_DIR}/etc/java.conf -a -f ${INST_PIDFILE} ] &&  \
			[ "`pidof -- \`cat ${OPENNMS_DIR}/etc/java.conf\` -classpath ${OPENNMS_DIR}/etc`" != "" ]; then
		ewarn ""
		ewarn "  You cannot upgrade OpenNMS while it is running, please stop"
		ewarn "  OpenNMS before retrying the operation."
		ewarn ""
		ebeep 3
		epause 5
		die ""
	fi

	# Check if an OK version of PostgreSQL exists and is set up OK
	# Check for postgres includes, not full running postgres
	if has_version ">=dev-db/postgresql-7.4*" && [ -x /usr/bin/psql ]; then
		psql template1 postgres -c '\q' &> /dev/null
		if [ ${?} -eq 0 ]; then
			einfo ""
			einfo "* Your PostgreSQL seems to be set up and responding, good."
			einfo ""
		elif [ ! -f /var/lib/postgresql/data/PG_VERSION ]; then
			ewarn ""
			ewarn "* It seems your PostgreSQL installation is installed,"
			ewarn "  but not initialised, please consult the PostgresSQL"
			ewarn "  installation instructions. Probably fixed by running:"
			ewarn ""
			ewarn "  ebuild /var/db/pkg/`portageq best_version / \
						dev-db/postgresql`/*.ebuild config"
			ewarn ""
			ewarn "  and then starting PostgreSQL using it's init script."
			ewarn ""
			ewarn "* You can build OpenNMS without initialising the database,"
			ewarn "  but it will be easier if PostgreSQL is initialised before"
			ewarn "  retrying emerging OpenNMS."
			ewarn ""
			ewarn "* To make it all nice and easy, stop now using CTRL-C"
			ewarn "  and initialise PostgreSQL before restarting."
			ewarn ""
			ebeep 3
			epause 20
		fi
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# Mend a few broken things
	#epatch ${FILESDIR}/${PV}/config-override.patch
	epatch ${FILESDIR}/${PV}/install-pid-file.patch

	# Fixup webgui, broken with tomcat 5.x
	epatch ${FILESDIR}/${PV}/webgui.patch

	# Tomcat stuff
	source /etc/conf.d/${TOMCAT_V}

#	epatch ${FILESDIR}/${PV}/build.xml.patch
#	cp ${FILESDIR}/${PV}/mbean-descriptor.xml ${S}/etc
#	cp ${CATALINA_HOME}/server/lib/catalina.jar ${S}/lib/
}

src_compile() {
	local ANT_BUILDLOG="`mktemp /tmp/opennms-build.\`date +%F\`.XXXXXX`"

	if use doc; then
		ANT_TARGETS="${ANT_TARGETS} docs"
		DOCTEXT=" and documentation"
	fi

	einfo ""
	einfo "* Building OpenNMS${DOCTEXT}, please be patient..."
	einfo ""
	einfo "* If building with docs, this can take significant time,"
	einfo "  a P-III with 1Gb RAM uses 29 mins, my P-4 3.4GHz with"
	einfo "  2Gb RAM takes 30-40 seconds"
	einfo ""

	sh ./build.sh ${ANT_TARGETS} ${ANT_OPTS} -l ${ANT_BUILDLOG}

	if [ ${?} -ne 0 ]; then
		ewarn ""
		ewarn "The OpenNMS build failed, plase look at the log:"
		ewarn "  ${ANT_BUILDLOG}"
		ewarn ""
		ebeep 3
		epause 5
		die ""
	fi
}

src_install () {
	local ANT_INSTLOG="`mktemp /tmp/opennms-install.\`date +%F\`.XXXXXX`"

	# init.d, env.d, conf.d
	newinitd ${FILESDIR}/${PV}/opennms.init ${PN}
	#newconfd ${FILESDIR}/${PV}/opennms.conf ${PN}
	# FIXME
	newenvd ${FILESDIR}/${PV}/${PN}.env 21${PN}

	# Install OpenNMS into /opt/OpenNMS
	einfo ""
	einfo "Installing OpenNMS${DOCTEXT}, please be patient..."
	einfo ""
	keepdir ${OPENNMS_DIR}
	keepdir ${INST_LOGDIR}
	keepdir ${INST_PIDDIR}
	keepdir ${INST_SHAREDIR}

	sh ./build.sh install ${ANT_OPTS} -l ${ANT_INSTLOG}

	if [ ${?} -ne 0 ]; then
		ewarn ""
		ewarn "The OpenNMS install failed, plase look at the log:"
		ewarn "  ${ANT_INSTLOG}"
		ewarn ""
		ebeep 3
		epause 5
		die ""
	fi

	# FIXME: This needs cleaning, filter what we copy?
	if use doc; then
		mkdir -p ${D}/usr/share/doc/${P}
		cp -r ${S}/work/docs/* ${D}/usr/share/doc/${P}
		cp ${S}/README.* ${D}/usr/share/doc/${P}
		cp ${S}/CHANGELOG ${D}/usr/share/doc/${P}

		if [ ! -h ${OPENNMS_DIR}/docs ]; then
			dosym /usr/share/doc/${P} ${OPENNMS_DIR}/docs
		fi
	fi
	
	#
	dodir /etc/opennms
	mv ${D}/${OPENNMS_DIR}/etc/* ${D}/etc/opennms
	rm -r ${D}/${OPENNMS_DIR}/etc
        dosym /etc/opennms ${OPENNMS_DIR}/etc

}

pkg_preinst() {
	# Check for upgrade
	if has_version '=net-analyzer/opennms-server-1.2*'; then
		UPGRADING=1
	fi

	# Create user and group
	enewgroup opennms 357
	enewuser opennms 357 -1 /dev/null opennms

	# Should be moved into install?
	# FIXME: umask in log4j?
	einfo ""
	einfo "...and fixing some directory permissions:"

	cd ${D}/${OPENNMS_DIR}

	# Generally keep it all tight
	find . -type d -exec chgrp opennms {} \;
	find . -type d -exec chmod 750 {} \;

	# This is dodgy
	find etc lib contrib -type f -exec chgrp opennms {} \;
	find etc lib contrib -type f -exec chmod 640 {} \;

	# This is dodgy
	find bin -type f -exec chgrp opennms {} \;
	find bin -type f -exec chmod 750 {} \;

	find ${D}/${INST_SHAREDIR} -type d -exec chgrp opennms {} \;
	find ${D}/${INST_SHAREDIR} -type d -exec chmod 750 {} \;

	find ${D}/${INST_LOGDIR} -type d -exec chgrp opennms {} \;
	find ${D}/${INST_LOGDIR} -type d -exec chmod 750 {} \;

	# Perms set to tomcat can run the webapps bits.
	find ${D}/${OPENNMS_DIR}/webapps -type d -exec chown tomcat:opennms {} \;
	find ${D}/${OPENNMS_DIR}/webapps -type f -exec chmod 644 {} \;

	# Add some perms that needs to be there
	chmod 751 ${D}/${OPENNMS_DIR}
	chmod 751 ${D}/${OPENNMS_DIR}/lib
	chmod 644 ${D}/${OPENNMS_DIR}/lib/iplike.so

	# Stuff path into env-file
	# FIXME: WIll this fill multiple times?
	local CONFIG_PROTECT=${OPENNMS_DIR}/webapps/opennms/WEB-INF/web.xml
	echo "CONFIG_PROTECT=\"${CONFIG_PROTECT}\"" >> ${D}/etc/env.d/21${PN}
	
###
	chgrp -R tomcat ${D}/etc/opennms
	chmod -R g+w ${D}/etc/opennms
	chgrp -R tomcat ${D}/var/log/opennms
	chmod -R g+w ${D}/var/log/opennms
	chown -R tomcat:tomcat ${D}/var/lib/opennms
	chown -R tomcat:tomcat ${D}${OPENNMS_DIR}/webapps
}

pkg_postinst() {
	local HAS_PGSQL=0
	local HAS_TOMCAT=0

	# Fixup a few missing links
	# FIXME: relative links are prettier, also owner/group should be fixed
	if [ ! -h ${OPENNMS_DIR}/logs ]; then
		ln -s ${INST_LOGDIR} ${OPENNMS_DIR}/logs
	fi

	if [ ! -h ${OPENNMS_DIR}/share ]; then
		ln -s ${INST_SHAREDIR} ${OPENNMS_DIR}/share
	fi

	# Setup java
	einfo ""
	einfo "* Running \"${OPENNMS_DIR}/bin/runjava -s\" to locate a"
	einfo "  suitable JRE for OpenNMS (sun-java is preferred)"
	einfo ""

	# Check to see if we have an OK java environment
	# FIXME: add a plug to make sure the sun-jdk is the current profile?
	${OPENNMS_DIR}/bin/runjava -s -q

	if [ ${?} -eq 0 ]; then
		einfo "  - java found at `cat ${OPENNMS_DIR}/etc/java.conf`"
	else
		ewarn "  - no suitable JRE found, even though we depend on sun-jdk!"
	fi

	if has_version '=net-misc/dhcp-*'; then
		ewarn ""
		ewarn "* You have a DHCP server installed on this machine,"
		ewarn "  this conflicts with OpenNMS' DHCP polling service."
		ewarn "  See 'http://wiki.opennms.org/tiki-view_faq.php?faqId=4'"
		ewarn "  for more info."
	fi

	# First time installert hit this
	if [ ! -f ${OPENNMS_DIR}/etc/configured ]; then
		einfo ""
		einfo "* At this point you want to run the OpenNMS installer."
		einfo "  The installer will setup and initialise your database,"
		einfo "  create and populate tables, etc. For help:"
		einfo ""
		einfo "  - ${OPENNMS_DIR}/bin/install -h"
		einfo ""
		einfo "  For a initial install run with the options '-disU'."

		# Check if an OK version of PostgreSQL exists and is set up OK
		if has_version '>=dev-db/postgresql-7.4*' && [ -x /usr/bin/psql ]; then
			psql template1 postgres -c '\q' &> /dev/null
			if [ ${?} -eq 0 ]; then
				HAS_PGSQL=1
			elif [ ! -f /var/lib/postgresql/data/PG_VERSION ]; then
				einfo ""
				einfo "* PostgreSQL is installed but not initialised,"
				einfo "  Probably fixed by running:"
				einfo ""
				einfo "  ebuild /var/db/pkg/`portageq best_version / \
							dev-db/postgresql`/*.ebuild config"
			fi
		fi

	# Upgraders hits this
	# FIXME: Should check that we can connect to the opennms db too
	elif has_version '=net-analyzer/opennms-server-1.2*'; then
		einfo ""
		einfo "* It seems you are upgrading an existing version of"
		einfo "  OpenNMS 1.2.x, you should upgrade the database by"
		einfo "  running the installer with the arguments '-disU':"
		einfo ""
		einfo "  - ${OPENNMS_DIR}/bin/install -disU"
		einfo ""
		if [ `find ${OPENNMS_DIR} -type f -name ._cfg\* | wc -l` -gt 0 ]; then
			einfo "  Also, run etc-update before restarting OpenNMS"
			einfo "  to update the config files."
		fi
	else
		einfo ""
		einfo "* It seems you are upgrading from a unsupported version of"
		einfo "  OpenNMS. Please run etc-update and read the documentation"
		einfo "  carefully to manully perform the upgrade. You are now"
		einfo "  officially on your own. ;)"
	fi

	# Check for tomcat second test should only run if CATALINE_USER is non-root
	# FIXME: All this tomcat gumpf can be cleaner if we source tomcat conf and
	# use vars for all of it, many cases can be elimiated then
	if has_version '=www-servers/tomcat-5.0.*'; then
		einfo ""
		einfo "* The tomcat webapp part of OpenNMS is only supported on"
		einfo "  tomcat 4.1.x and cannot run on tomcat 5.x at present."

	elif has_version '=www-servers/tomcat-5.0.*'; then
		if [ -f /etc/conf.d/tomcat5 ]; then
			source /etc/conf.d/tomcat5
			if [ ${CATALINA_USER} != "root" ]; then
				einfo ""
				einfo "* Check in /etc/conf.d/tomcat5 that CATALINA_USER is set to"
				einfo "  root, as it needs to run as root to play nice with OpenNMS."
			fi
		fi

		if [ -d /opt/tomcat5/webapps -a -d /opt/tomcat5/server/lib ]; then
			HAS_TOMCAT=1
			einfo ""
			einfo "* To setup the default OpenNMS webapp, run this:"
			einfo ""
			einfo "  - ${OPENNMS_DIR}/bin/install -y -w /opt/tomcat5/webapps \\ "
			einfo "    -W /opt/tomcat5/server/lib"
		elif has_version '=www-servers/tomcat-5.0*'; then
			einfo ""
			einfo "* Your tomcat has a non-standard directory layout, please"
			einfo "  consult the tomcat configuration to find your tomcat"
			einfo "  'webapp' and 'lib' directories, and substitute in:"
			einfo ""
			einfo "  - ${OPENNMS_DIR}/bin/install -y -w \$WEBAPP_DIR \\ "
			einfo "    -W \$LIB_DIR"
		fi
	fi

	# Offer to automagically install DB and webapp
	if [ ${HAS_PGSQL} -eq 1 -a ${HAS_TOMCAT} -eq 1 ]; then
		einfo ""
		einfo "* We have found a running PostgreSQL and tomcat intalled, if you"
		einfo "  want the ebuild to automagically set up a default install then run:"
		einfo ""
		einfo "    ebuild /var/db/pkg/net-analyzer/${PF}/${PF}.ebuild config"
	fi

	# Offer to automagically install DB
	if [ ${HAS_PGSQL} -eq 1 -a ${HAS_TOMCAT} -eq 0 ]; then
		einfo ""
		einfo "* We have found a running PostgreSQL, if you want the ebuild"
		einfo "  to automagically set up a default install then run:"
		einfo ""
		einfo "    ebuild /var/db/pkg/net-analyzer/${PF}/${PF}.ebuild config"
		
	fi

	einfo ""
	einfo "* If all else fails, look in the OpenNMS installer docs."
	einfo "  (Did you build with the doc flag set? ;) )"
	einfo ""
	ewarn "* Be warned, this ebuild is still in flux, the layout can"
	ewarn "  change and it will later split into server/webapp/etc"
	einfo ""
	ebeep 1
	epause 5
}

pkg_config() {

	# Java config
	${OPENNMS_DIR}/bin/runjava -s

	# FIXME: check to see if we have an opennms db and assume upgrade only
	# Check we have a database connection and then install
	if has_version '>=dev-db/postgresql-7.4*' && [ -x /usr/bin/psql ]; then
		psql template1 postgres -c '\q' &> /dev/null
		if [ ${?} -eq 0 ]; then
			einfo ""
			einfo "* Installing the database:"
			${OPENNMS_DIR}/bin/install -disU
		fi
	fi

	source /etc/conf.d/${TOMCAT_V}
	
	# Check we ahve tomcat with a normal layout and install the webapp
	if has_version '=www-servers/tomcat-5.0*' && [ -d /etc/tomcat5/Catalina/localhost ]; then
		einfo ""
		einfo "* Installing the tomcat webapp"
		# Webapps install
		cp ${OPENNMS_DIR}/webapps/opennms.xml /etc/tomcat5/Catalina/localhost/
		${OPENNMS_DIR}/bin/install -y -w ${CATALINA_HOME}/webapps -W ${CATALINA_HOME}/server/lib
		touch /etc/opennms/configured
		einfo ""
		einfo "* Remember to restart tomcat to activate the webapp"
		einfo ""
	fi
}

pkg_prerm() {
	# FIXME: check to see if we need to remove webapp
	if [ -f ${OPENNMS_DIR}/etc/java.conf -a -f ${INST_PIDFILE} ] &&  \
			[ "`pidof -- \`cat ${OPENNMS_DIR}/etc/java.conf\` -classpath ${OPENNMS_DIR}/etc`" != "" ]; then
		eerror ""
		eerror "You are trying to uninstall OpenNMS while it is running!"
		eerror "Please stop it before trying to remove the OpenNMS server."
		eerror ""
		die "Aborting..."
		ebeep 1
		epause 5
	fi
}

pkg_postrm() {
	if [ ! -f ${OPENNMS_DIR}/lib/iplike.so ]; then
		ewarn ""
		ewarn "You are uninstalling the OpenNMS server. Make sure to manually"
		ewarn "remove any PostgreSQL database that it may leave behind, and"
		ewarn "clean out ${OPENNMS_DIR}, ${INST_PIDDIR}, ${INST_LOGDIR} and ${INST_SHAREDIR}."
		ewarn ""
		ebeep 1
		epause 5
	fi
}
