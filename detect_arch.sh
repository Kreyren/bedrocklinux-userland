#!/bin/sh
# Copyright 2019 Jacob Hrbek <kreyren@rixotstudio.cz>
# Distributed under the terms of the GNU General Public License v3 (https://www.gnu.org/licenses/gpl-3.0.en.html) or later
# Based in part upon 'init' from Bedrock Linux (https://github.com/bedrocklinux/bedrocklinux-userland/blob/master/detect_arch.sh), which is:
# 		Copyright 2012-2018 Daniel Thau <danthau@bedrocklinux.org> as GPLv2

# Detects which CPU architecture Bedrock Linux's build system is producing.
# Outputs two lines:
# - First line is Bedrock's name for the architecture.  This is used, for
# example, in the output installer/updater file name.
# - Second line is context expected in `file` output on one of the binaries.
# This is used to sanity check the resulting binaries are in fact of the
# expected type.

if ! gcc --version >/dev/null 2>&1; then
	printf 'ERROR: %s\n' "gcc not found" >&2
	exit 1
fi

case $(gcc -dumpmachine) in
	aarch64-*)
		printf '%s\n' "aarch64"
		printf '%s\n' "ARM aarch64"
		;;
	arm-*abi)
		printf '%s\n' "armv7l"
		printf '%s\n' "EABI5"
		;;
	arm-*abihf)
		printf '%s\n' "armv7hl"
		printf '%s\n' "EABI5"
		;;
	i386-*)
		printf '%s\n' "i386"
		printf '%s\n' "Intel 80386"
		;;
	i486-*)
		printf '%s\n' "i486"
		printf '%s\n' "Intel 80386"
		;;
	i586-*)
		printf '%s\n' "i586"
		printf '%s\n' "Intel 80386"
		;;
	i686-*)
		printf '%s\n' "i686"
		printf '%s\n' "Intel 80386"
		;;
	mips-*)
		printf '%s\n' "mips"
		printf '%s\n' "MIPS32"
		;;
	mipsel-*)
		printf '%s\n' "mipsel"
		printf '%s\n' "MIPS32"
		;;
	mips64el-*)
		printf '%s\n' "mips64el"
		printf '%s\n' "MIPS64"
		;;
	powerpc64le-*)
		printf '%s\n' "ppc64le"
		printf '%s\n' "64-bit PowerPC"
		;;
	s390x-*)
		printf '%s\n' "s390x"
		printf '%s\n' "IBM S/390"
		;;
	x86_64-*)
		printf '%s\n' "x86_64"
		printf '%s\n' "x86-64"
		;;
	*)
		printf '%s\n' "Unrecognized CPU architecture"
		exit 1
esac

return 0