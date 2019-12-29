#!/bin/sh
# Copyright 2019 Jacob Hrbek <kreyren@rixotstudio.cz>
# Distributed under the terms of the GNU General Public License v3 (https://www.gnu.org/licenses/gpl-3.0.en.html) or later

# This file defines a color scheme for the terminal output

# shellcheck source=src/slash-bedrock/lib/shell/common-code.sh
. /bedrock/lib/shell/common-code.sh

# FIXME: Improve handling of color
if [ -t 1 ] || [ "$(cfg_value "miscellaneous" "color")" != "true" ]; then
	fixme "Export terminfo to use \$(tput setaf a) for colors"
	export color_alert='\033[0;91m'             # light red
	export color_priority='\033[1;37m\033[101m' # white on red
	export color_warn='\033[0;93m'              # bright yellow
	export color_okay='\033[0;32m'              # green
	export color_strat='\033[0;36m'             # cyan
	export color_disabled_strat='\033[0;34m'    # bold blue
	export color_alias='\033[0;93m'             # bright yellow
	export color_sub='\033[0;93m'               # bright yellow
	export color_file='\033[0;32m'              # green
	export color_cmd='\033[0;32m'               # green
	export color_rcmd='\033[0;31m'              # red
	export color_distro='\033[0;93m'            # yellow
	export color_bedrock="$color_distro"       # same as other distros
	export color_logo='\033[1;37m'              # bold white
	export color_glue='\033[1;37m'              # bold white
	export color_link='\033[0;94m'              # bright blue
	export color_term='\033[0;35m'              # magenta
	export color_misc='\033[0;32m'              # green
	# QA: What considers normal? What about themes?
	export color_norm='\033[0m'
elif [ ! -t 1 ]; then
	# unset all colors if terminal doesn't support them
	## QA: Needed? Or will terminal without colors show the syntax?
	unset color_alert color_warn color_okay color_strat color_disabled_strat color_alias color_sub color_file color_cmd color_rcmd color_distro color_bedrock color_logo color_glue color_link color_term color_misc color_norm
else
	die 255 "common-code, color"
fi
