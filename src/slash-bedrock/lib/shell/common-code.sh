#!/bin/sh
# shellcheck disable=SC2119
# shellcheck disable=SC2154
# shellcheck disable=SC1117
# Copyright 2019 Jacob Hrbek <kreyren@rixotstudio.cz>
# Distributed under the terms of the GNU General Public License v3 (https://www.gnu.org/licenses/gpl-3.0.en.html) or later
# Based in part upon 'common-code' from Bedrock Linux (https://github.com/bedrocklinux/bedrocklinux-userland/blob/master/src/slash-bedrock/share/common-code), which is:
# 		Copyright 2016-2019 Daniel Thau <danthau@bedrocklinux.org> as GPLv2

# Shellcheck global disables
## SC2119 - We are using 'okay' which has logic to die if any argument is assigned to it which conflicts with SC2119 (FIXME?)
## SC2154 - This file is used for sourcing so checking for 'referenced, but not assigned' is useless for QA

# shellcheck source=src/slash-bedrock/lib/shell/define-colors.sh
. /bedrock/lib/shell/define-colors.sh

# shellcheck source=src/slash-bedrock/lib/shell/output-manipulation.sh
. /bedrock/lib/shell/output-manipulation.sh

# shellcheck source=src/slash-bedrock/lib/shell/maintainer.sh
. /bedrock/lib/shell/maintainer.sh

fixme "Common code needs refractor for SC1117, currently disabled as HOTFIX"

# Do not allow changes on runtime (?)
#umask 022

# Print the Kreyrock Linux ASCII logo in font 'Speed'
print_logo() {
	path="$1"
	syntax_err="$2"

	sanitize_func

	# Shift all numerical arguments excluding $0
	while [ "$#" -gt 1 ]; do shift 1; done

	printf "$color_logo%s$color_norm\\n" \
		'______ __                                      ______  ' \
		'___  //_/________________  _______________________  /__' \
		'__  ,<  __  ___/  _ \_  / / /_  ___/  __ \  ___/_  //_/' \
		'_  /| | _  /   /  __/  /_/ /_  /   / /_/ / /__ _  ,<   ' \
		'/_/ |_| /_/    \___/_\__, / /_/    \____/\___/ /_/|_|  ' \
		'                    /____/'

	# QA: Needed?
	# First argument can be provided to indicate a tag line.  This should
	# typically be the contents of /bedrock/etc/bedrock-release such that this
	# function should be called with:
	#     print_logo "$(cat /bedrock/etc/bedrock-release)"
	# This path is not hard-coded so that this function can be called in a
	# non-Kreyrock environment, such as with the installer.
	if [ -n "${path:-}" ]; then
		printf '%s\n' "%35s" "$path"
	fi

	unset path
}

# Sanitized method to create a directory
## Example of input: emkdir "$destdir/etc/opt" 0755 root root
## SYNOPSIS: emkdir [unix-path] [numerical_permission] [group_owner] [user_owner]
# shellcheck disable=SC2034
## Remove once emkdir_[2-4] are assigned!
emkdir() {

	die fixme "Function emkdir is not finished"

	fixme "Make better naming for a emkdir arguments"
	emkdir_destdir="$1"
	emkdir_2="$2"
	emkdir_3="$3"
	emkdir_4="$4"

	fixme "Shift emkdir"
	fixme "Sanitize input of emkdir"

	if [ ! -d "$emkdir_destdir" ]; then
		mkdir "$emkdir_destdir" || die 1 "Unable to make a new directory in '$emkdir_destdir'"
		fixme emkdir "Set read,write,executable accordingly"
		fixme emkdir "Set ownership"
	elif [ ! -f "$emkdir_destdir" ]; then
		die 1 "Path '$emkdir_destdir' is a file, we are unable to make a directory there"
	elif [ ! -b "$emkdir_destdir" ]; then
		die 1 "Path '$emkdir_destdir' is a block device, for safety reasons we are dieing here, mount this block device prior to making a directory on it"
	elif [ -d "$emkdir_destdir" ]; then
		debug "Directory '$emkdir_destdir' already exists"
	elif [ ! -h "$emkdir_destdir" ]; then
		die 1 "Path '$emkdir_destdir' ends up at symbolic link, dieing for safety reasons"
	elif [ ! -S "$emkdir_destdir" ]; then
		die 1 "Path '$emkdir_destdir' is a socket file, dieing for safety reasons"
	fi

	fixme "verify that expected properties of a directory are set"
}

# Compare Kreyrock/Bedrock Linux versions.
# Returns success if the first argument is newer than the second.  Returns failure if the two parameters are equal or if the second is newer than the first.
#
# To compare for equality or inequality, simply do a string comparison.
#
# For example
#     ver_cmp_first_newer() "0.7.0beta5" "0.7.0beta4"
# returns success while
#     ver_cmp_first_newer() "0.7.0beta5" "0.7.0"
# returns failure.
ver_cmp_first_newer() {
	# 0.7.0beta1
	# ^ ^ ^^  ^^
	# | | ||  |\ tag_ver
	# | | |\--+- tag
	# | | \----- patch
	# | \------- minor
	# \--------- major

	left="$1"
	right="$2"
	syntax_err="$3"

	# Die if invalid argument is parsed
	[ -n "$syntax_err" ] && die 2 "Invalid argument has been parsed in function 'ver_cmp_first_newer' - $syntax_err"

	# Compare whole string
	if [ "$left" = "$right" ]; then
		return 1
	elif [ "$left" != "$right" ]; then
		okay
	else
		die 255 "Function 'ver_cmp_first_newer' compare left to right"
	fi

	# Sanitize the input
	# QA: Fix duplicates
	# FIXME: Sanitize for tag and tag version
	case $left in
		[0-9].[0-9].[0-9]*|[0-9][0-9].[0-9].[0-9]*|[0-9][0-9].[0-9][0-9].[0-9]*|[0-9][0-9].[0-9][0-9].[0-9][0-9]*) true ;;
		*) die 255 "Invalid input was parsed in function 'ver_cmp_first_newer': $left"
	esac

	# FIXME: Sanitize for tag and tag version
	case $right in
		[0-9].[0-9].[0-9]*|[0-9][0-9].[0-9].[0-9]*|[0-9][0-9].[0-9][0-9].[0-9]*|[0-9][0-9].[0-9][0-9].[0-9][0-9]*) true ;;
		*) die 255 "Invalid input was parsed in function 'ver_cmp_first_newer': $right"
	esac

	# Define left
	left_major="$(printf '%s\n' "$left" | awk -F'[^0-9][^0-9]*' '{print$1}')"
	left_minor="$(printf '%s\n' "$left" | awk -F'[^0-9][^0-9]*' '{print$2}')"
	left_patch="$(printf '%s\n' "$left" | awk -F'[^0-9][^0-9]*' '{print$3}')"
	left_tag="$(printf '%s\n' "$left" | awk -F'[0-9][0-9]*' '{print$4}')"
	left_tag_ver="$(printf '%s\n' "$left" | awk -F'[^0-9][^0-9]*' '{print$4}')"

	# Define right
	right_major="$(printf '%s\n' "$right" | awk -F'[^0-9][^0-9]*' '{print$1}')"
	right_minor="$(printf '%s\n' "$right" | awk -F'[^0-9][^0-9]*' '{print$2}')"
	right_patch="$(printf '%s\n' "$right" | awk -F'[^0-9][^0-9]*' '{print$3}')"
	right_tag="$(printf '%s\n' "$right" | awk -F'[0-9][0-9]*' '{print$4}')"
	right_tag_ver="$(printf '%s\n' "$right" | awk -F'[^0-9][^0-9]*' '{print$4}')"

	# Compare major
	if [ "$left_major" -gt "$right_major" ]; then
		return 0
	elif [ "$left_major" -lt "$right_major" ]; then
		return 1
	elif [ "$left_major" = "$right_major" ]; then
		okay
	else
		die 255 "Function 'ver_cmp_first_newer' comparing $left to $right major"
	fi

	# Compare minor
	if [ "$left_minor" -gt "$right_minor" ]; then
		return 0
	elif [ "$left_minor" -lt "$right_minor" ]; then
		return 1
	elif [ "$left_minor" = "$right_minor" ]; then
		okay
	else
		die 255 "Function 'ver_cmp_first_newer' comparing $left to $right minor"
	fi

	# Compare patch
	if [ "$left_patch" -gt "$right_patch" ]; then
		return 0
	elif [ "$left_patch" -lt "$right_patch" ]; then
		return 1
	elif [ "$left_patch" = "$right_patch" ]; then
		okay
	else
		die 255 "Function 'ver_cmp_first_newer' comparing $left to $right patch"
	fi

	# Compare tag
	if [ -z "$left_tag" ] && [ -n "$right_tag" ]; then
		return 1
	elif [ -n "$left_tag" ] && [ -z "$right_tag" ]; then
		return 0
	elif [ -n "$left_tag" ] && [ -n "$right_tag" ]; then
		case $left_tag in
			alpha)
				case $right_tag in
					alpha) true ;;
					beta) return 1 ;;
					qamma) return 1 ;;
					*) die 255 "Function 'ver_cmp_first_newer' does not recognize '$right_tag'"
				esac
			;;
			beta)
				case $right_tag in
					alpha) return 0 ;;
					beta) true ;;
					qamma) return 1 ;;
					*) die 255 "Function 'ver_cmp_first_newer' does not recognize '$right_tag'"
				esac
			;;
			*) die 255 "Function 'ver_cmp_first_newer' does not recognize '$left_tag'"
		esac
	elif [ -z "$left_tag" ] && [ -z "$right_tag" ]; then
		die 255 "Function 'ver_cmp_first_newer' failed at comparing $left to $right, is this non-standard version naming?"
	else
		die 255 "Function 'ver_cmp_first_newer' comparing tag"
	fi

	# Compare tag version
	if [ "$left_tag_ver" -gt "$right_tag_ver" ]; then
		return 0
	elif [ "$left_tag_ver" -lt "$right_tag_ver" ]; then
		return 1
	else
		die 255 "Function 'ver_cmp_first_newer' comparing tag version"
	fi

	unset left right left_major left_minor left_patch left_tag left_tag_ver right_major right_minor right_patch right_tag right_tag_ver
}

