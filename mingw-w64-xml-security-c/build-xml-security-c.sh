#/usr/bin/bash
set -e
source mingw-env

thirdparty_include=(-I.)

release_flags=($CXXFLAGS -O2 "${thirdparty_include[@]}")
  debug_flags=($CXXFLAGS -Og "${thirdparty_include[@]}")

release_defines=(-D NDEBUG -D WIN32 -D _WIN32_WINNT=0x0502 -D _SCL_SECURE_NO_WARNINGS -D _CRT_SECURE_NO_DEPRECATE                      -D XSEC_BUILDING_LIBRARY -D XSEC_HAVE_OPENSSL -D XSEC_HAVE_WINCAPI)
  debug_defines=(-D _DEBUG -D WIN32 -D _WIN32_WINNT=0x0502 -D _SCL_SECURE_NO_WARNINGS -D _CRT_SECURE_NO_DEPRECATE -D _XSEC_DO_MEMDEBUG -D XSEC_BUILDING_LIBRARY -D XSEC_HAVE_OPENSSL -D XSEC_HAVE_WINCAPI)

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

build xml-security-c.lib "${debug_flags[@]}"   "${debug_defines[@]}"
#build xml-security-c.lib "${release-flags[@]}" "${release-defines[@]}"
