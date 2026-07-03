if status is-interactive
    # Commands to run in interactive sessions can go here
end

function ls
    /usr/bin/eza $argv
end

alias ll='eza -lbF --git' # list, size, type, git
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
        nvim -c "vs $header" $file
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

function v
    nvim $argv
end

function ssave
    set help "Usage:" (status function) "\n  Will start the uWu screensaver."
    if contains -- --help $argv; or contains -- -h $argv
        echo -e $help
        return 0
    end
    idle-screensaver 2>1 >/dev/null &
end

fish_add_path $HOME/.cargo/bin

fastfetch
