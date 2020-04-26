#!/usr/bin/env bash

set -Ceu

# @template:source
# https://stackoverflow.com/a/34208365/4085441
DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null || echo "$0")")
# shellcheck source=utils.bash
source "$DIR/utils.bash"

# ------------------------------------------------------------------------------

IMGMAP=~/doc/md/0imgmap.txt

sedcmds=()

mapfile -t lines < $IMGMAP
for line in "${lines[@]}"; do
  # log_debug line: "$line"
  file=${line%% *}
  url=${line##* }
  # log_debug file "$file"
  # log_debug url "$url"
  sedcmds+=("-e s!$file!$url!")
  # log_debug "${sedcmds[@]}"
done

sedcmds+=("-e s@<!-- include:0license.md -->@$(cat ~/doc/md/0license.md)@")
sedcmds+=("-e s@<!-- include:0license_ja.md -->@$(cat ~/doc/md/0license_ja.md)@")

log_debug sed -E "${sedcmds[@]}"
sed -E "${sedcmds[@]}"
