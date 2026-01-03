Send the `symbols/` file to: `$HOME/.xkb/symbols`.
Send the `keymap/` file to: `$HOME/.xkb/keymap`.


Execute:
``
xkbcomp -w0 -I"$HOME/.xkb" "$HOME/.xkb/keymap/colemak_k14y23" "$DISPLAY"
``

This will prompt some warnings, which can be ignored.

To return back:
``
setxkbmap us
``

Must have `us(colemak-dh)` base layout installed.
