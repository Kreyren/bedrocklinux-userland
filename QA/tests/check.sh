#!/bin/sh


# Run various static checkers against the codebase.
#
# Generally, one should strive to get these all to pass submit
# something to Bedrock Linux.  However, the code base is not expected
# to pass all of these at all times, as as different versions of the
# static checkers may cover different things.  Don't fret if this
# returns some warnings.
#
# Unlike the rest of the build system, this links dynamically against
# the system libraries rather than statically against custom-built
# ones.  This removes the need to do things like teach static analysis
# tools about musl-gcc.  It comes at the cost of non-portable resulting
# binaries, but we don't care about the resulting binaries themselves,
# just the code being analyzed.
#
# Libraries you'll need to install:
#
# - uthash
# - libfuse3
# - libcap
# - libattr
#
# Static analysis tools which need to be installed:
#
# - shellcheck
# - cppcheck
# - clang
# - gcc
# - scan-build (usually distributed with clang)
# - shfmt (https://github.com/mvdan/sh)
# - indent (GNU)
#
# check against shellcheck

die() {
	err_code="$1"
	message="$2"

	case $err_code in
		1)
			printf 'FATAL: %s\n' "$message"
			exit "$err_code"
		;;
		lintfail)
			printf 'FATAL: %s\n' "Linting file '$file', failed.."
			exit 1
		;;
		255)
			printf 'FATAL: %s\n' "$message"
			exit "$err_code"
		;;
		*)
			printf 'FATAL: %s\n' "Unrecognized error code argument has been parsed in die function in QA/tests/shell/check.sh"
			exit 255
	esac

	unset err_code message
}

fixme() {
	argument="$1"

	case $argument in
		LintNotImplemented) printf 'FIXME: %s\n' "Unable to check file '$file', $identifier linting is not implemented" ;;
		*) printf 'FIXME: %s\n' "$*"
	esac

	unset argument
}

# shellcheck disable=SC2044 # HOTFIX!
for file in $(find . -not \( \
-path './.git' -prune -o \
-path './vendor' -prune -o \
-name 'LICENSE' -prune -o \
-name '.gitignore' -prune -o \
-name 'os-release' -prune -o \
-name '.keepinfodir' -prune -o \
-name 'include-bedrock' -prune -o \
-name 'build' -prune -o \
-name 'lock' -prune \
\) -type f); do

	# Identify file
	# FIXME: In theory we can use 'file' for this instead
	case "$file" in
		*.c) identifier="C" ;;
		*.sh) identifier="shell" ;;
		*.bash) identifier="bash" ;;
		*.yml) identifier="yaml" ;;
		*.md) identifier="markdown" ;;
		*.png) identifier="png" ;;
		*.zsh) identifier="zsh" ;;
		*.conf) identifier="config" ;;
		*.fish) identifier="fish" ;;
		*.gpg) identifier="gpg" ;;
		*.service) identifier="service" ;;
		*.donotcheck|*.disabled) identifier="DoNotCheck" ;;
		*.json) identifier="json" ;;
		*.Dockerfile) identifier="dockerfile" ;;
		*.xml) identifier="xml" ;;
		*.fetchnext) identifier="fetchnext" ;;
		*/Makefile) identifier="makefile" ;;
		*.bak) identifier="backup" ;;
		*.vmdb) identifier="vmdb" ;;
		*)
			case "$(head -n1 "$file")" in
				'#!/'*'/bash'|'#!/'*' bash') identifier="bash" ;;
				'#!/'*'/sh'|'#!/'*' sh') identifier="shell" ;;
				'#compdef'*) identifier="zsh" ;;
				*) die 255 "Unexpected file '$file' has been parsed in tests, unable to resolve for tests"
			esac
	esac

	# Output message about checked file
	printf "checking $identifier file %s\\n" "${file#./}"

	# Test file based on identifier
	case "$identifier" in
		C)
			cppcheck --error-exitcode=1 "$file" || die lintfail
		;;
		yaml|config|service|gpg|json|xml|dockerfile)
			fixme LintNotImplemented
		;;
		markdown)
			npx markdownlint "$file" || die lintfail
		;;
		makefile)
			if curl https://api.github.com/repos/mrtazz/checkmake/tags 2>/dev/null | grep -qF '"name": "1.0.0",'; then
				checkmake "$file" || die lintfail
			elif ! curl https://api.github.com/repos/mrtazz/checkmake/tags 2>/dev/null | grep -qF '"name": "1.0.0",'; then
				printf 'WARN: %s\n' "Command 'checkmake' used for linting is still in development, this is a stub implementation untill version 1.0.0 is released, skipping fatal assuming not reliable enough"
				checkmake "$file" || true
			else
				printf 'FATAL: %s\n' "Unexpected happend in check.sh while linting makefile"
			fi
		;;
		backup|png|vmdb)
			true # Do not check these
		;;
		DoNotCheck)
			printf 'INFO: %s\n' "File $file is set to be ignored by tests"
		;;
		fetchnext)
			printf 'INFO: %s\n' "fetchnext files are stub"
		;;
		bash)
			shellcheck -x -s bash "$file" || die lintfail
		;;
		shell)
			shellcheck -x -s bash "$file" || die lintfail
		;;
		zsh)
			# zsh are apparently tested agains bash in shellcheck (FIXME: Sanity-check)
			shellcheck -x -s bash "$file" || die lintfail
		;;
		fish)
			fixme LintNotImplemented
		;;
		*) die 255 "Unknown identifier for file '$file' has been parsed, unable to resolve.."
	esac
done
