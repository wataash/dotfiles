# https://scrapbox.io/wataash/fish

# Requirements:
# go get -u -v github.com/justjanne/powerline-go

# ------------------------------------------------------------------------------
# logging

# from ~/.bashconf.sh

# all functions must call debug first:
#     function fn
#         debug
#         ...
#     end
function err   ;        ; _err   $argv | tee -a /tmp/wataash/config.fish.log >&2 ; end
function warn  ;        ; _warn  $argv | tee -a /tmp/wataash/config.fish.log >&2 ; end
function info  ; return ; _info  $argv | tee -a /tmp/wataash/config.fish.log >&2 ; end
function debug ; return ; _debug $argv | tee -a /tmp/wataash/config.fish.log >&2 ; end

function _err   ; tput setaf 1 ; _log $argv ; tput sgr0 ; end
function _warn  ; tput setaf 3 ; _log $argv ; tput sgr0 ; end
function _info  ; tput setaf 4 ; _log $argv ; tput sgr0 ; end
function _debug ; tput setaf 7 ; _log $argv ; tput sgr0 ; end

# https://google.github.io/styleguide/shell.xml?showone=STDOUT_vs_STDERR#STDOUT_vs_STDERR
function _log
    # breakpoint

    # get caller's func name and line number

    # status print-stack-trace
    # in function “_log”
    #     called on line 48 of file ~/.config/fish/config.fish
    #     with parameter list “aaa”
    #
    # in function “_warn”
    #     called on line 38 of file ~/.config/fish/config.fish
    #     with parameter list “aaa”
    #
    # in function “warn”
    #     called on line 169 of file ~/.config/fish/config.fish
    #     with parameter list “aaa”
    #
    # in function “fn”
    #     called on line 88 of file ~/.config/fish/config.fish
    #
    # from sourcing file ~/.config/fish/config.fish
    #     called during startup

    #     in function "fn”
    # from sourcing file ~/.config/fish/config.fish
    set -l funcname (status print-stack-trace | grep -E 'in function|from sourcing file' | head -4 | tail -1)
    # echo trace: $funcname

    # "fn”
    # ~/.config/fish/config.fish
    set -l funcname (echo $funcname | string trim --left --chars 'in function' | string trim --left --chars 'from sourcing file')
    # echo trace: $funcname

    # "fn”
    # config.fish
    set -l funcname (echo $funcname | string split '/' | tail -1)
    # echo trace: $funcname

    # can't trim `"` with trim `string trim` or `string replace` ...

    #     called on line 169 of file ~/.config/fish/config.fish
    set -l linenum (status print-stack-trace | grep -E 'called on line' | head -4 | tail -1)
    # echo trace: $linenum

    # called on line 169 of file ~/.config/fish/config.fish
    set -l linenum (echo $linenum | string trim --left)
    # echo trace: $linenum

    # BUG?
    # string trim --left --chars 'called on'
    # -> ine ...

    # 169 of file ~/.config/fish/config.fish
    set -l linenum (echo $linenum | string trim --left --chars 'called on line')
    # echo trace: $linenum

    # 169
    set -l linenum (echo $linenum | string split ' ' | head -1)
    # echo trace: $linenum

    # print it

    # from ~/.bashconf.sh
    echo -n (date +'%Y-%m-%d %H:%M:%S')
    printf ' %20s %3d  ' "$funcname" "$linenum"
    echo "  $argv"
end

# ------------------------------------------------------------------------------
# events

function notify_done_long_command --description 'notify_done_long_command' --on-event fish_prompt
    set -l cmd_duration_saved $CMD_DURATION
    set -l histroy1_saved $history[1]
    set -l status_saved $status

    # 10 seconds
    if test "$cmd_duration_saved" -lt 10000
        return
    end

    set -l interactive_commands (string join '|' \
        '#' (: only comment doesnt update CMD_DURATION) \
        'ash' \
        'bash' \
        'emacs' \
        'emacsclient' \
        'fish' \
        'git diff' \
        'git icdiff' \
        'git log' \
        'git rebase' \
        'git show' \
        'less' \
        'man' \
        'sh' \
        'tig' \
        'vim' \
        'zsh' \
    )

    if string match --quiet --regex "^($interactive_commands).*\$" "$histroy1_saved"
        return
    end

    wataash_notify done "("(tty)" $status_saved $cmd_duration_saved ms)" $histroy1_saved
