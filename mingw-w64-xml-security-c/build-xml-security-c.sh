#/usr/bin/bash
set -e
source mingw-env

thirdparty_include=(-I.)

release_flags=($CXXFLAGS -O2 "${thirdparty_include[@]}")
  debug_flags=($CXXFLAGS -Og "${thirdparty_include[@]}")

release_defines=(-DNDEBUG -DWIN32 -DWINVER=0x0601 -D_WIN32_WINNT=0x0601 -D_WIN32_WINDOWS=0x0601 -D_SCL_SECURE_NO_WARNINGS -D_CRT_SECURE_NO_DEPRECATE                     -DXSEC_BUILDING_LIBRARY -DXSEC_HAVE_OPENSSL -DXSEC_HAVE_WINCAPI)
  debug_defines=(-D_DEBUG -DWIN32 -DWINVER=0x0601 -D_WIN32_WINNT=0x0601 -D_WIN32_WINDOWS=0x0601 -D_SCL_SECURE_NO_WARNINGS -D_CRT_SECURE_NO_DEPRECATE -D_XSEC_DO_MEMDEBUG -DXSEC_BUILDING_LIBRARY -DXSEC_HAVE_OPENSSL -DXSEC_HAVE_WINCAPI)

function build
{
	local lib_name="$1"; shift

	(
		set -x
		x86_64-w64-mingw32-g++ -c "$@" xsec/canon/*.cpp xsec/dsig/*.cpp xsec/enc/*.cpp xsec/enc/OpenSSL/*.cpp xsec/enc/WinCAPI/*.cpp xsec/enc/XSCrypt/*.cpp xsec/framework/*.cpp xsec/transformers/*.cpp xsec/utils/*.cpp xsec/xenc/impl/*.cpp
		x86_64-w64-mingw32-ar crs ${lib_name} *.o
	)

	rm *.o
} 

#build xml-security-c.lib "${debug_flags[@]}"   "${debug_defines[@]}"
build xml-security-c.lib "${release_flags[@]}" "${release_defines[@]}"
