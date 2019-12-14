#!/bin/sh

# shellcheck source=src/test_source.sh
. some/random/path

case $myvar in *) true; esac 