# To debug:
# env DEBUG=1 fish
# env DEBUG=1 fish -d 2

# See also:
# - config_abbr.fish
# - config_depr.fish

# PATH:
# (bash) /bin:/Users/wsh/anaconda/bin -> (fish) /Users/wsh/anaconda/bin bin/
# https://github.com/fish-shell/fish-shell/issues/417
# https://github.com/fish-shell/fish-shell/pull/950
# To avoid this, comment out /usr/local/share/fish/__fish_build_paths.fish:
#   set -xg PATH $__fish_tmp_path

mkdir -p /tmp/wataash/

function _dbg -d 'Prints debugging information on "set -x DEBUG 1; fish"'
    echo "[" (date +'%Y-%m-%dT%H:%M:%S%z')" ]: $argv" >> /tmp/wataash/config.fish.log
    set -q DEBUG; and echo "!!!! $argv" >&2
end

_dbg '--------------------------------------------------'
_dbg 'loading config.fish ...'

# byobu calls config.fish two times.
if not set -q NUM_CALLED_CONFIG_FISH
    set -x NUM_CALLED_CONFIG_FISH 0
else
    _dbg "config.fish is already called $NUM_CALLED_CONFIG_FISH time(s)"
end

# -----------------------------------------------------------------------------
_dbg 'Environments'

# anaconda
type -q conda; and source (dirname (which conda))/../etc/fish/conf.d/conda.fish

# less
# colored man
# https://wiki.archlinux.org/index.php/Color_output_in_console#man
set -Ux LESS_TERMCAP_md (printf "\e[01;31m")
set -Ux LESS_TERMCAP_me (printf "\e[0m")
set -Ux LESS_TERMCAP_se (printf "\e[0m")
set -Ux LESS_TERMCAP_so (printf "\e[01;44;33m")
set -Ux LESS_TERMCAP_ue (printf "\e[0m")
set -Ux LESS_TERMCAP_us (printf "\e[01;32m")

# rbenv
type -q rbenv; and status --is-interactive; and source (rbenv init -|psub)

# powerline-go
# https://github.com/justjanne/powerline-go
# go get -u -v github.com/justjanne/powerline-go
# don't include trailing '/'
set IGNORE_REPOS          \
    ~/src/freebsd/src     \
    ~/src/netbsd/src      \
    ~/src/openbsd/src
set IGNORE_REPOS (string join , $IGNORE_REPOS)
function fish_prompt
    # HACK: $status seems to be changed until execution of powerline-go
    set -l _status $status
    set -l duration
    if set -q cmd_duration
        # newer fish
        set duration (math -s6 "$cmd_duration / 1000")
    else
        set duration (math -s6 "$CMD_DURATION / 1000")
    end
    ~/go/bin/powerline-go \
        -shell bare \
        -colorize-hostname \
        -cwd-max-depth 20 \
        -cwd-max-dir-size 120 \
        -cwd-mode fancy \
        -duration $duration \
        -east-asian-width \
        -error $_status \
        -ignore-repos $IGNORE_REPOS \
        -mode patched \
        -modules venv,user,host,ssh,cwd,perms,git,hg,jobs,exit,root,docker,duration,load,node,shell-var \
        -newline \
        -numeric-exit-codes \
        -path-aliases src=S,tmp=T,work=W \
        -shell-var powerline_go_shell_var \

    return $status
end
set -x powerline_go_shell_var "var"

# -----------------------------------------------------------------------------
_dbg 'etc'

# https://github.com/oh-my-fish/plugin-peco
function fish_user_key_bindings
    # fzf_key_bindings
    bind \cr 'peco_select_history (commandline -b)'
end

# -----------------------------------------------------------------------------
_dbg 'functions'

function mkdircd
    if set -q argv[2]
        echo more than one argument passed: $argv
        exit 1
    end
    mkdir -p $argv; and cd $argv
end

# j was overridden by fasd
source ~/.config/fish/functions/j.fish

# -----------------------------------------------------------------------------
_dbg 'abbrs'

# See `abbr --help`

# time fish -c ''

# directly `abbr`:
# real  0m2.112s
# user  0m1.742s
# sys   0m0.340s

# wrap `if status ...`:
# real  0m0.946s
# user  0m0.707s
# sys   0m0.213s

function source_abbr
    if not status --is-interactive
        _dbg 'non interactive, skip loading abbrs'
        return
    end
    #  newer fish                older fish
    if set -q _fish_abbr_abs; or abbr --show | grep -q 'abbr abs '
        _dbg 'abbrs already loaded, skip loading abbrs'
        return
    end
    _dbg 'source config_abbr.fish'
    # TODO: relative path
    source ~/.config/fish/config_abbr.fish
end
source_abbr

# -----------------------------------------------------------------------------
_dbg 'End'

set -x NUM_CALLED_CONFIG_FISH (math $NUM_CALLED_CONFIG_FISH + 1)
_dbg "end of loading fish.config ($NUM_CALLED_CONFIG_FISH time(s))"

_dbg '--------------------------------------------------'

# -----------------------------------------------------------------------------
# memo
if false  # comment
# using strange behavior of "if", "and", "or"
if false
    or true
    echo foo >&2
end
# => foo
# isn't "or" a command?  Seems to be no. syntax?
# see "or --help"
function count; end
function or; end
# => function: The name 'or' is reserved,
# => and can not be used as a function name
end  # comment