# Define print_help() then call with:
#     handle_help "${@:-}"
# at the beginning of brl subcommands to get help handling out of the way
# early.
handle_help() {
	# QA: Why are we stripping this?
	args="${1:-}"

	fixme "Is function 'handle_help' needed?"

	case $args in
		-h|--help)
			print_help
			die 0
		;;
		*) die 255 "Handle help"
	esac

	unset args
}

# Initialize step counter.
#
# This is used when performing some action with multiple steps to give the user
# a sense of progress.  Call this before any calls to step(), setting the total
# expected step count.  For example:
#     step_init 3
#     step "Completed step 1"
#     step "Completed step 2"
#     step "Completed step 3"
step_init() {
	steps="$1"

	if [ -n "$steps" ]; then
		shift 1

		syntax_err="$1"
		[ -n "$syntax_err" ] && die 2 "Function step_init expects only one argument, but multiple were parsed: $syntax_err"
	elif [ -n "$steps" ]; then
		die 2 "Function 'step_init' requires at least one argument, but none were parsed"
	else
		die 255 "Function step_init, shifting"
	fi

	step_current=0
	step_total="$steps"

	unset steps
}

# Indicate a given step has been completed.
# See `step_init()` above. (QA: Can't that be part of the same thing?)
step() {
	fixme "step_init should be part of step function"
	step_current=$((step_current + 1))

	# shellcheck disable=SC2034
	## Used in sourcing no need to check for unused
	step_count=$(printf "%d" "$step_total" | wc -c)
	percent=$((step_current * 100 / step_total))
	# shellcheck disable=SC1087
	## Seems to false trigger for array (FIXME, check if confirmed report to shellchck)
	# shellcheck disable=SC2154
	printf "$color_misc[%$step_countd/%d (%3d%%)]$color_norm ${*:-}$color_norm\\n" \
		"$step_current" \
		"$step_total" \
		"$percent"
}

# Abort if parameter is not a legal stratum name.
ensure_legal_stratum_name() {
	fixme "Is function 'ensure_legal_stratum_name' needed? Shoudn't it be part of something else?"
	fixme "Refactor 'ensure_legal_stratum_name' function"
	name="$1"

	w_fixme "Shift in function ensure_legal_stratum_name"

	if printf '%s\n' "$name" | grep -q '[[:space:]/\\:=$"'"'"']'; then
		die 2 "Stratum name '$name' contains disallowed character: whitespace, forward slash, back slash, colon, equals sign, dollar sign, single quote, and/or double quote"
	elif printf '%s\n' "x$name" | grep "^x-"; then
		die 2 "Stratum name '$name' starts with a \"-\" which is not allowed"
	elif [ "$name" = "bedrock" ] || [ "$name" = "init" ]; then
		die 2 "Stratum name '$name' bedrock or init are not allowed since those are reserbed by the backend"
	else
		die 255 "Function 'ensure_legal_stratum_name', checking name"
	fi

	unset name
}

fixme "Shoudn't function 'strip_illegal_stratum_name_characters' be part of something else?"
strip_illegal_stratum_name_characters() {
	cat | sed -e 's![[:space:]/\\:=$"'"'"']!!g' -e "s!^-!!"
}

# Call with:
#     min_args "${#}" "<minimum-expected-arg-count>"
# at the beginning of brl subcommands to error early if insufficient parameters
# are provided.
min_args() {

	fixme "Is function 'min_args' needed? Shoudn't it be part of argument catching?"
	fixme "Function 'min_args' needs refactor"

	arg_cnt="${1}"
	tgt_cnt="${2}"
	if [ "${arg_cnt}" -lt "${tgt_cnt}" ]; then
		die 2 "Insufficient arguments, see '--help'"
	fi
}

# Aborts if not running as root.
require_root() {
	if [ "$(id -u)" -gt "0" ]; then
		die 3 "This operation requires root permission"
	elif [ "$(id -u)" = "0" ]; then
		debug "Script has been executed from root"
	else
		die 255 "require_root, check for root"
	fi
}

