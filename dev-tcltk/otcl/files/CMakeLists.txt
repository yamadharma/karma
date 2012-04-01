project(otcl)
cmake_minimum_required(VERSION 2.6)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules)
set(TARNAME otcl)


# program name, version etc

set(PACKAGE_VERSION "1.14")
set(PACKAGE_NAME "OTcl")
set(PACKAGE_TARNAME "${TARNAME}")
set(PACKAGE_STRING "${PACKAGE_NAME} ${PACKAGE_VERSION}")
set(PACKAGE_BUGREPORT "http://sourceforge.net/projects/otcl-tclcl/")

set(LIBOTCL_SO_VERION_STRING "1.14")
set(LIBOTCL_SO_CUR_VERSION "1")

set(prefix ${CMAKE_INSTALL_PREFIX})
if(NOT DEFINED BIN_INSTALL_DIR)
    set(BIN_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/bin")
endif(NOT DEFINED BIN_INSTALL_DIR)
if(NOT DEFINED LIB_INSTALL_DIR)
    set(LIB_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/lib")
endif(NOT DEFINED LIB_INSTALL_DIR)
if(NOT DEFINED DATA_INSTALL_DIR)
    set(DATA_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/share")
endif(NOT DEFINED DATA_INSTALL_DIR)
if(NOT DEFINED INCLUDE_INSTALL_DIR)
    set(INCLUDE_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/include")
endif(NOT DEFINED INCLUDE_INSTALL_DIR)

message("${LIB_INSTALL_DIR}")
message("${CMAKE_INSTALL_PREFIX}")

find_package(TCL REQUIRED)

find_path(TCL_PRIVATE_INCLUDE_generic tclInt.h
	/usr/local/include/tcl/tcl-private/generic
	/usr/local/include/tcl-private/generic
	/usr/include/tcl/tcl-private/generic
	/usr/include/tcl-private/generic
	/usr/lib64/tcl8.5/include/generic
	/usr/lib/tcl8.5/include/generic
)

find_path(TCL_PRIVATE_INCLUDE_unix tclUnixPort.h
	/usr/local/include/tcl/tcl-private/unix
	/usr/local/include/tcl-private/unix
	/usr/include/tcl/tcl-private/unix
	/usr/include/tcl-private/unix
	/usr/lib64/tcl8.5/include/unix
	/usr/lib/tcl8.5/include/unix
)

#==============================================================================
### libraries and headers
# libotcl

include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${TCL_INCLUDE_PATH}
    ${TCL_PRIVATE_INCLUDE_generic}
    ${TCL_PRIVATE_INCLUDE_unix}
)


set(libotcl_SRC
    otcl.c
)

##### shared
add_library(otcl SHARED ${libotcl_SRC})
target_link_libraries(otcl ${TCL_LIBRARY})
set_target_properties(otcl PROPERTIES
    VERSION ${LIBOTCL_SO_VERION_STRING}
    SOVERSION ${LIBOTCL_SO_CUR_VERSION}
)
##### static
add_library(otcl-static STATIC ${libotcl_SRC})
set_target_properties(otcl-static PROPERTIES OUTPUT_NAME "otcl")
set_target_properties(otcl-static PROPERTIES PREFIX "lib")
##### install libraries
install(TARGETS otcl otcl-static
	LIBRARY DESTINATION ${LIB_INSTALL_DIR}
	ARCHIVE DESTINATION ${LIB_INSTALL_DIR})

##### install header
file(GLOB otcl_INCLUDES "otcl.h")
install(FILES ${otcl_INCLUDES} DESTINATION ${INCLUDE_INSTALL_DIR} COMPONENT Devel)

##### generate ans install pkg-config file.
configure_file(./otcl.pc.cmake ${CMAKE_CURRENT_BINARY_DIR}/otcl.pc)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/otcl.pc DESTINATION ${LIB_INSTALL_DIR}/pkgconfig)


#=======================================================================================
### executable files
### otclsh
include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${TCL_INCLUDE_PATH}
)

set(otclsh_SRC
    otclAppInit.c
)

add_executable(otclsh ${otclsh_SRC})
target_link_libraries(otclsh otcl ${TCL_LIBRARY})
install(TARGETS otclsh RUNTIME DESTINATION ${BIN_INSTALL_DIR})

### owish
include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${TCL_INCLUDE_PATH}
    ${TK_INCLUDE_PATH}
)

set(owish_SRC
    otkAppInit.c
)

add_executable(owish ${owish_SRC})
target_link_libraries(owish otcl ${TCL_LIBRARY} ${TK_LIBRARY})
install(TARGETS owish RUNTIME DESTINATION ${BIN_INSTALL_DIR})

#==========================================================================================
###### docs
file(GLOB otcl_DOCS "doc/*")
install(FILES ${otcl_DOCS} DESTINATION ${DATA_INSTALL_DIR}/doc/otcl)

#=========================================================================================
### test
enable_testing()
add_test(NAME otclsh_TEST COMMAND ./otclsh lib/test.tcl)
add_test(NAME owish_TEST COMMAND ./owish lib/test.tcl)
