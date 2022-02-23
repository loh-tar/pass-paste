#!/bin/bash
#
#  pass-paste: an extension for pass: the standard unix password manager
#
#  Copyright (C) 2022 loh.tar@googlemail.com
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License along
#  with this program; if not, write to the Free Software Foundation, Inc.,
#  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

set -e # exit script on any error

declare -r myVersion="version 0.8 - feb 2022"
declare -r path="$1"
declare -r passFile="${PREFIX}/${path}.gpg"

exitOops() {
    printf "Oops?\n"
    exit 1
}

# Only go on when we have a sane password file,
# let pass handle strange user input
if [[ ! -f "$passFile" ]] ; then
    pass $@
    exit $?
fi

# Take the secret
declare -r theSecret=$(pass "${path}")

printf "Choose the window which need the secret..."

# Run xwininfo to let the user switch back to the window which need the secret
# and wait for some mouse click
declare -r windowId=($(xwininfo -int|grep "xwininfo: Window id:"))
declare -r windowId_id=${windowId[3]}

# Don't "paste" in our terminal, that make no sense
# WINDOWID should be set by the terminal, Thanks to https://stackoverflow.com/a/22251497
[[ ${windowId_id} -eq ${WINDOWID} ]] && exitOops

# Try to avoid more false "paste"
declare -r windowProperty=$(xprop -id "${windowId_id}" |grep _NET_WM_WINDOW_TYPE)
[[ "${windowProperty}" == *"_NET_WM_WINDOW_TYPE_DOCK"* ]] && exitOops
[[ "${windowProperty}" == *"_KDE_NET_WM_WINDOW_TYPE_OVERRIDE"* ]] && exitOops

printf "OK\n"

# Bring the window to front, not needed to work, but isn't that expected?
xdotool windowactivate --sync "${windowId_id}" 2>/dev/null

# printf will always be the bash build in. So when we pipe the secret to xdotool
# the secret will not be revealed in "ps aux". But we illustrate that explicit by
# using "builtin"
# https://unix.stackexchange.com/posts/237923/revisions
declare -r leftButton=1
builtin printf "${theSecret}" | xdotool click --window "${windowId_id}" "${leftButton}" \
                                        type --window "${windowId_id}" --clearmodifiers --file -

