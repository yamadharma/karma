
IUSE="guile xml2"

inherit eutils

LIBOPTS_PV=19.0.10
AutoFSM_PV=1.4 

S="${WORKDIR}/${P}"
DESCRIPTION="AutoGen: The Automated Text and Program Generation Tool"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

#	mirror://sourceforge/${PN}/autofsm-${AutoFSM_PV}.tar.gz	
#	mirror://sourceforge/${PN}/libopts-${LIBOPTS_PV}.tar.gz

HOMEPAGE="http://autogen.sf.net"

LICENSE="GPL-2"
SLOT="1.5"
KEYWORDS="x86 ppc sparc alpha mips hppa arm"

DEPEND="guile?	dev-util/guile
	xml2?	dev-libs/libxml2"


#src_unpack() 
#{
#
#  unpack ${A}
##  unpack libopts-${LIBOPTS_PV}.tar.gz
#  unpack autofsm-${AutoFSM_PV}.tar.gz
#}

src_compile() 
{

  local myconf
  myconf="${myconf} `use_with guile libguile`"
  myconf="${myconf} `use_with xml2 libxml2`"

  cd ${S}	
  
  econf \
    --with-libregex \
    ${myconf} \
    || die
	
  make || die

}

src_install() 
{

  cd ${S}
  
  emake DESTDIR=${D} install

}