# Bedrock lock subsystem management.
#
# Locks specified directory.  If no directory is specified, defaults to
# /bedrock/var/.
#
# This is used to avoid race conditions between various Bedrock subsystems.
# For example, it would be unwise to allow multiple simultaneous attempts to
# enable the same stratum.
#
# By default will this will block until the lock is acquired.  Do not use this
# on long-running commands.  If --nonblock is provided, will return non-zero if
# the lock is already in use rather than block.
#
# The lock is automatically dropped when the shell script (and any child
# processes) ends, and thus an explicit unlock is typically not needed.  See
# drop_lock() for cases where an explicit unlock is needed.
#
# Only one lock may be held at a time.
lock() {
	require_root

	fixme "Function 'lock' needs refactor"

	if [ "${1:-}" = "--nonblock" ]; then
		nonblock="${1}"
		shift
	fi
	dir="${1:-/bedrock/var/}"

	# The list of directories which can be locked is white-listed to help
	# catch typos/bugs.  Abort if not in the list.
	if echo "${dir}" | grep -q "^\\/bedrock\\/var\\/\\?$"; then
		# system lock
		true
	elif echo "${dir}" | grep -q "^\\/bedrock\\/var\\/cache\\/[^/]*/\\?$"; then
		# cache lock
		true
	else
		abort "Attempted to lock non-white-listed item \"${1}\""
	fi

	# Update timestamps on lock to delay removal by cache cleaning logic.
	mkdir -p "${dir}"
	touch "${dir}"
	touch "${dir}/lock"
	exec 9>"${dir}/lock"
	# Purposefully not quoting so an empty string is ignored rather than
	# treated as a parameter.
	# shellcheck disable=SC2086
	flock ${nonblock:-} -x 9
}

# Drop lock on Bedrock subsystem management.
#
# This can be used in two ways:
#
# 1. If a shell script needs to unlock before it finishes.  This is primarily
# intended for long-running shell scripts to strategically lock only required
# sections rather than lock for an unacceptably large period of time.  Call
# with:
#     drop_lock
#
# 2. If the shell script launches a process which will outlive it (and
# consequently the intended lock period), as child processes inherit locks.  To
# drop the lock for just the child process and not the parent script, call with:
#     ( drop_lock ; cmd )
drop_lock() {
	exec 9>&-
}

