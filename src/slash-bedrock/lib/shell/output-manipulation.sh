#!/bin/sh
# Copyright 2019 Jacob Hrbek <kreyren@rixotstudio.cz>
# Distributed under the terms of the GNU General Public License v3 (https://www.gnu.org/licenses/gpl-3.0.en.html) or later

# This file allows various output manipulation

# shellcheck source=src/slash-bedrock/lib/shell/common-code.sh
. /bedrock/lib/shell/common-code.sh

# Output manipulation (exported from https://github.com/RXT067/Scripts/blob/kreyren/kreypi/kreypi.bash)
# QA: Fix duplicates
einfo() { # Used to output a normal message
	message="$1"
	syntax_err="$2"

	if [ -n "$message" ]; then
		shift 1
		syntax_err="$1"
		[ -n "$syntax_err" ] && die 2 "Function einfo only accepts one argument but two were parsed: $syntax_err"
	elif [ -z "$message" ]; then
		die 2 "Function warn expects one argument at least, stray warn used?"
	fi

	printf "${color_norm}INFO: %s$color_norm\\n" "$message" 1>&2

	unset message
}

fixme() { # Used to output fixme message
	function="$1"
	message="$2"
	syntax_err="$3"

	# QA: Missleading with function variable
	if [ -n "$function" ] && [ -n "$message" ]; then
		shift 2

		syntax_err="$1"
		[ -n "$syntax_err" ] && die 2 "Function fixme expects either one or two arguments, but three were parsed: $syntax_err"

		fixme "Allow disabling fixme messages using bedrock.conf"
		# shellcheck disable=SC2154
		[ -z "$kreyrock_ignore_fixme" ] && printf "${color_norm}FIXME: %s$color_norm\\n" "Function $function $message" 1>&2
	elif [ -n "$function" ] && [ -z "$message" ]; then
		shift 1

		# shellcheck disable=SC2154
		[ -z "$kreyrock_ignore_fixme" ] && printf "${color_norm}FIXME: %s$color_norm\\n" "$function" 1>&2
	fi

	unset message function
}

warn() { # Used to output a warning message
	message="$1"
	syntax_err="$2"

	if [ -n "$message" ]; then
		shift 1
		syntax_err="$1"
		[ -n "$syntax_err" ] && die 2 "Function warn only accepts one argument but two were parsed: $syntax_err"
	elif [ -z "$message" ]; then
		die 2 "Function warn expects one argument at least, stray warn used?"
	fi

	printf "${color_warn}WARN: %s$color_norm\\n" "$message" 1>&2

	unset message
}

err() { # Used to output an error message
	message="$1"
	syntax_err="$2"

	if [ -n "$message" ]; then
		shift 1
		syntax_err="$1"
		[ -n "$syntax_err" ] && die 2 "Function error only accepts one argument but two were parsed: $syntax_err"
	elif [ -z "$message" ]; then
		die 2 "Function warn expects one argument at least, stray warn used?"
	fi

	printf "${color_alert}WARN: %s$color_norm\\n" "$message" 1>&2

	unset message
}

debug() { # Used for debug messages
	message="$1"
	syntax_err="$2"

	if [ -n "$message" ]; then
		shift 1
		syntax_err="$1"
		[ -n "$syntax_err" ] && die 2 "Function debug only accepts one argument but two were parsed: $syntax_err"
	elif [ -z "$message" ]; then
		die 2 "Function warn expects one argument at least, stray warn used?"
	fi

	# shellcheck disable=SC2154
	[ -n "$debug" ] && printf "${color_norm}DEBUG: %s$color_norm\\n" "$message" 1>&2

	unset message
}

