# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# Edits: collinl@pitt.edu
# -----------------------------------------
# TODO::
# The system does not, at present, link to the jvm6 or 5 directly if installed.  If there was a mechanism
# to specify the jvm in question that would be good.

inherit eutils java-pkg-2

DESCRIPTION="An open source, standards-compliant, J2EE-based application server implemented in 100% Pure Java."
RESTRICT="nomirror"
HOMEPAGE="http://www.jboss.org"
LICENSE="LGPL-2"
IUSE="doc srvdir java6"
SLOT="5"
KEYWORDS="~amd64 x86"
RDEPEND=""

# ---------------------------------
# Set the Version and package.
# If we are using java6 then we want the system to get the -jdk6 version.   If not then the standard GA will do.  
# This code just handles that conversion for the MY_P as needed.
MY_P="jboss-${PV}"	
MY_P="${MY_P}.GA"	
SRC_URI="!java6? ( mirror://sourceforge/jboss/${MY_P}.zip )
        java6? ( mirror://sourceforge/jboss/${MY_P}-jdk6.zip )"

#if use "java6" ; then
#   einfo "Got Java6"
#   MY_P="${MY_P}-jdk6"
#   # SRC_URI="mirror://sourceforge/jboss/${MY_P}-jdk6.zip"
#fi



# If we use the java6 then we depend upon >=virtual/jdk-1.6 else we depend upon >=virtual/jdk-1.5
# in this case the code will *not* check to see what is the set jvm.
DEPEND="${RDEPEND} 
        app-arch/unzip 
        dev-java/ant-core 
        dev-java/ant-contrib 
        !java6? ( >=virtual/jdk-1.5 ) 
        java6? ( >=virtual/jdk-1.6 )"

S=${WORKDIR}/${MY_P}
INSTALL_DIR="/opt/${PN}-${SLOT}"
DEFAULT_VHOST="localhost"
CACHE_INSTALL_DIR="/var/cache/${PN}-${SLOT}"
LOG_INSTALL_DIR="/var/log/${PN}-${SLOT}"
RUN_INSTALL_DIR="/var/run/${PN}-${SLOT}"
TMP_INSTALL_DIR="/var/tmp/${PN}-${SLOT}"
CONF_INSTALL_DIR="/etc/${PN}-${SLOT}"
FILESDIR_CONF_DIR=""

#switching configuration files directory
if use "srvdir" ; then
	SERVICES_DIR="/srv/${DEFAULT_VHOST}/${PN}-${SLOT}"
	FILESDIR_CONF_DIR="${FILESDIR}/${PV}/srvdir"
else
	SERVICES_BASE_DIR="/var/lib/${PN}-${SLOT}"
	SERVICES_DIR="${SERVICES_BASE_DIR}/${DEFAULT_VHOST}"
	FILESDIR_CONF_DIR="${FILESDIR}/${PV}/normal"
fi


# NOTE: When you are updating CONFIG_PROTECT env.d file, you can use this script on your current install
# run from /var/lib/jboss-${SLOT} to get list of files that should be config protected. We protect *.xml,
# *.properties and *.tld files.
# SLOT="4" TEST=`find /var/lib/jboss-${SLOT}/ -type f | grep -E -e "\.(xml|properties|tld)$"`; echo $TEST
# by kiorky better:
# echo "CONFIG_PROTECT=\"$(find /srv/localhost/jboss-bin-5/ -name "*xml" -or -name \
#          "*properties" -or -name "*tld" |xargs echo -n)\"">>env.d/50jboss-bin-5

# NOTE: using now GLEP20 as default

pkg_setup() {
	# create jboss user/group
	enewgroup jboss || die "Unable to create jboss group"
	enewuser jboss -1 /bin/sh ${SERVICES_DIR}  jboss \
		|| die	"Unable to create jboss user"
}


# Most of the interesting work is done here in the install script.  
# This includes tasks to get the shared files.  Thus additions of 
# new files will be handled here.
src_install() {
	# jboss core stuff
	# create the directory structure and copy the files
	diropts -m755
	dodir "${INSTALL_DIR}"        \
		  "${INSTALL_DIR}/bin"    \
	          "${INSTALL_DIR}/client" \
	          "${INSTALL_DIR}/common" \
	          "${INSTALL_DIR}/common/lib" \
		  "${INSTALL_DIR}/lib"    \
		  "${SERVICES_DIR}/${DEFAULT_VHOST}" \
		  "${CACHE_INSTALL_DIR}/${DEFAULT_VHOST}"  \
		  "${CONF_INSTALL_DIR}/${DEFAULT_VHOST}"   \
		  "${LOG_INSTALL_DIR}/${DEFAULT_VHOST}"    \
		  "${RUN_INSTALL_DIR}/${DEFAULT_VHOST}"    \
		  "${TMP_INSTALL_DIR}/${DEFAULT_VHOST}"

	# Copy all bin files
	insopts -m645
	diropts -m755
	insinto "${INSTALL_DIR}/bin"
	doins -r bin/*.conf bin/*.jar
	exeinto "${INSTALL_DIR}/bin"
	doexe bin/*.sh
	insinto "${INSTALL_DIR}"
	doins -r client lib

	# copy over the common files.
	# TODO:  Should probablyy put this in the server dir.
	# Install common features to the profiles.
	einfo "Installing common server components. "
	diropts -m775
	#dodir "${SERVICES_DIR}/common/lib"   
	#insinto "${SERVICES_DIR}/common/lib/"
	insinto "${INSTALL_DIR}/common/lib/"
	doins -r common/lib/*.jar

	
	#doins -r common/lib/*.jar

	# copy startup stuff
	doinitd  "${FILESDIR_CONF_DIR}/init.d/${PN}-${SLOT}"
	# add multi instances support (here:localhost)
	dosym "/etc/init.d/${PN}-${SLOT}" \
			"/etc/init.d/${PN}-${SLOT}.${DEFAULT_VHOST}"
	newconfd "${FILESDIR_CONF_DIR}/conf.d/${PN}-${SLOT}" \
			"${PN}-${SLOT}"
	# add multi instances support (here:localhost)
	newconfd "${FILESDIR_CONF_DIR}/conf.d/${PN}-${SLOT}" \
			"${PN}-${SLOT}.${DEFAULT_VHOST}"
	gunzip  -c "${FILESDIR_CONF_DIR}/env.d/50${PN}-${SLOT}.gz">50${PN}-${SLOT}
	doenvd  "50${PN}-${SLOT}"
	# jboss profiles creator binary
	exeinto  /usr/bin
	doexe	 "${FILESDIR_CONF_DIR}/bin/jboss-bin-5-profiles-creator.sh"
	# implement GLEP20: srvdir
	addpredict "${SERVICES_DIR}"
	# make a "gentoo" profile with "default" one as a template
	cp -rf server/default    server/gentoo
	
        # our nice little welcome app
	cp -rf "${FILESDIR}/${PV}/tomcat/webapp/gentoo" . || die "cp failed"
	cd gentoo || die "cd failed"
	#for /gentoo-doc context    
	jar cf ../gentoo.war * || die "jar failed"
	# for root context
	rm -f WEB-INF/jboss-web.xml || die "rm failed"
	jar cf ../ROOT.war * || die "jar failed"
	cd .. || die "cd failed"

	# installing the tomcat configuration and the webapp
	elog "Installing Tomcat Config."
	elog "Formerly this looked for jbossweb-tomcat55.sar"
	elog " in the 5.1.0 version of the system this appears to have "
	elog " renamed jbossweb.sar" 
	for PROFILE in all default gentoo standard web ; do
	    rm -rf "server/${PROFILE}/deploy/jbossweb.sar/ROOT.war" || die "rm failed"
	    # Gentoo.war is incompatible so it doesn't run.
            # einfo "  Copying gentoo.war to server/${PROFILE}/deploy/"
	    # cp -rf gentoo.war "server/${PROFILE}/deploy/" || die "cp failed"
	    cp -rf ROOT.war "server/${PROFILE}/deploy/jbossweb.sar/" || die "cp failed"

	    # our tomcat configuration to point to our helper
	    cp -rf "${FILESDIR}/${PV}/tomcat/server.xml" \
		"server/${PROFILE}/deploy/jbossweb.sar/server.xml"\
			|| die "cp failed"
	done
	rm -f gentoo.war ROOT.war || die "rm failed"
	
	
	# installing profiles
	einfo "Installing Profiles."
	for PROFILE in all default gentoo minimal standard web ; do
		# create directory
		diropts -m775
		dodir "${SERVICES_DIR}/${PROFILE}/conf"   \
		      "${SERVICES_DIR}/${PROFILE}/deploy" \
		      "${SERVICES_DIR}/${PROFILE}/deployers" \
		      "${SERVICES_DIR}/${PROFILE}/lib"
		# keep stuff
		keepdir     "${CACHE_INSTALL_DIR}/${DEFAULT_VHOST}/${PROFILE}" \
		    "${CONF_INSTALL_DIR}/${DEFAULT_VHOST}/${PROFILE}"  \
		    "${LOG_INSTALL_DIR}/${DEFAULT_VHOST}/${PROFILE}"	 \
		    "${TMP_INSTALL_DIR}/${DEFAULT_VHOST}/${PROFILE}"   \
		    "${RUN_INSTALL_DIR}/${DEFAULT_VHOST}/${PROFILE}"
		# Handle the insert.  Not quite sure why it plays out this 
		# Way with minimal but I am leaving as is for now.
		if [[ ${PROFILE} != "minimal" ]]; then
			insopts -m665
			diropts -m775
			insinto  "${SERVICES_DIR}/${PROFILE}/deploy"
			doins -r server/${PROFILE}/deploy/*
			insinto  "${SERVICES_DIR}/${PROFILE}/deployers"
			doins -r server/${PROFILE}/deployers/*
		else
			dodir  "${SERVICES_DIR}/${DEFAULT_VHOST}/${PROFILE}/deploy"
			# doins -r server/${PROFILE}/deploy/*
			dodir  "${SERVICES_DIR}/${DEFAULT_VHOST}/${PROFILE}/deployers"
		fi
		# singleton is just on "all" profile
		local clustering="false"
		[[ ${PROFILE} == "all" ]] && clustering="true"
		
                # copy files
		insopts -m664
		diropts -m772
		insinto  "${SERVICES_DIR}/${PROFILE}/conf"
		doins -r server/${PROFILE}/conf/*

		# For some profiles no lib files exist out of the box
		# so this code needs to consider avoiding them.
		einfo "Testing libs $(ls server/${PROFILE}/lib/*)"
		#if [[ -e server/${PROFILE}/lib/* ]]; then
		einfo "Handling Services: ${SERVICES_DIR}/${PROFILE}/lib"
		insopts -m644
		diropts -m755
		insinto  "${SERVICES_DIR}/${PROFILE}/lib"
		doins -r server/${PROFILE}/lib/*
		#fi
		# do symlink
		dosym "${CACHE_INSTALL_DIR}/${DEFAULT_VHOST}/${PROFILE}" \
				"${SERVICES_DIR}/${PROFILE}/data"
		dosym  "${LOG_INSTALL_DIR}/${DEFAULT_VHOST}/${PROFILE}"  \
				"${SERVICES_DIR}/${PROFILE}/log"
		dosym  "${TMP_INSTALL_DIR}/${DEFAULT_VHOST}/${PROFILE}"  \
				"${SERVICES_DIR}/${PROFILE}/tmp"
		dosym  "${RUN_INSTALL_DIR}/${DEFAULT_VHOST}/${PROFILE}"  \
				"${SERVICES_DIR}/${PROFILE}/work"
		# for conf file, doing the contrary is trickier
		# keeping the conf file with the whole installation but
		# putting a symlink to /etc/ for easy configuration
		dosym "${SERVICES_DIR}/${PROFILE}/conf"\
				"${CONF_INSTALL_DIR}/${DEFAULT_VHOST}/${PROFILE}/conf"
		# symlink the tomcat server.xml configuration file
		dosym "${SERVICES_DIR}/${PROFILE}/deploy/jbossweb-tomcat55.sar/server.xml" \
				"${CONF_INSTALL_DIR}/${DEFAULT_VHOST}/${PROFILE}"
	done

	
	# register runners
	einfo " Registering Runners."
      	einfo "  Regjarring: ${D}/${INSTALL_DIR}/bin/*.jar"
	einfo "   $(ls ${D}/${INSTALL_DIR}/bin/*.jar)"
	java-pkg_regjar	${D}/${INSTALL_DIR}/bin/*.jar
	elog " Done Regjarring."
	# do launch helper scripts which set the good VM to use
	einfo "  Setting jboss-start.sh"
	java-pkg_dolauncher jboss-start.sh  --java_args  '${JAVA_OPTIONS}'\
		--main org.jboss.Main      -into "${INSTALL_DIR}"
	einfo "  Setting jboss-stop.sh"
	java-pkg_dolauncher jboss-stop.sh   --java_args  '${JAVA_OPTIONS}'\
		--main org.jboss.Shutdown  -into "${INSTALL_DIR}"

	# documentation stuff
	einfo " Installing Docs."
	insopts -m645
	diropts -m755
	insinto	"/usr/share/doc/${PF}/${DOCDESTTREE}"
	doins copyright.txt
	doins -r docs/*
#	# write access is set for jboss group so user can use netbeans to start jboss
#	# fix permissions
#	local DIR="" srvdir=""
#	use srvdir 	&& srvdir="${SERVICES_DIR}" \
#				|| srvdir="${SERVICES_BASE_DIR}"
#	# NOTE: installing in "PN-SL/localhos"t , .. mean set for "PN-SL/"
#	DIR="${D}/${INSTALL_DIR} ${D}/${LOG_INSTALL_DIR} ${D}/${TMP_INSTALL_DIR}"
#	DIR="${DIR} ${D}/${CACHE_INSTALL_DIR} ${D}/${RUN_INSTALL_DIR}"
#	DIR="${DIR} ${D}/${CONF_INSTALL_DIR} ${D}/${srvdir}"
#	chmod -R 755 "/usr/share/${PN}-${SLOT}" || die chmod failed
#	chmod -R 765 ${DIR} || die "chmod  failed"
#	chown -R jboss:jboss ${DIR} || die "chown failed"
	
	einfo "Install complete."
}

pkg_postinst() {
	# write access is set for jboss group so user can use netbeans to start jboss
	# fix permissions
	local DIR="" srvdir=""
	use srvdir 	&& srvdir="${SERVICES_DIR}" \
				|| srvdir="${SERVICES_BASE_DIR}"
	# NOTE: installing in "PN-SL/localhos"t , .. mean set for "PN-SL/"
	DIR="/${INSTALL_DIR} /${LOG_INSTALL_DIR} /${TMP_INSTALL_DIR}"
	DIR="${DIR} /${CACHE_INSTALL_DIR} /${RUN_INSTALL_DIR}"
	DIR="${DIR} /${CONF_INSTALL_DIR} /${srvdir}"
	chmod -R 755 "/usr/share/${PN}-${SLOT}" || die chmod failed
	chmod -R 765 ${DIR} || die "chmod  failed"
	chown -R jboss:jboss ${DIR} || die "chown failed"


	elog
	elog "Multi Instance Usage"
	elog " If you want to run multiple instances of JBoss, you can do that this way:"
	elog " 1) Symlink init script:"
	elog "    ln -s /etc/init.d/${PN}-${SLOT} /etc/init.d/${PN}-${SLOT}.foo"
	elog " 2) Copy original config file:"
	elog "    cp /etc/conf.d/${PN}-${SLOT} /etc/conf.d/${PN}-${SLOT}.foo"
	elog " 3) Edit the new config file as it will use another JBOSS_SERVER_NAME."
	elog "		Set what do you want to run your new profile/vhost"
	elog "		You have to either:"
	elog "			Bind new JBoss instance to another IP address or change"
	elog "			Change the  used ports in tiomcat configuration so they do not be in conflict)"
	elog " 4) Run the new JBoss instance:"
	elog "		/etc/init.d/${PN}-${SLOT}.vhost start (eg vhost=localhost"
	elog "		-> ${PN}-${SLOT}.localhost"
	elog
	elog "Profile manager:"
	elog "We provide now a tool to manage your multiple JBoss profiles"
	elog "	see jboss-profiles-creator.sh --help for usage"
	elog
	elog "Jboss usage:"
	elog "We profile a jboss documentation available for all vhosts"
	elog "	you can access it with"
	elog "	/etc/init.d/${PN}-${SLOT}.localhost start"
	elog "	and now point your browser to http://YOURIP:8080/gentoo-doc"
	elog "	TIPS: "
	elog "		* If you have not redefine the root context, You can even reach it to http://YOURIP:8080/"
	elog
	elog "To redifine the root context: (the thing you reach with http://vhost/)"
	elog "	* Just deploy your one as PROFILE_PATH/deploy/ROOT.war"
	elog "	* To make a war go to the basedir of your application and do "
	elog "			jar cvf ROOT.war *"
	elog "	* Another thing: you can eITher deploy it in a ear or in a war"
}