# Various Bedrock subsystems - most notably brl-fetch - create files which are
# cached for use in the future.  Clean up any that have not been utilized in a
# configured amount of time.
clear_old_cache() {
	require_root

	life="$(cfg_value "miscellaneous" "cache-life")"
	life="${life:-90}"
	one_day="$((24 * 60 * 60))"
	age_in_sec="$((life * one_day))"
	current_time="$(date +%s)"
	if [ "${life}" -ge 0 ]; then
		export del_time="$((current_time - age_in_sec))"
	else
		# negative value indicates cache never times out.  Set deletion
		# time to some far future time which will not be hit while the
		# logic below is running.
		export del_time="$((current_time + one_day))"
	fi

	# If there are no cache items, abort early
	if ! echo /bedrock/var/cache/* >/dev/null 2>&1; then
		return
	fi

	for dir in /bedrock/var/cache/*; do
		# Lock directory so nothing uses it mid-removal.  Skip it if it
		# is currently in use.
		if ! lock --nonblock "${dir}"; then
			continue
		fi

		# Busybox ignores -xdev when combine with -delete and/or -depth.
		# http://lists.busybox.net/pipermail/busybox-cvs/2012-December/033720.html
		# Rather than take performance hit with alternative solutions,
		# disallow mounting into cache directories and drop -xdev.
		#
		# /bedrock/var/cache/ should be on the same filesystem as
		# /bedrock/libexec/busybox.  Save some disk writes and
		# hardlink.
		#
		# busybox also lacks find -ctime, so implement it ourselves
		# with a bit of overhead.
		if ! [ -x "${dir}/busybox" ]; then
			ln /bedrock/libexec/busybox "${dir}/busybox"
		else
			touch "${dir}/busybox"
		fi
		chroot "${dir}" /busybox find / -mindepth 1 ! -type d -exec /busybox sh -c "[ \"\$(stat -c \"%Z\" \"{}\")\" -lt \"${del_time}\" ] && rm -- \"{}\"" \;
		# Remove all empty directories irrelevant of timestamp.  Only cache files.
		chroot "${dir}" /busybox find / -depth -mindepth 1 -type d -exec /busybox rmdir -- "{}" \; >/dev/null 2>&1 || true

		# If the cache directory only contains the above-created lock
		# and busybox, it's no longer caching anything meaningful.
		# Remove it.
		if [ "$(echo "${dir}/"* | wc -w)" -le 2 ]; then
			rm -f "${dir}/lock"
			rm -f "${dir}/busybox"
			rmdir "${dir}"
		fi

		drop_lock "${dir}"
	done
}

# List all strata irrelevant of their state.
list_strata() {
	find /bedrock/strata/ -maxdepth 1 -mindepth 1 -type d -exec basename {} \;
}

# List all aliases irrelevant of their state.
list_aliases() {
	find /bedrock/strata/ -maxdepth 1 -mindepth 1 -type l -exec basename {} \;
}

# Dereference a stratum alias.  If called on a non-alias stratum, that stratum
# is returned.
deref() {
	alias="${1}"
	if ! filepath="$(realpath "/bedrock/strata/${alias}" 2>/dev/null)"; then
		return 1
	elif ! name="$(basename "${filepath}")"; then
		return 1
	else
		echo "${name}"
	fi
}

# Checks if a given file has a given bedrock extended filesystem attribute.
has_attr() {
	file="${1}"
	attr="${2}"
	/bedrock/libexec/getfattr --only-values --absolute-names -n "user.bedrock.${attr}" "${file}" >/dev/null 2>&1
}

# Prints a given file's given bedrock extended filesystem attribute.
get_attr() {
	file="${1}"
	attr="${2}"
	printf "%s\\n" "$(/bedrock/libexec/getfattr --only-values --absolute-names -n "user.bedrock.${attr}" "${file}")"
}

# Sets a given file's given bedrock extended filesystem attribute.
set_attr() {
	file="${1}"
	attr="${2}"
	value="${3}"
	/bedrock/libexec/setfattr -n "user.bedrock.${attr}" -v "${value}" "${file}"
}

# Removes a given file's given bedrock extended filesystem attribute.
rm_attr() {
	file="${1}"
	attr="${2}"
	/bedrock/libexec/setfattr -x "user.bedrock.${attr}" "${file}"
}

# Checks if argument is an existing stratum
is_stratum() {
	[ -d "/bedrock/strata/${1}" ] && ! [ -h "/bedrock/strata/${1}" ]
}

# Checks if argument is an existing alias
is_alias() {
	[ -h "/bedrock/strata/${1}" ]
}

# Checks if argument is an existing stratum or alias
is_stratum_or_alias() {
	[ -d "/bedrock/strata/${1}" ] || [ -h "/bedrock/strata/${1}" ]
}

# Checks if argument is an enabled stratum or alias
is_enabled() {
	[ -e "/bedrock/run/enabled_strata/$(deref "${1}")" ]
}

# Checks if argument is the init-providing stratum
is_init() {
	[ "$(deref init)" = "$(deref "${1}")" ]
}

# Checks if argument is the bedrock stratum
is_bedrock() {
	[ "bedrock" = "$(deref "${1}")" ]
}

# Prints the root of the given stratum from the point of view of the init
# stratum.
#
# Sometimes this function's output is used directly, and sometimes it is
# prepended to another path.  Use `--empty` in the latter situation to indicate
# the init-providing stratum's root should be treated as an empty string to
# avoid doubled up `/` characters.
stratum_root() {
	if [ "${1}" = "--empty" ]; then
		init_root=""
		shift
	else
		init_root="/"
	fi

	stratum="${1}"

	if is_init "${stratum}"; then
		echo "${init_root}"
	else
		echo "/bedrock/strata/$(deref "${stratum}")"
	fi
}

# Applies /bedrock/etc/bedrock.conf symlink requirements to the specified stratum.
#
# Use `--force` to indicate that, should a scenario occur which cannot be
# handled cleanly, remove problematic files.  Otherwise generate a warning.
enforce_symlinks() {
	force=false
	if [ "${1}" = "--force" ]; then
		force=true
		shift
	fi

	stratum="${1}"
	root="$(stratum_root --empty "${stratum}")"

	for link in $(cfg_keys "symlinks"); do
		proc_link="/proc/1/root${root}${link}"
		tgt="$(cfg_values "symlinks" "${link}")"
		proc_tgt="/proc/1/root${root}${tgt}"
		cur_tgt="$(readlink "${proc_link}")" || true

		if [ "${cur_tgt}" = "${tgt}" ]; then
			# This is the desired situation.  Everything is already
			# setup.
			continue
		elif [ -h "${proc_link}" ]; then
			# The symlink exists but is pointing to the wrong
			# location.  Fix it.
			rm -f "${proc_link}"
			ln -s "${tgt}" "${proc_link}"
		elif ! [ -e "${proc_link}" ]; then
			# Nothing exists at the symlink location.  Create it.
			mkdir -p "$(dirname "${proc_link}")"
			ln -s "${tgt}" "${proc_link}"
		elif [ -e "${proc_link}" ] && [ -h "${proc_tgt}" ]; then
			# Non-symlink file exists at symlink location and a
			# symlink exists at the target location.  Swap them and
			# ensure the symlink points where we want it to.
			rm -f "${proc_tgt}"
			mv "${proc_link}" "${proc_tgt}"
			ln -s "${tgt}" "${proc_link}"
		elif [ -e "${proc_link}" ] && ! [ -e "${proc_tgt}" ]; then
			# Non-symlink file exists at symlink location, but
			# nothing exists at tgt location.  Move file to
			# tgt then create symlink.
			mkdir -p "$(dirname "${proc_tgt}")"
			mv "${proc_link}" "${proc_tgt}"
			ln -s "${tgt}" "${proc_link}"
		elif "${force}" && ! mounts_in_dir "${root}" | grep '.'; then
			# A file exists both at the desired location and at the
			# target location.  We do not know which of the two the
			# user wishes to retain.  Since --force was indicated
			# and we found no mount points to indicate otherwise,
			# assume this is a newly fetched stratum and we are
			# free to manipulate its files aggressively.
			rm -rf "${proc_link}"
			ln -s "${tgt}" "${proc_link}"
		elif [ "${link}" = "/var/lib/dbus/machine-id" ]; then
			# Both /var/lib/dbus/machine-id and the symlink target
			# /etc/machine-id exist.  This occurs relatively often,
			# such as when hand creating a stratum.  Rather than
			# nag end-users, pick which to use ourselves.
			rm -f "${proc_link}"
			ln -s "${tgt}" "${proc_link}"
		else
			# A file exists both at the desired location and at the
			# target location.  We do not know which of the two the
			# user wishes to retain.  Play it safe and just
			# generate a warning.
			# QA: Safe to ignore using variables
			# shellcheck disable=SC2059
			warn "File or directory exists at both '$proc_link' and '$proc_tgt'.  Bedrock Linux expects only one to exist. Inspect both and determine which you wish to keep, then remove the other, and finally run 'brl repair $stratum' to remedy the situation."
		fi
	done
}

enforce_shells() {
	for stratum in $(/bedrock/bin/brl list); do
		root="$(stratum_root --empty "${stratum}")"
		shells="/proc/1/root${root}/etc/shells"
		if [ -r "${shells}" ]; then
			cat "/proc/1/root/${root}/etc/shells"
		fi
	done | awk -F/ '/^\// {print "/bedrock/cross/bin/"$NF}' |
		sort | uniq >/bedrock/run/shells

	for stratum in $(/bedrock/bin/brl list); do
		root="$(stratum_root --empty "${stratum}")"
		shells="/proc/1/root${root}/etc/shells"
		if ! [ -r "${shells}" ] || [ "$(awk '/^\/bedrock\/cross\/bin\//' "${shells}")" != "$(cat /bedrock/run/shells)" ]; then
			(
				if [ -r "${shells}" ]; then
					cat "${shells}"
				fi
				cat /bedrock/run/shells
			) | sort | uniq >"${shells}-"
			mv "${shells}-" "${shells}"
		fi
	done
	rm -f /bedrock/run/shells
}

ensure_line() {
	file="${1}"
	good_regex="${2}"
	bad_regex="${3}"
	value="${4}"

	if grep -q "${good_regex}" "${file}"; then
		true
	elif grep -q "${bad_regex}" "${file}"; then
		sed "s!${bad_regex}!${value}!" "${file}" >"${file}-new"
		mv "${file}-new" "${file}"
	else
		(
			cat "${file}"
			echo "${value}"
		) >"${file}-new"
		mv "${file}-new" "${file}"
	fi
}

enforce_id_ranges() {
	for stratum in $(/bedrock/bin/brl list); do
		# /etc/login.defs is global such that in theory we only need to
		# update one file.  However, the logic to potentially update
		# multiple is retained in case it is ever made local.
		cfg="/bedrock/strata/${stratum}/etc/login.defs"
		if [ -e "${cfg}" ]; then
			ensure_line "${cfg}" "^[ \t]*UID_MIN[ \t][ \t]*1000$" "^[ \t]*UID_MIN\>.*$" "UID_MIN 1000"
			ensure_line "${cfg}" "^[ \t]*UID_MAX[ \t][ \t]*65534$" "^[ \t]*UID_MAX\>.*$" "UID_MAX 65534"
			ensure_line "${cfg}" "^[ \t]*SYS_UID_MIN[ \t][ \t]*1$" "^[ \t]*SYS_UID_MIN\>.*$" "SYS_UID_MIN 1"
			ensure_line "${cfg}" "^[ \t]*SYS_UID_MAX[ \t][ \t]*999$" "^[ \t]*SYS_UID_MAX\>.*$" "SYS_UID_MAX 999"
			ensure_line "${cfg}" "^[ \t]*GID_MIN[ \t][ \t]*1000$" "^[ \t]*GID_MIN\>.*$" "GID_MIN 1000"
			ensure_line "${cfg}" "^[ \t]*GID_MAX[ \t][ \t]*65534$" "^[ \t]*GID_MAX\>.*$" "GID_MAX 65534"
			ensure_line "${cfg}" "^[ \t]*SYS_GID_MIN[ \t][ \t]*1$" "^[ \t]*SYS_GID_MIN\>.*$" "SYS_GID_MIN 1"
			ensure_line "${cfg}" "^[ \t]*SYS_GID_MAX[ \t][ \t]*999$" "^[ \t]*SYS_GID_MAX\>.*$" "SYS_GID_MAX 999"
		fi
		cfg="/bedrock/strata/${stratum}/etc/adduser.conf"
		if [ -e "${cfg}" ]; then
			ensure_line "${cfg}" "^FIRST_UID=1000$" "^FIRST_UID=.*$" "FIRST_UID=1000"
			ensure_line "${cfg}" "^LAST_UID=65534$" "^LAST_UID=.*$" "LAST_UID=65534"
			ensure_line "${cfg}" "^FIRST_SYSTEM_UID=1$" "^FIRST_SYSTEM_UID=.*$" "FIRST_SYSTEM_UID=1"
			ensure_line "${cfg}" "^LAST_SYSTEM_UID=999$" "^LAST_SYSTEM_UID=.*$" "LAST_SYSTEM_UID=999"
			ensure_line "${cfg}" "^FIRST_GID=1000$" "^FIRST_GID=.*$" "FIRST_GID=1000"
			ensure_line "${cfg}" "^LAST_GID=65534$" "^LAST_GID=.*$" "LAST_GID=65534"
			ensure_line "${cfg}" "^FIRST_SYSTEM_GID=1$" "^FIRST_SYSTEM_GID=.*$" "FIRST_SYSTEM_GID=1"
			ensure_line "${cfg}" "^LAST_SYSTEM_GID=999$" "^LAST_SYSTEM_GID=.*$" "LAST_SYSTEM_GID=999"
		fi
	done
}

# List of architectures Bedrock Linux supports.
brl_archs() {
	cat <<EOF
aarch64
armv7hl
armv7l
mips
mipsel
mips64el
ppc64le
s390x
i386
i486
i586
i686
x86_64
EOF
}

#
# Many distros have different phrasing for the same exact CPU architecture.
# Standardize witnessed variations against Bedrock's convention.
#
standardize_architecture() {
	case "${1}" in
	aarch64 | arm64) echo "aarch64" ;;
	armhf | armhfp | armv7h | armv7hl | armv7a) echo "armv7hl" ;;
	arm | armel | armle | arm7 | armv7 | armv7l | armv7a_hardfp) echo "armv7l" ;;
	i386) echo "i386" ;;
	i486) echo "i486" ;;
	i586) echo "i586" ;;
	x86 | i686) echo "i686" ;;
	mips | mipsbe | mipseb) echo "mips" ;;
	mipsel | mipsle) echo "mipsel" ;;
	mips64el | mips64le) echo "mips64el" ;;
	ppc64el | ppc64le) echo "ppc64le" ;;
	s390x) echo "s390x" ;;
	amd64 | x86_64) echo "x86_64" ;;
	esac
}

get_system_arch() {
	if ! system_arch="$(standardize_architecture "$(get_attr "/bedrock/strata/bedrock/" "arch")")" || [ -z "${system_arch}" ]; then
		system_arch="$(standardize_architecture "$(uname -m)")"
	fi
	if [ -z "${system_arch}" ]; then
		abort "Unable to determine system CPU architecture"
	fi
	echo "${system_arch}"
}

check_arch_supported_natively() {
	arch="${1}"
	system_arch="$(get_system_arch)"
	if [ "${system_arch}" = "${arch}" ]; then
		return
	fi

	case "${system_arch}:${arch}" in
	aarch64:armv7hl) return ;;
	aarch64:armv7l) return ;;
	armv7hl:armv7l) return ;;
	# Not technically true, but binfmt does not differentiate
	armv7l:armv7hl) return ;;
	x86_64:i386) return ;;
	x86_64:i486) return ;;
	x86_64:i586) return ;;
	x86_64:i686) return ;;
	esac

	false
	return
}

qemu_binary_for_arch() {
	case "${1}" in
	aarch64) echo "qemu-aarch64-static" ;;
	i386) echo "qemu-i386-static" ;;
	i486) echo "qemu-i386-static" ;;
	i586) echo "qemu-i386-static" ;;
	i686) echo "qemu-i386-static" ;;
	armv7hl) echo "qemu-arm-static" ;;
	armv7l) echo "qemu-arm-static" ;;
	mips) echo "qemu-mips-static" ;;
	mipsel) echo "qemu-mipsel-static" ;;
	mips64el) echo "qemu-mips64el-static" ;;
	ppc64le) echo "qemu-ppc64le-static" ;;
	s390x) echo "qemu-s390x-static" ;;
	x86_64) echo "qemu-x86_64-static" ;;
	esac
}

setup_binfmt_misc() {
	stratum="${1}"
	mount="/proc/sys/fs/binfmt_misc"

	arch="$(get_attr "/bedrock/strata/${stratum}" "arch" 2>/dev/null)" || true

	# If stratum is native, skip setting up binfmt_misc
	if [ -z "${arch}" ] || check_arch_supported_natively "${arch}"; then
		return
	fi

	# ensure module is loaded
	if ! [ -d "${mount}" ]; then
		modprobe binfmt_misc
	fi
	if ! [ -d "${mount}" ]; then
		abort "Unable to mount binfmt_misc to register handler for ${stratum}"
	fi

	# mount binfmt_misc if it is not already mounted
	if ! [ -r "${mount}/register" ]; then
		mount binfmt_misc -t binfmt_misc "${mount}"
	fi
	if ! [ -r "${mount}/register" ]; then
		abort "Unable to mount binfmt_misc to register handler for ${stratum}"
	fi

	# Gather information needed to register with binfmt
	unset name
	unset sum
	unset reg
	case "${arch}" in
	aarch64)
		name="qemu-aarch64"
		sum="707cf2bfbdb58152fc97ed4c1643ecd16b064465"
		reg=':qemu-aarch64:M:0:\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-aarch64-static:OC'
		;;
	armv7l | armv7hl)
		name="qemu-arm"
		sum="bbada633c3eda72c9be979357b51c0ac8edb9eba"
		reg=':qemu-arm:M:0:\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-static:OC'
		;;
	mips)
		name="qemu-mips"
		sum="5751a5cf2bbc2cb081d314f4b340ca862c11b90c"
		reg=':qemu-mips:M:0:\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08:\xff\xff\xff\xff\xff\xff\xff\x00\xfe\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:/usr/bin/qemu-mips-static:OC'
		;;
	mipsel)
		name="qemu-mipsel"
		sum="2bccf248508ffd8e460b211f5f4159906754a498"
		reg=':qemu-mipsel:M:0:\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xfe\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-mipsel-static:OC'
		;;
	mips64el)
		name="qemu-mips64el"
		sum="ed9513fa110eed9085cf21a789a55e047f660237"
		reg=':qemu-mips64el:M:0:\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xfe\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-mips64el-static:OC'
		;;
	ppc64le)
		name="qemu-ppc64le"
		sum="b42c326e62f05cae1d412d3b5549a06228aeb409"
		reg=':qemu-ppc64le:M:0:\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x15\x00:\xff\xff\xff\xff\xff\xff\xff\xfc\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\x00:/usr/bin/qemu-ppc64le-static:OC'
		;;
	s390x)
		name="qemu-s390x"
		sum="9aed062ea40b5388fd4dea5e5da837c157854021"
		reg=':qemu-s390x:M:0:\x7fELF\x02\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x16:\xff\xff\xff\xff\xff\xff\xff\xfc\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:/usr/bin/qemu-s390x-static:OC'
		;;
	i386 | i486 | i586 | i686)
		name="qemu-i386"
		sum="59723d1b5d3983ff606ff2befc151d0a26543707"
		reg=':qemu-i386:M:0:\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03\x00:\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfe\xff\xff\xff:/usr/bin/qemu-i386-static:OC'
		;;
	x86_64)
		name="qemu-x86_64"
		sum="823c58bdb19743335c68d036fdc795e3be57e243"
		reg=':qemu-x86_64:M:0:\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00:\xff\xff\xff\xff\xff\xfe\xfe\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-x86_64-static:OC'
		;;
	*)
		abort "Stratum \"${stratum}\" has unrecognized arch ${arch}"
		;;
	esac

	# Remove registration with differing values.
	if [ -r "${mount}/${name}" ] && [ "$(sha1sum "${mount}/${name}" | awk '{print$1}')" != "${sum}" ]; then
		einfo "Removing conflicting $arch binfmt registration"
		printf '%s\n' '-1' >"$mount/$name"
	fi

	# Register if not already registered
	if ! [ -r "$mount/$name" ]; then
		printf '%s\n' "$reg" >"$mount/register"
	fi

	# Enable
	printf "1" >"$mount/$name"
	printf "1" >"$mount/status"
}

# Run executable in /bedrock/libexec with init stratum.
#
# Requires the init stratum to be enabled, which is typically true in a
# healthy, running Bedrock system.
stinit() {
	cmd="${1}"
	shift
	/bedrock/bin/strat init "/bedrock/libexec/${cmd}" "${@:-}"
}

# Kill all processes chrooted into the specified directory or a subdirectory
# thereof.
#
# Use `--init` to indicate this should be run from the init stratum's point of
# view.
kill_chroot_procs() {
	if [ "${1:-}" = "--init" ]; then
		x_readlink="stinit busybox readlink"
		x_realpath="stinit busybox realpath"
		shift
	else
		x_readlink="readlink"
		x_realpath="realpath"
	fi

	dir="$(${x_realpath} "${1}")"

	require_root

	sent_sigterm=false

	# Try SIGTERM.  Since this is not atomic - a process could spawn
	# between recognition of its parent and killing its parent - try
	# multiple times to minimize the chance we miss one.
	for _ in $(seq 1 5); do
		for pid in $(ps -A -o pid); do
			root="$(${x_readlink} "/proc/${pid}/root")" || continue

			case "${root}" in
			"${dir}" | "${dir}/"*)
				kill "${pid}" 2>/dev/null || true
				sent_sigterm=true
				;;
			esac
		done
	done

	# If we sent SIGTERM to any process, give it time to finish then
	# ensure it is dead with SIGKILL.  Again, try multiple times just in
	# case new processes spawn.
	if "${sent_sigterm}"; then
		# sleep for a quarter second
		usleep 250000
		for _ in $(seq 1 5); do
			for pid in $(ps -A -o pid); do
				root="$(${x_readlink} "/proc/${pid}/root")" || continue

				case "${root}" in
				"${dir}" | "${dir}/"*)
					kill -9 "${pid}" 2>/dev/null || true
					;;
				esac
			done
		done
	fi

	# Unless we were extremely unlucky with kill/spawn race conditions or
	# zombies, all target processes should be dead.  Check our work just in
	# case.
	for pid in $(ps -A -o pid); do
		root="$(${x_readlink} "/proc/${pid}/root")" || continue

		case "${root}" in
		"${dir}" | "${dir}/"*)
			abort "Unable to kill all processes within \"${dir}\"."
			;;
		esac
	done
}

# List all mounts on or under a given directory.
#
# Use `--init` to indicate this should be run from the init stratum's point of
# view.
mounts_in_dir() {
	if [ "${1:-}" = "--init" ]; then
		x_realpath="stinit busybox realpath"
		pid="1"
		shift
	else
		x_realpath="realpath"
		pid="${$}"
	fi

	# If the directory does not exist, there cannot be any mount points on/under it.
	if ! dir="$(${x_realpath} "${1}" 2>/dev/null)"; then
		return
	fi

	awk -v"dir=${dir}" -v"subdir=${dir}/" '
		$5 == dir || substr($5, 1, length(subdir)) == subdir {
			print $5
		}
	' "/proc/${pid}/mountinfo"
}

# Unmount all mount points in a given directory or its subdirectories.
#
# Use `--init` to indicate this should be run from the init stratum's point of
# view.
umount_r() {
	if [ "${1:-}" = "--init" ]; then
		x_mount="stinit busybox mount"
		x_umount="stinit busybox umount"
		init_flag="--init"
		shift
	else
		x_mount="mount"
		x_umount="umount"
		init_flag=""
	fi

	dir="${1}"

	cur_cnt=$(mounts_in_dir ${init_flag} "${dir}" | wc -l)
	prev_cnt=$((cur_cnt + 1))
	while [ "${cur_cnt}" -lt "${prev_cnt}" ]; do
		prev_cnt=${cur_cnt}
		for mount in $(mounts_in_dir ${init_flag} "${dir}" | sort -ru); do
			${x_mount} --make-rprivate "${mount}" 2>/dev/null || true
		done
		for mount in $(mounts_in_dir ${init_flag} "${dir}" | sort -ru); do
			${x_mount} --make-rprivate "${mount}" 2>/dev/null || true
			${x_umount} -l "${mount}" 2>/dev/null || true
		done
		cur_cnt="$(mounts_in_dir ${init_flag} "${dir}" | wc -l || true)"
	done

	if mounts_in_dir ${init_flag} "${dir}" | grep -q '.'; then
		abort "Unable to unmount all mounts at \"${dir}\"."
	fi
}

disable_stratum() {
	stratum="${1}"

	# Remove stratum from /bedrock/cross.  This needs to happen before the
	# stratum is disabled so that crossfs does not try to use a disabled
	# stratum's processes and get confused, as crossfs does not check/know
	# about /bedrock/run/enabled_strata.
	cfg_crossfs_rm_strata "/proc/1/root/bedrock/strata/bedrock/bedrock/cross" "${stratum}"

	# Mark the stratum as disabled so nothing else tries to use the
	# stratum's files while we're disabling it.
	rm -f "/bedrock/run/enabled_strata/${stratum}"

	# Kill all running processes.
	root="$(stratum_root "${stratum}")"
	kill_chroot_procs --init "${root}"
	# Remove all mounts.
	root="$(stratum_root "${stratum}")"
	umount_r --init "${root}"
}

# Attempt to remove a directory while minimizing the chance of accidentally
# removing desired files.  Prefer aborting over accidentally removing the wrong
# file.
less_lethal_rm_rf() {
	dir="${1}"

	kill_chroot_procs "${dir}"
	umount_r "${dir}"

	# Busybox ignores -xdev when combine with -delete and/or -depth, and
	# thus -delete and -depth must not be used.
	# http://lists.busybox.net/pipermail/busybox-cvs/2012-December/033720.html

	# Remove all non-directories.  Transversal order does not matter.
	cp /proc/self/exe "${dir}/busybox"
	chroot "${dir}" ./busybox find / -xdev -mindepth 1 ! -type d -exec rm {} \; || true

	# Remove all directories.
	# We cannot force `find` to traverse depth-first.  We also cannot rely
	# on `sort` in case a directory has a newline in it.  Instead, retry while tracking how much is left
	cp /proc/self/exe "${dir}/busybox"
	current="$(chroot "${dir}" ./busybox find / -xdev -mindepth 1 -type d -exec echo x \; | wc -l)"
	prev=$((current + 1))
	while [ "${current}" -lt "${prev}" ]; do
		chroot "${dir}" ./busybox find / -xdev -mindepth 1 -type d -exec rmdir {} \; 2>/dev/null || true
		prev="${current}"
		current="$(chroot "${dir}" ./busybox find / -xdev -mindepth 1 -type d -exec echo x \; | wc -l)"
	done

	rm "${dir}/busybox"
	rmdir "${dir}"
}

# Prints colon-separated information about stratum's given mount point:
#
# - The mount point's filetype, or "missing" if there is no mount point.
# - "true"/"false" indicating if the mount point is global
# - "true"/"false" indicating if shared (i.e. child mounts will be global)
mount_details() {
	stratum="${1:-}"
	mount="${2:-}"

	root="$(stratum_root --empty "${stratum}")"
	br_root="/bedrock/strata/bedrock"

	if ! path="$(stinit busybox realpath "${root}${mount}" 2>/dev/null)"; then
		echo "missing:false:false"
		return
	fi

	# Get filesystem
	mountline="$(awk -v"mnt=${path}" '$5 == mnt' "/proc/1/mountinfo")"
	if [ -z "${mountline}" ]; then
		echo "missing:false:false"
		return
	fi
	filesystem="$(echo "${mountline}" | awk '{
		for (i=7; i<NF; i++) {
			if ($i == "-") {
				print$(i+1)
				exit
			}
		}
	}')"

	if ! br_path="$(stinit busybox realpath "${br_root}${mount}" 2>/dev/null)"; then
		echo "${filesystem}:false:false"
		return
	fi

	# Get global
	global=false
	if is_bedrock "${stratum}"; then
		global=true
	elif [ "${mount}" = "/etc" ] && [ "${filesystem}" = "fuse.etcfs" ]; then
		# /etc is a virtual filesystem that needs to exist per-stratum,
		# and thus the check below would indicate it is local.
		# However, the actual filesystem implementation effectively
		# implements global redirects, and thus it should be considered
		# global.
		global=true
	else
		path_stat="$(stinit busybox stat "${path}" 2>/dev/null | awk '$1 == "File:" {$2=""} $5 == "Links:" {$6=""}1')"
		br_path_stat="$(stinit busybox stat "${br_path}" 2>/dev/null | awk '$1 == "File:" {$2=""} $5 == "Links:" {$6=""}1')"
		if [ "${path_stat}" = "${br_path_stat}" ]; then
			global=true
		fi
	fi

	# Get shared
	shared_nr="$(echo "${mountline}" | awk '{
		for (i=7; i<NF; i++) {
			if ($i ~ "shared:[0-9]"){
				substr(/shared:/,"",$i)
				print $i
				exit
			} else if ($i == "-"){
				print ""
				exit
			}
		}
	}')"
	br_mountline="$(awk -v"mnt=${br_path}" '$5 == mnt' "/proc/1/mountinfo")"
	if [ -z "${br_mountline}" ]; then
		br_shared_nr=""
	else
		br_shared_nr="$(echo "${br_mountline}" | awk '{
			for (i=7; i<NF; i++) {
				if ($i ~ "shared:[0-9]"){
					substr(/shared:/,"",$i)
					print $i
					exit
				} else if ($i == "-"){
					print ""
					exit
				}
			}
		}')"
	fi
	if [ -n "${shared_nr}" ] && [ "${shared_nr}" = "${br_shared_nr}" ]; then
		shared=true
	else
		shared=false
	fi

	echo "${filesystem}:${global}:${shared}"
	return
}

# Pre-parse bedrock.conf:
#
# - join any continued lines
# - strip comments
# - drop blank lines
cfg_preparse() {
	awk -v"RS=" '{
		# join continued lines
		gsub(/\\\n/, "")
		print
	}' /bedrock/etc/bedrock.conf | awk '
	/[#;]/ {
		# strip comments
		sub(/#.*$/, "")
		sub(/;.*$/, "")
	}
	# print non-blank lines
	/[^ \t\r\n]/'
}

# Print all bedrock.conf sections
cfg_sections() {
	cfg_preparse | awk '
	/^[ \t\r]*\[.*\][ \t\r]*$/ {
		sub(/^[ \t\r]*\[[ \t\r]*/, "")
		sub(/[ \t\r]*\][ \t\r]*$/, "")
		print
	}'
}

