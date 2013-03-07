# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 perl-module distutils ruby

MY_PV=${PV//./_}
S=${WORKDIR}/smc
STAGING=${WORKDIR}/staging

DESCRIPTION="The State Machine Compiler"
HOMEPAGE="http://smc.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/smc/SmcSrc_${MY_PV}.tgz
	doc? ( http://downloads.sourceforge.net/smc/SmcMan_${MY_PV}.tgz ) "

SLOT="0"
LICENSE="MPL-1.1"
IUSE="doc examples test c cxx java perl python ruby tcl"
KEYWORDS="x86 amd64"
RESTRICT=mirror

RDEPEND=">=virtual/jre-1.5
	java? ( >=virtual/jdk-1.5 )
	perl? (
		dev-lang/perl
		examples? ( dev-perl/perl-tk )
	)
	python? ( dev-lang/python )
	ruby? ( dev-lang/ruby )
	tcl? (
		dev-lang/tcl
		dev-tcltk/itcl
		examples? ( dev-lang/tk )
	)"

DEPEND="${RDEPEND}
	>=virtual/jdk-1.5"

pkg_setup() {
	if use python && use examples; then
		if ! built_with_use dev-lang/python tk; then
			eerror "You need to build python with USE=tk."
			die "python examples need tk bindings"
		fi
	fi
	if use ruby && use examples; then
		if ! built_with_use dev-lang/ruby tk; then
			eerror "You need to build ruby with USE=tk."
			die "ruby examples need tk bindings"
		fi
	fi
}

src_unpack() {
	unpack ${A}

	# Bugfixes

	if use cxx; then
		# bug http://sourceforge.net/tracker/index.php?func=detail&aid=1934474&group_id=8964&atid=108964
		einfo "Patching: Fix wrong include path in C++ examples"
		for NUM in 1 2 3 4 5 6; do
			cd ${S}/examples/C++/EX${NUM}
			sed -i 's:-I../../../lib:-I../../../lib/C++:' Makefile || \
				die "sed EX${NUM} Makefile failed"
		done
		# bug http://sourceforge.net/tracker/index.php?func=detail&aid=1934479&group_id=8964&atid=108964
		einfo "Patching: Fix __GCC__ conditional in C++ example 4"
		cd ${S}/examples/C++/EX4
		sed -i 's:__GNUC__ >= 3: __GNUC__ < 4 \&\& __GNUC__ >= 3:' stoplight.cpp || \
			die "sed stoplight.cpp failed"
		# bug http://sourceforge.net/tracker/index.php?func=detail&aid=1934488&group_id=8964&atid=108964
		einfo "Patching: Fix #include <strings.h> in C++ example 6"
		cd ${S}/examples/C++/EX6
		sed -i 's:^#include <strings.h>:#include <string.h>:' Eventloop.cpp || \
			die "sed Eventloop.cpp failed"
	fi

	if use java; then
		# bug http://sourceforge.net/tracker/index.php?func=detail&aid=1934483&group_id=8964&atid=108964
		einfo "Patching: Fix wrong classpath in Java examples"
		for NUM in 1 2 3 4 5 6 7; do
			cd ${S}/examples/Java/EX${NUM}
			sed -i 's:../../../lib:../../../lib/Java:' Makefile || \
				die "sed EX${NUM} Makefile failed"
		done
	fi

	if use tcl; then
		# bug http://sourceforge.net/tracker/index.php?func=detail&aid=1934484&group_id=8964&atid=108964
		# oh holy windoze case insensitivity...
		einfo "Patching: Fix file letter case in Tcl examples"
		cd ${S}/examples/Tcl/EX4
		sed -i 's:VEHICLE.SM:Vehicle.sm:' Makefile || \
			die "sed Makefile failed"
		sed -i 's:TRAFFIC.TCL:Traffic.tcl:' Makefile || \
			die "sed Makefile failed"
		sed -i 's:Stoplight.tcl:stoplight.tcl:' Traffic.tcl || \
			die "sed Traffic.tcl failed"
		sed -i 's:Stoplight_sm.tcl:stoplight_sm.tcl:' stoplight.tcl || \
			die "sed stoplight.tcl failed"
		cd ${S}/examples/Tcl/EX5
		sed -i 's:TASK.SM:Task.sm:' Makefile || \
			die "sed Makefile failed"
		sed -i 's:TASKMAN.TCL:Taskman.tcl:' Makefile || \
			die "sed Makefile failed"
		sed -i 's:task.tcl:Task.tcl:' Taskman.tcl || \
			die "sed Taskman.tcl failed"
		sed -i 's:task_sm.tcl:Task_sm.tcl:' Task.tcl || \
			die "sed Task.tcl failed"
	fi

	# Separate tests from compiling the state machine
	# bug http://sourceforge.net/tracker/index.php?func=detail&aid=1934494&group_id=8964&atid=108964
	if use c; then
		einfo "Patching: Remove test in main target in C"
		for NUM in 1 2 3 4; do
			cd ${S}/examples/C/EX${NUM}
			sed -i 's/^all[[:blank:]]*:[[:blank:]]*$(TARGET) test/all :		$(TARGET)/' Makefile || \
				die "sed EX${NUM} Makefile failed"
		done
	fi

	if use cxx; then
		einfo "Patching: Remove test in main target in C++"
		for NUM in 1 2 3 4 5 6 ; do
			cd ${S}/examples/C++/EX${NUM}
			sed -i 's/^all[[:blank:]]*:[[:blank:]]*$(TARGET) test/all :		$(TARGET)/' Makefile || \
				die "sed EX${NUM} Makefile failed"
		done
	fi

	if use java; then
		einfo "Patching: Remove test in main target in Java"
		for NUM in 1 2 3; do
			cd ${S}/examples/Java/EX${NUM}
			sed -i 's/^all[[:blank:]]*:[[:blank:]]*checkstring test/all :           checkstring/' Makefile || \
				die "sed EX${NUM} Makefile failed"
		done
		for NUM in 4 5 6 7; do
			cd ${S}/examples/Java/EX${NUM}
			sed -i 's/^all[[:blank:]]*:[[:blank:]]*$(TARGET) test/all :		$(TARGET)/' Makefile || \
				die "sed EX${NUM} Makefile failed"
		done
	fi

	if use ruby; then
		einfo "Patching: Remove test in main target in Ruby"
		for NUM in 1 2 3; do
			cd ${S}/examples/Ruby/EX${NUM}
			sed -i 's/^all[[:blank:]]*:[[:blank:]]*checkstring test/all :           checkstring/' Makefile || \
				die "sed EX${NUM} Makefile failed"
		done
		for NUM in 1 ; do
			cd ${S}/examples/Ruby/EX${NUM}
			sed -i 's/^checkstring :[[:blank:]]*$(SOURCES) test/checkstring :   $(SOURCES)/' Makefile || \
				die "sed EX${NUM} Makefile failed"
		done
	fi

	if use tcl; then
		einfo "Patching: Remove test in main target in Tcl"
		for NUM in 1 2 3 ; do
			cd ${S}/examples/Tcl/EX${NUM}
			sed -i 's/^all[[:blank:]]*:[[:blank:]]*checkstring test/all :           checkstring/' Makefile || \
				die "sed EX${NUM} Makefile failed"
		done
		for NUM in 4 5; do
			cd ${S}/examples/Tcl/EX${NUM}
			sed -i 's/^all[[:blank:]]*:[[:blank:]]*$(TARGET) test/all :		$(TARGET)/' Makefile || \
				die "sed EX${NUM} Makefile failed"
		done
	fi

	# Fix #!/usr/bin/env [binary] calls (they don't seem to accept -w arguments)
	# bug http://sourceforge.net/tracker/index.php?func=detail&aid=1934497&group_id=8964&atid=108964
	if use perl; then
		einfo "Patching: #!/usr/bin/env perl not working with -w argument"
		for NUM in 1 2 3 4 7 ; do
			cd ${S}/examples/Perl/EX${NUM}
			sed -i 's:#!/usr/bin/env perl:#!/usr/bin/perl:' * || \
				die "sed EX${NUM} failed"
		done
	fi

	if use python; then
		einfo "Patching: on Python, -w is -Wd"
		for NUM in 4 ; do
			cd ${S}/examples/Python/EX${NUM}
			sed -i 's:#!/usr/bin/env python -w:#!/usr/bin/python -Wd:' * || \
				die "sed EX${NUM} failed"
		done
	fi

	if use ruby; then
		einfo "Patching: #!/usr/bin/env ruby not working with -w argument"
		for NUM in 1 2 3 4 7 ; do
			cd ${S}/examples/Ruby/EX${NUM}
			sed -i 's:#!/usr/bin/env ruby:#!/usr/bin/ruby:' * || \
				die "sed EX${NUM} failed"
		done
	fi
}

src_compile() {
	# Use the Makefile build system to bootstrap SMC
	# using the STAGING install directories.
	cd ${S}/lib/Java
	make install
	cd ${S}/net/sf/smc
	make install

	einfo "Bootstrapping the state machines"
	rm *Context.java
	make install

	# Language library modules that have a useful staging step
	if use c; then
		cd ${S}/lib/C
		make install
	fi
	if use cxx; then
		cd ${S}/lib/C++
		make install
	fi
	if use tcl; then
		cd ${S}/lib/Tcl
		make install
	fi

	# The Perl module will be installed in StateMachine/Statemap.pm
	# Create the folder manually for the tests.
	if use perl; then
		cd ${S}/lib/Perl
		# bug http://sourceforge.net/tracker/index.php?func=detail&aid=1930423&group_id=8964&atid=108964
		mv Makefile.pl Makefile.PL
		make install
		cd ${STAGING}/smc/lib/Perl
		mkdir StateMachine
		cp Statemap.pm StateMachine
	fi

	# Build the examples (particularly the state machine).
	if use examples || use test; then
		if use c; then
			for NUM in 1 2 3 4 ; do
				cd ${S}/examples/C/EX${NUM}
				PATH=./:${PATH}
				make
			done
		fi
		if use cxx; then
			for NUM in 1 2 3 4 5 6; do
				cd ${S}/examples/C++/EX${NUM}
				make
			done
		fi
		if use java; then
			for NUM in 1 2 3 4 5 6 7 ; do
				cd ${S}/examples/Java/EX${NUM}
				make
			done
		fi
		if use perl; then
			for NUM in 1 2 3 4 7 ; do
				cd ${S}/examples/Perl/EX${NUM}
				make
			done
		fi
		if use python; then
			for NUM in 1 2 3 4 7 ; do
				cd ${S}/examples/Python/EX${NUM}
				make
			done
		fi
		if use ruby; then
			for NUM in 1 2 3 4 7 ; do
				cd ${S}/examples/Ruby/EX${NUM}
				make
			done
		fi
		if use tcl; then
			for NUM in 1 2 3 4 5; do
				cd ${S}/examples/Tcl/EX${NUM}
				make
			done
		fi
	fi
}

src_test() {
	# Only the tests 1-3 can be executed in the sandbox (no X11)
	# and terminate (no loop waiting for SIGINT).
	if use c; then
		for NUM in 1 2 3 ; do
			cd ${S}/examples/C/EX${NUM}
			PATH=./:${PATH}
			make test
		done
	fi
	if use cxx; then
		for NUM in 1 2 3 ; do
			cd ${S}/examples/C++/EX${NUM}
			make test
		done
	fi
	if use java; then
		for NUM in 1 2 3 ; do
			cd ${S}/examples/Java/EX${NUM}
			make test
		done
	fi
	if use perl; then
		export PERL5LIB=${STAGING}/smc/lib/Perl
		for NUM in 1 2 3 ; do
			cd ${S}/examples/Perl/EX${NUM}
			make test
		done
	fi
	if use python; then
		export PYTHONPATH=${PYTHONPATH}:${S}/lib/Python
		for NUM in 1 2 3 ; do
			cd ${S}/examples/Python/EX${NUM}
			make test
		done
	fi
	if use ruby; then
		for NUM in 1 2 3 ; do
			cd ${S}/examples/Ruby/EX${NUM}
			make test
		done
	fi
	if use tcl; then
		for NUM in 1 2 3 ; do
			cd ${S}/examples/Tcl/EX${NUM}
			make test
		done
	fi
}

src_install() {
	# Custom install of SMC itself.
	cd ${STAGING}/smc/bin
	java-pkg_dojar Smc.jar
	# information hiding: user Makefiles don't need to know that smc is written in Java
	echo "#!/usr/bin/env sh
java -jar ${JAVA_PKG_JARDEST}/Smc.jar \$*" > smc
	dobin smc

	# Install the staged language modules system-wide
	if use c; then
	cd ${STAGING}/smc/lib
		insinto /usr/include/smc
		doins -r C
	fi
	if use cxx; then
		cd ${STAGING}/smc/lib/C++
		insinto /usr/include/smc
		doins statemap.h
	fi
	if use java; then
		cd ${S}/lib/Java
		java-pkg_dojar statemap.jar
	fi
	if use perl; then
		cd ${S}/lib/Perl
		perl-module_src_prep
		perl-module_src_install
	fi
	if use python; then
		cd ${S}/lib/Python
		distutils_src_install
	fi
	if use ruby; then
		cd ${S}/lib/Ruby
		rm Makefile		# would just install to staging
		ruby_einstall
	fi
	if use tcl; then
		local tclv		# from the otcl ebuild
		tclv=$(grep TCL_VER /usr/include/tcl.h | sed 's/^.*"\(.*\)".*/\1/')
		cd ${STAGING}/smc/lib
		insinto /usr/lib/tcl${tclv}
		doins -r statemap1.0
	fi

	cd ${S}
	dodoc LICENSE.txt
	dodoc README.txt
	if use doc; then
		cd docs
		dodoc SMC_Tutorial.pdf
		cd ${WORKDIR}/htdocs
		dohtml -r *
	fi

	if use examples; then
		local examples=/usr/lib/smc/examples
		insinto ${examples}
		cd ${S}/examples

		# Fix permissions for the executables
		if use c; then
			doins -r C
			for NUM in 1 2 3 ; do
				fperms 555 ${examples}/C/EX${NUM}/checkstring
			done
			fperms 555 ${examples}/C/EX4/traffic
		fi
		
		if use cxx; then
			doins -r C++
			for NUM in 1 2 3 ; do
				fperms 555 ${examples}/C++/EX${NUM}/checkstring
			done
			fperms 555 ${examples}/C++/EX4/traffic
			fperms 555 ${examples}/C++/EX5/sleeper
			fperms 555 ${examples}/C++/EX6/client
			fperms 555 ${examples}/C++/EX6/server
		fi
		
		use java && doins -r Java
		
		if use perl; then
			doins -r Perl
			for NUM in 1 2 3 ; do
				fperms 555 ${examples}/Perl/EX${NUM}/checkstring.pl
			done
			fperms 555 ${examples}/Perl/EX4/traffic.pl
			fperms 555 ${examples}/Perl/EX7/telephone.pl
		fi

		if use python; then
			doins -r Python
			for NUM in 1 2 3 ; do
				fperms 555 ${examples}/Python/EX${NUM}/checkstring.py
			done
			fperms 555 ${examples}/Python/EX4/traffic.py
			fperms 555 ${examples}/Python/EX7/telephone.py
		fi

		if use ruby; then
			doins -r Ruby
			for NUM in 1 2 3 ; do
				fperms 555 ${examples}/Ruby/EX${NUM}/checkstring.rb
			done
			fperms 555 ${examples}/Ruby/EX4/traffic.rb
			fperms 555 ${examples}/Ruby/EX7/telephone.rb
		fi

		if use tcl; then
			doins -r Tcl
			for NUM in 1 2 3 ; do
				fperms 555 ${examples}/Tcl/EX${NUM}/checkstring.tcl
			done
			fperms 555 ${examples}/Tcl/EX4/Traffic.tcl
			fperms 555 ${examples}/Tcl/EX5/Taskman.tcl
		fi
	fi
}
