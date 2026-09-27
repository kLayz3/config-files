#!/usr/bin/env bash

# https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425?permalink_comment_id=3799230
# I like my pipe to be hardened mhmmm
set -euo pipefail

# Keep the extracted xkb/ directory beside this script.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/../xkb"
TARGET_DIR="$HOME/.xkb"
LAYOUT="qwerty_k14y23"

SESSION_TYPE="${XDG_SESSION_TYPE:-}"
DESKTOP="${XDG_CURRENT_DESKTOP:-}"

fail() {
	printf '%s\n' "$*" >&2
	exit 1
}

# Check Wayland *before* DISPLAY: Wayland sessions often also run Xwayland.
if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" || "${DESKTOP,,}" == *hyprland* ]]; then
	BACKEND="hyprland"
	TARGET_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/xkb"
	command -v hyprctl >/dev/null 2>&1 || fail 'Required command not found: hyprctl'
	hyprctl version >/dev/null
elif [[ "${SESSION_TYPE,,}" == wayland || -n "${WAYLAND_DISPLAY:-}" ]]; then
	fail 'This Wayland compositor is not Hyprland. Configure its keyboard settings directly.'
elif [[ -n "${DISPLAY:-}" ]]; then
	BACKEND="x11"
	TARGET_DIR="$HOME/.xkb"
	command -v xkbcomp >/dev/null 2>&1 || fail 'Required command not found: xkbcomp'
else
	fail 'No supported graphical session detected. Run this inside Hyprland or X11.'
fi

if [[ -z "${DISPLAY:-}" ]]; then
	printf 'No DISPLAY set; run this inside your Hyprland/X11 session.\n' >&2
	exit 1
fi

# Check all missing files before installing anything.
for KIND in symbols keymap; do
	if [[ ! -f "$TARGET_DIR/$KIND/$LAYOUT" && ! -f "$SOURCE_DIR/$KIND/$LAYOUT" ]]; then
		fail 'Missing layout file: %s\n' "$SOURCE_DIR/$KIND/$LAYOUT"
	fi
done

for KIND in symbols keymap; do
	if [[ ! -f "$TARGET_DIR/$KIND/$LAYOUT" ]]; then
		mkdir -p -- "$TARGET_DIR/$KIND"
		cp -- "$SOURCE_DIR/$KIND/$LAYOUT" "$TARGET_DIR/$KIND/$LAYOUT"
	fi
done

printf "Loading '%s' through %s ...\n" "$LAYOUT" "$BACKEND"
printf "Target dir: '%s\n" "$TARGET_DIR"

if [[ "$BACKEND" == x11 ]]; then
	exec xkbcomp -w3 -I"$TARGET_DIR" "$TARGET_DIR/keymap/$LAYOUT" "$DISPLAY"
fi

hyprctl keyword input:kb_file ""
hyprctl keyword input:kb_file "$TARGET_DIR/keymap/$LAYOUT"
hyprctl switchxkblayout all 0