# Print all bedrock.conf keys in specified section
cfg_keys() {
	cfg_preparse | awk -v"tgt_section=${1}" '
	/^[ \t\r]*\[.*\][ \t\r]*$/ {
		sub(/^[ \t\r]*\[[ \t\r]*/, "")
		sub(/[ \t\r]*\][ \t\r]*$/, "")
		in_section = ($0 == tgt_section)
		next
	}
	/=/ && in_section {
		key = substr($0, 0, index($0, "=")-1)
		gsub(/[ \t\r]*/, "", key)
		print key
	}'
}

# Print bedrock.conf value for specified section and key.  Assumes only one
# value and does not split value.
cfg_value() {
	cfg_preparse | awk -v"tgt_section=${1}" -v"tgt_key=${2}" '
	/^[ \t\r]*\[.*\][ \t\r]*$/ {
		sub(/^[ \t\r]*\[[ \t\r]*/, "")
		sub(/[ \t\r]*\][ \t\r]*$/, "")
		in_section = ($0 == tgt_section)
		next
	}
	/=/ && in_section {
		key = substr($0, 0, index($0, "=")-1)
		gsub(/[ \t\r]*/, "", key)
		if (key != tgt_key) {
			next
		}
		value = substr($0, index($0, "=")+1)
		gsub(/^[ \t\r]*/, "", value)
		gsub(/[ \t\r]*$/, "", value)
		print value
	}'
}