# SYNOPSIS: $0 [error_code [num:0~255|ping|fixme|wtf]] (message)
# http://tldp.org/LDP/abs/html/exitcodes.html#EXITCODESREF
die() { # Used to exit a program with a message
	err_code="$1"
	message="$2"
	syntax_err="$3"

	fixme die "investigate"
	# if [ -n "$err_code" ] && [ -n "$message" ]; then
	# 	shift 2
	# 	syntax_err="$1"
	# 	[ -n "$syntax_err" ] && printf "${color_alert}FATAL: %s$color_norm\\n" "die expects either one or two arguments, but third were parsed: $syntax_err, syntax error?" ; exit 2
	# elif [ -n "$err_code" ] && [ -z "$message" ]; then
	# 	shift 1
	# 	syntax_err="$1"
	# 	[ -n "$syntax_err" ] && printf "${color_alert}FATAL: %s$color_norm\\n" "die expects either one or two arguments, but third were parsed: $syntax_err, syntax error?" ; exit 2
	# else
	# 	printf "${color_alert}FATAL: %s$color_norm\\n" "Unexpected output happend at the shifting of die function" ; exit 255
	# fi

	case "$err_code" in
		0|true)	debug "Script returned true" ; return 0 ;;
		1|false) # False
			if [ -n "$message" ]; then
				printf "${color_alert}FATAL: %s$color_norm\\n" "$message" 1>&2
				exit 1
			elif [ -z "$message" ]; then
				# QA: Is this safe to ignore using variables in printf format?
				# shellcheck disable=SC2059
				printf "${color_alert}FATAL: %s$color_norm\\n" "Script returned false" 1>&2 ; exit 1
			else
				die 255 "die 1"
			fi
		;;
		2) # Syntax err
			if [ -n "$message" ]; then
				trap '' EXIT
				printf "${color_alert}FATAL: %s$color_norm\\n" "$message" 1>&2
				exit 2
			elif [ -z "$message" ]; then
				trap '' EXIT
				printf "${color_alert}FATAL: %s$color_norm\\n" "Syntax error $([ -n "$debug" ] && printf '%s\n' "$0 $err_code $message $3")" 1>&2
				exit 2
			else
				die 255 "die 2"
			fi
		;;
		3) # Permission issue
			if [ -n "$message" ]; then
				trap '' EXIT
				printf "${color_alert}FATAL: %s$color_norm\\n" "$message" 1>&2
				exit 3
			elif [ -z "$message" ]; then
				trap '' EXIT
				printf "${color_alert}FATAL: %s$color_norm\\n" "Unable to elevate root access $([ -n "$(id -u)" ] && printf '%s\n' "from EUID ($(id -u))")" 1>&2
				exit 3
			else
				die 255 "die 3"
			fi
		;;
		126) # Not executable
			trap '' EXIT
			die 126 "FIXME(die): Not executable"
		;;
		130) # Killed by user (used for development)
			trap '' EXIT
			die 130 "Killed by user"
		;;
		# Custom
    wtf|255)
			trap '' EXIT
			printf "${color_alert}FATAL: %s$color_norm\\n" "Unexpected result in '$message'"
			exit 255
		;;
    ping)
			printf "${color_alert}FATAL: %s$color_norm\\n" "Killed by ping"
			exit 1
		;;
		fetch_abort) # Originally 'fetch_abort()'
			trap '' EXIT
			err "$message"

			# shellcheck disable=SC2154
			[ -z "$target_dir" ] && warn "Variable 'target_dir' is not assigned in 'die fetch_abort'"

			sanitize_func

			fixme "Sanitize fetch abort to avoid removing mounts or non-existing dirs"
			if cfg_values "miscellaneous" "debug" | grep -q "brl-fetch"; then
				einfo "Skipping cleaning up $target_dir due to kreyrock.conf debug setting"
			elif [ -n "${target_dir:-}" ] && [ -d "$target_dir" ]; then
				if ! less_lethal_rm_rf "${target_dir}"; then
					err "Unable to clean up $target_dir, you will have to clean up yourself"
					printf '%s\n' \
						"!!! WARNING !!!" \
						"!!! WARNING !!!" \
						"Using 'rm' around mount points may result in accidentally deleting something you wish to keep. Consider rebooting to remove mount points and kill errant processes first or check 'mount' for possible conflicts" \
						"!!! WARNING !!!" \
						"!!! WARNING !!!"
				fi
			else
				die 255 "Fetch abort, cleanup"
			fi

			exit 1
		;;
		*)
			trap '' EXIT
			printf "${color_alert}FATAL: %s$color_norm\\n" "$err_code" 1>&2
			exit 1
	esac

	unset err_code message
}
