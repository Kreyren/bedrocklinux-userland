#!/bin/sh
# Copyright 2019 Jacob Hrbek <kreyren@rixotstudio.cz>
# Distributed under the terms of the GNU General Public License v3 (https://www.gnu.org/licenses/gpl-3.0.en.html) or later

# This file is used to customize your fork

# TODO: Export die here

# Set error messages to proper upstream
export MAINTAINER="" # Set this to override logic under

if [ -z "$MAINTAINER" ]; then
	# TODO: Define this based on output from git? -> Set the values based on real name of the repository
	fixme "Get owner of git repository"

	# get_owner="$(git remote -v | grep 'origin' -n1 )"
	#
	# case ${get_owner##origin } in
	# 	git@github.com*)
	# 		case ${get_owner##git@github.com:} in
	# 			"*/*.git (fetch)")
	# 			${get_owner%%.git (fetch)}
	# 			;;
	# 			"*/*.git (push)")
	# 			;;
	# 		esac
	# 		${get_owner%%.git (fetch)}
	# 	;;
	# 	git@gitlab.com*)
	# esac
	#
	# # Use awk instead..
	# awk ...
elif [ -n "$MAINTAINER" ]; then
	true
else
	die 255 "Defining MAINTAINER variable"
fi

# Set fork/main name across whole project
export DISTRIBTION="(WIP name)"