# Print bedrock.conf values for specified section and key.  Expects one or more
# values in a comma-separated list and splits accordingly.
cfg_values() {
	cfg_preparse | awk -v"tgt_section=${1}" -v"tgt_key=${2}" '
	/^[ \t\r]*\[.*\][ \t\r]*$/ {
		sub(/^[ \t\r]*\[[ \t\r]*/, "")
		sub(/[ \t\r]*\][ \t\r]*$/, "")
		in_section = ($0 == tgt_section)
		next
	}
	/=/ && in_section {
		key = substr($0, 0, index($0, "=")-1)
		gsub(/[ \t\r]*/, "", key)
		if (key != tgt_key) {
			next
		}
		values_string = substr($0, index($0, "=")+1)
		values_len = split(values_string, values, ",")
		for (i = 1; i <= values_len; i++) {
			sub(/^[ \t\r]*/, "", values[i])
			sub(/[ \t\r]*$/, "", values[i])
			print values[i]
		}
	}'
}

# Configure crossfs mount point per bedrock.conf configuration.
cfg_crossfs() {
	mount="${1}"

	# For the purposes here, treat local alias as a stratum.  We do not
	# want to dereference it, but rather pass it directly to crossfs.  It
	# will dereference it at runtime.

	strata=""
	for stratum in $(list_strata); do
		if is_enabled "${stratum}" && has_attr "/bedrock/strata/${stratum}" "show_cross"; then
			strata="${strata} ${stratum}"
		fi
	done

	aliases=""
	for alias in $(list_aliases); do
		if [ "${alias}" = "local" ]; then
			continue
		fi
		if ! stratum="$(deref "${alias}")"; then
			continue
		fi
		if is_enabled "${stratum}" && has_attr "/bedrock/strata/${stratum}" "show_cross"; then
			aliases="${aliases} ${alias}:${stratum}"
		fi
	done

	cfg_preparse | awk \
		-v"unordered_strata_string=${strata}" \
		-v"alias_string=$aliases" \
		-v"fscfg=${mount}/.bedrock-config-filesystem" '
	BEGIN {
		# Create list of available strata
		len = split(unordered_strata_string, n_unordered_strata, " ")
		for (i = 1; i <= len; i++) {
			unordered_strata[n_unordered_strata[i]] = n_unordered_strata[i]
		}
		# Create alias look-up table
		len = split(alias_string, n_aliases, " ")
		for (i = 1; i <= len; i++) {
			split(n_aliases[i], a, ":")
			aliases[a[1]] = a[2]
		}
	}
	# get section
	/^[ \t\r]*\[.*\][ \t\r]*$/ {
		section=$0
		sub(/^[ \t\r]*\[[ \t\r]*/, "", section)
		sub(/[ \t\r]*\][ \t\r]*$/, "", section)
		key = ""
		next
	}
	# Skip lines that are not key-value pairs
	!/=/ {
		next
	}
	# get key and values
	/=/ {
		key = substr($0, 0, index($0, "=")-1)
		gsub(/[ \t\r]*/, "", key)
		values_string = substr($0, index($0, "=")+1)
		values_len = split(values_string, n_values, ",")
		for (i = 1; i <= values_len; i++) {
			gsub(/[ \t\r]*/, "", n_values[i])
		}
	}
	# get ordered list of strata
	section == "cross" && key == "priority" {
		# add priority strata first, in order
		for (i = 1; i <= values_len; i++) {
			# deref
			if (n_values[i] in aliases) {
				n_values[i] = aliases[n_values[i]]
			}
			# add to ordered list
			if (n_values[i] in unordered_strata) {
				n_strata[++strata_len] = n_values[i]
				strata[n_values[i]] = n_values[i]
			}
		}
		# init stratum should be highest unspecified priority
		if ("init" in aliases && !(aliases["init"] in strata)) {
			stratum=aliases["init"]
			n_strata[++strata_len] = stratum
			strata[stratum] = stratum
		}
		# rest of strata except bedrock
		for (stratum in unordered_strata) {
			if (stratum == "bedrock") {
				continue
			}
			if (!(stratum in strata)) {
				if (stratum in aliases) {
					stratum = aliases[stratum]
				}
				n_strata[++strata_len] = stratum
				strata[stratum] = stratum
			}
		}
		# if not specified, bedrock stratum should be at end
		if (!("bedrock" in strata)) {
			n_strata[++strata_len] = "bedrock"
			strata["bedrock"] = "bedrock"
		}
	}
	# build target list
	section ~ /^cross-/ {
		filter = section
		sub(/^cross-/, "", filter)
		# add stratum-specific items first
		for (i = 1; i <= values_len; i++) {
			if (!index(n_values[i], ":")) {
				continue
			}

			stratum = substr(n_values[i], 0, index(n_values[i],":")-1)
			path = substr(n_values[i], index(n_values[i],":")+1)
			if (stratum in aliases) {
				stratum = aliases[stratum]
			}
			if (!(stratum in strata) && stratum != "local") {
				continue
			}

			target = filter" /"key" "stratum":"path
			if (!(target in targets)) {
				n_targets[++targets_len] =  target
				targets[target] = target
			}
		}

		# add all-strata items in stratum order
		for (i = 1; i <= strata_len; i++) {
			for (j = 1; j <= values_len; j++) {
				if (index(n_values[j], ":")) {
					continue
				}

				target = filter" /"key" "n_strata[i]":"n_values[j]
				if (!(target in targets)) {
					n_targets[++targets_len] =  target
					targets[target] = target
				}
			}
		}
	}
	# write new config
	END {
		# remove old configuration
		print "clear" >> fscfg
		fflush(fscfg)
		# write new configuration
		for (i = 1; i <= targets_len; i++) {
			print "add "n_targets[i] >> fscfg
			fflush(fscfg)
		}
		close(fscfg)
		exit 0
	}
	'
}

