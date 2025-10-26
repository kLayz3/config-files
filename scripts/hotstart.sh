#/usr/bin/env bash
#
[ $# -lt 1] && { echo "Supply xkb config file name."; exit 1; }
LAYOUT=$1

# Try setting it directly. It will fail if either keymap or symbols file not found.
xkbcomp -I"$HOME/.xkb" "$HOME/.xkb/keymap/$LAYOUT" $DISPLAY 2>/dev/null

if [ $? -ne 0]; then
    # It's OK. Try to rebuild the keymap file
    mkdir -p "$HOME/.xkb/{symbols,keymap}"

    # Layout must exit in symbols subdirectory, if not wget it
    if [ ! -f "$HOME/.xkb/symbols/$LAYOUT" ]; then 
        # TODO
    fi

    # Dump current layout and stash it in ~/.xkb/keymap/$LAYOUT (for now)
    setxkbmap -print > "$HOME/.xkb/keymap/$LAYOUT"

    perl -pe -i "s{^\s*xkb_symbols\s*\{\s*include\s*\"[^\"]+\K(?=\")(?![^\"]*$LAYOUT\($LAYOUT\))}{\+$LAYOUT\($LAYOUT\)}mx" \
        "$HOME/.xkb/keymap/$LAYOUT"
    
    xkbcomp -I"$HOME/.xkb" "$HOME/.xkb/keymap/$LAYOUT" $DISPLAY 2>/dev/null
    
    [ $? -ne 0] 
        && { echo "Cannot set up the layout somehow. Check $HOME/.xkb directories."; exit 1; }
        || { echo "Successfully set-up the layout \'$LAYOUT\'. Enjoy."; }
fi


