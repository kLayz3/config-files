if status is-interactive
    # Commands to run in interactive sessions can go here
end

function ls
    /usr/bin/eza $argv
end

alias ll='eza -lb -snew --git' # list, size, type, git
alias llm='eza -lbGd --git --sort=modified' # long list, modified date sort
alias la='eza -lbhHigUmuSa --time-style=long-iso --git --color-scale' # all list
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale' # all + extended list
alias lS='eza -1' # one column, just names
alias lt='eza --tree --level=2' # tree

function nvhs
    set file $argv[1]
    set help "Usage:" (status function) "*.cxx|cpp"
    if string match -qr '.+\.(cxx|cpp)' -- $file
        set base (string replace -r '\.(cxx|cpp)$' '' -- $file)
        set header ''
        if test -f "$base.h"
            set header "$base.h"
        else if test -f "$base.hpp"
            set header "$base.hpp"
        else if test -f "$base.hh"
            set header "$base.hh"
        else
            echo "Header file not found"
            echo $help
            return -1
        end
        nvim -c "vs $file" $header
    else
        echo $help
        return 2
    end
    return 0
end

function go4vim
    set file $argv[1]
    set help "Usage:" (status function) "*.Proc|Event.cxx"
    if string match -qr '.+\.(cxx|cpp)' -- $file
        set base (string replace -r '\.(cxx|cpp)$' '' -- $file)
        set header "$base.h"
        set str ''
        if string match -qr '.+Proc' -- $Commandse
            set str (string replace -r 'Proc$' '' $base)Event
            if string match -qr '.+Event' -- $Commandse
                set str (string replace -r 'Event$' '' $base)Proc
            else
                echo "Unknown base, not ending with Proc or Event"
                echo $help
                return -1
            end
            nvim -c "vs $header" -c "tabnew $str.cxx" -c "vs $str.h" -c "tabn 1" $file
        else
            echo $help
            return 2
        end
        return 0
    end
end

function kvim
    set file $argv[1]
    set help "Usage:" (status function) "*Proc|Cont.cxx"
    if string match -qr '.+\.(cxx|cpp)' -- $file
        set base (string replace -r '\.(cxx|cpp)$' '' $file)
        set header "$base.h"
        set str ''
        if string match -qr '.+Proc' -- $base
            set str (string replace -r 'Proc$' '' $base)Event
        else if string match -qr '.+Cont' -- $base
            set str (string replace -r 'Cont$' '' $base)Proc
        else
            echo "Unknown base, not ending with Proc or Cont: $base"
            echo $help
            return 1
        end
        nvim -c "vs $file" -c "tabnew $str.h" -c "vs $str.cxx" -c "tabn 1" $header
    else
        echo $help
    end
    return 0
end

function v
    nvim $argv
end

function run
    printf '%s\n' (string join ' ' -- (string escape -- $argv)) >> log.txt
    $argv
end

function nvim2
    if test (count $argv) -lt 2
        echo "Usage:" (status function) "file1 file2"
        return 1
    else
        nvim -c "vs $argv[2]" $argv[1]
    end
end

function run
    printf '%s\n' (string join ' ' -- (string escape -- $argv)) >>log.txt
    $argv
end

function z
    if test (count $argv) -lt 1
        echo "Usage:" (status function) "file. Opens the file in zathura detach mode."
        return 1
    else
        zathura $argv[1]&; disown
    end
end

fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/opt/bin

set -x GIT_PAGER
set -x UCESB_DIR $HOME/daq-playground/ucesb
set -x UCESB_BASE_DIR "$UCESB_DIR"
set --global fish_greeting
set -x LISE_PATH $HOME/lise/lise-app
set -x DOCU $HOME/daq-playground/docu

set -gx AN "$HOME/phd/analysis"
set -gx RSCRIPTPATH "$AN/scripts"

alias empty="$UCESB_DIR/empty/empty"
alias lise="$LISE_PATH/LISE++"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias vim="nvim"
alias r="root -l --web=off"

function canvas
	if test (count $argv) -lt 2
		echo "Usage:" (status function) "NUM|LOCATION file"
		echo "  Will extract the canvas with number NUM (or location LOC)."
		echo "  Loc: lu|ld|ru|rd ; l=left, r=right, u=up, d=down"
		echo "  Is :  1| 3| 2| 4"
		return 1
	end

	set -l pad "$argv[1]"
	switch "$pad"
		case lu
			set pad 1
		case ru
			set pad 2
		case ld
			set pad 3
		case rd
			set pad 4
	end
	
	# Escape the filename for the C++ string literal.
	set -l file (string replace -a -- '\\' '\\\\' "$argv[2]")
	set file (string replace -a -- '"' '\\"' "$file")

	command root -l --web=off \
		"$RSCRIPTPATH/extract_pad.C($pad, \"$file\")"
end

fastfetch