# Remove a stratum's items from a crossfs mount.  This is preferable to a full
# reconfiguration where available, as it is faster and it does not even
# temporarily remove items we wish to retain.
cfg_crossfs_rm_strata() {
	mount="${1}"
	stratum="${2}"

	awk -v"stratum=${stratum}" \
		-v"fscfg=${mount}/.bedrock-config-filesystem" \
		-F'[ :]' '
	BEGIN {
		while ((getline < fscfg) > 0) {
			if ($3 == stratum) {
				lines[$0] = $0
			}
		}
		close(fscfg)
		for (line in lines) {
			print "rm "line >> fscfg
			fflush(fscfg)
		}
		close(fscfg)
	}'
}

# Configure etcfs mount point per bedrock.conf configuration.
cfg_etcfs() {
	mount="${1}"

	cfg_preparse | awk \
		-v"fscfg=${mount}/.bedrock-config-filesystem" '
	# get section
	/^[ \t\r]*\[.*\][ \t\r]*$/ {
		section=$0
		sub(/^[ \t\r]*\[[ \t\r]*/, "", section)
		sub(/[ \t\r]*\][ \t\r]*$/, "", section)
		key = ""
	}
	# get key and values
	/=/ {
		key = substr($0, 0, index($0, "=")-1)
		gsub(/[ \t\r]*/, "", key)
		values_string = substr($0, index($0, "=")+1)
		values_len = split(values_string, n_values, ",")
		for (i = 1; i <= values_len; i++) {
			gsub(/[ \t\r]*/, "", n_values[i])
		}
	}
	# Skip lines that are not key-value pairs
	!/=/ {
		next
	}
	# build target list
	section == "global" && key == "etc" {
		for (i = 1; i <= values_len; i++) {
			target = "global /"n_values[i]
			n_targets[++targets_len] = target
			targets[target] = target
		}
	}
	section == "etc-inject" {
		target = "override inject /"key" "n_values[1]
		n_targets[++targets_len] = target
		targets[target] = target
		while (key ~ "/") {
			sub("/[^/]*$", "", key)
			if (key != "") {
				target = "override directory /"key" x"
				n_targets[++targets_len] = target
				targets[target] = target
			}
		}
	}
	section == "etc-symlinks" {
		target = "override symlink /"key" "n_values[1]
		n_targets[++targets_len] = target
		targets[target] = target
		while (key ~ "/") {
			sub("/[^/]*$", "", key)
			if (key != "") {
				target = "override directory /"key" x"
				n_targets[++targets_len] = target
				targets[target] = target
			}
		}
	}
	END {
		# apply difference to config
		while ((getline < fscfg) > 0) {
			n_currents[++currents_len] = $0
			currents[$0] = $0
		}
		close(fscfg)
		for (i = 1; i <= currents_len; i++) {
			if (!(n_currents[i] in targets)) {
				$0=n_currents[i]
				print "rm_"$1" "$3 >> fscfg
				fflush(fscfg)
			}
		}
		for (i = 1; i <= targets_len; i++) {
			if (!(n_targets[i] in currents)) {
				print "add_"n_targets[i] >> fscfg
				fflush(fscfg)
			}
		}
		close(fscfg)
	}
	'

	# Injection content may be incorrect if injection files have changed.
	# Check for this situation and, if so, instruct etcfs to update
	# injections.
	for key in $(cfg_keys "etc-inject"); do
		value="$(cfg_value "etc-inject" "${key}")"
		if ! [ -e "${mount}/${key}" ]; then
			continue
		fi
		awk -v"RS=^$" -v"x=$(cat "${value}")" \
			-v"cmd=add_override inject /${key} ${value}" \
			-v"fscfg=${mount}/.bedrock-config-filesystem" '
			index($0, x) == 0 {
				print cmd >> fscfg
				fflush(fscfg)
				close(fscfg)
			}
		' "${mount}/${key}"
	done
}