end

# ------------------------------------------------------------------------------
# bindings

# https://github.com/fish-shell/fish-shell/issues/1963
function bind_global_alias
    switch (commandline -t)
        case "a"
            commandline -rt '| ag'
        case "d"
            commandline -rt '> /dev/null'
        case "l"
            commandline -rt '| less'
        case "h"
            commandline -rt '| head'
        case "t"
            commandline -rt '| tail'
        case "g"
            commandline -rt '| grep'
        case "w"
            commandline -rt '| wc'
        case "wl"
            commandline -rt '| wc -l'
        case "x"
            commandline -rt '| xargs'
        case "xl"
            commandline -rt '| xargs -L1'
        case "cc"
            commandline -rt '| ccze -A'
    end
end

bind \cx bind_global_alias

# https://github.com/oh-my-fish/plugin-peco
function fish_user_key_bindings
    # fzf_key_bindings
    bind \cr 'peco_select_history (commandline -b)'
end

# ------------------------------------------------------------------------------
# functions

function mkdircd
    if set -q argv[2]
        echo more than one argument passed: $argv
        exit 1
    end
    mkdir -p $argv; and cd $argv
end

# ------------------------------------------------------------------------------
# main

# do in ~/.bashconf.sh as possible
function wataash_setenv
    debug

    # anaconda
    type -q conda; and source (dirname (which conda))/../etc/fish/conf.d/conda.fish

    # less
    # colored man
    # https://wiki.archlinux.org/index.php/Color_output_in_console#man
    # TODO: move to bashconf.sh
    set -Ux LESS_TERMCAP_md (printf "\e[01;31m")
    set -Ux LESS_TERMCAP_me (printf "\e[0m")
    set -Ux LESS_TERMCAP_se (printf "\e[0m")
    set -Ux LESS_TERMCAP_so (printf "\e[01;44;33m")
    set -Ux LESS_TERMCAP_ue (printf "\e[0m")
    set -Ux LESS_TERMCAP_us (printf "\e[01;32m")

    # rbenv
    type -q rbenv; and status --is-interactive; and source (rbenv init - | psub)
end

# See `abbr --help`
#
# time fish -c ''
#
# directly `abbr`:
# real  0m2.112s
# user  0m1.742s
# sys   0m0.340s
#
# wrap `if status ...`:
# real  0m0.946s
# user  0m0.707s
# sys   0m0.213s
function wataash_source_abbr
    debug

    if not status --is-interactive
        info 'non interactive, skip loading abbrs'
        return
    end

    #  newer fish                older fish
    if set -q _fish_abbr_abs; or abbr --show | grep -q 'abbr abs '
        debug 'abbrs already loaded, skip loading abbrs'
        return
    end

    info 'source config_abbr.fish'
    # TODO: relative path
    source ~/.config/fish/config_abbr.fish
end

function wataash_main
    mkdir -p /tmp/wataash/
    debug
    info 'loading config.fish ...'

    # byobu calls config.fish two times?
    if not set -q NUM_CALLED_CONFIG_FISH
        set -x NUM_CALLED_CONFIG_FISH 0
    else
        warn "config.fish is already called $NUM_CALLED_CONFIG_FISH time(s)"
    end

    wataash_setenv
    wataash_source_abbr

    # suppress welcome
    # https://stackoverflow.com/a/13995944/4085441
    set fish_greeting
end

wataash_main

set -x NUM_CALLED_CONFIG_FISH (math $NUM_CALLED_CONFIG_FISH + 1)
debug "end of loading fish.config ($NUM_CALLED_CONFIG_FISH time(s))"
