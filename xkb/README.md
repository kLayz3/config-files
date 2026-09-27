Send the `symbols/` file to: `$HOME/.xkb/symbols`.
Send the `keymap/` file to: `$HOME/.xkb/keymap`.


Execute:
``
xkbcomp -w3 -I"$HOME/.xkb" "$HOME/.xkb/keymap/qwerty_k14y23" "$DISPLAY"
``

This will prompt some warnings, which can be ignored.

To return back:
``
setxkbmap us
``

NOTE: the `../scripts/hotstart.sh` is prepared, but could be brittle with
following hyprland releases...
