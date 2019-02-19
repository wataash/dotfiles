#!/bin/bash
#
# TODO: move to tessh
#
# TODO: shellcheck
#
# -----------------------------------------------------------------------------
# My bash configurations.
#
# Source me from .bash_profile:
#   source ~/.bashconf.sh
# If ~/.bash_profile doesn't exist, source me from ~/.bashrc.
#
# -----------------------------------------------------------------------------
# Environment variables (inputs)
#
# - BASHCONF_LOG_OUT   If 1, output log to stdout.
#                      Example:
#                        env BASHCONF_LOUG_OUT=1 bash
# - BASHCONF_LOG_ERR   If 1, output log to stderr.
# - BASHCONF_NO_ALL    If 1, this script does nothing.
#                      Example:
#                        env DONT_SOURCE_BASHCONF_SH=1 gnome-terminal
# - BASHCONF_NO_ENV    If 1, doesn't set environment variables.
# - BASHCONF_NO_FISH   If 1, doesn't run fish.
#
# Environment variables (outputs)
#
# - BASHCONF_SOURCED   If this script sets environment variables, export it as
#                      1.
# -----------------------------------------------------------------------------
# Login- vs Non-Login- shells
#
#               macOS  Ubuntu(Unity)
# New terminal  login  non-login
# ssh           TODO   login
# emacs         TODO   TODO
# -----------------------------------------------------------------------------
# Coding style
#
# Follows Google's Shell Style Guide.
# https://google.github.io/styleguide/shell.xml
# -----------------------------------------------------------------------------
# Misc
#
# - If you want to run bash in clean environment, just remove
#   `source ~/.bashconf.sh`.
# - If ~/.bash_profile doesn't exist, both login- and non-login- shell reads
#   ~/.bashrc.
# -----------------------------------------------------------------------------

#######################################
# https://google.github.io/styleguide/shell.xml?showone=STDOUT_vs_STDERR#STDOUT_vs_STDERR
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
wataash::conf::err() {
  # TODO: debug level
  echo "$[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

#######################################
# All the functions must call me at first:
#
#   wataash::conf::func() {
#     wataash::conf::log("Short description of this function.")
#     x=1
#     ...
#   }
#
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
wataash::conf::log() {
  mkdir -p /tmp/wataash/
  log_date="[$(date +'%Y-%m-%d %H:%M:%S')]"
  log_caller="$(printf '%3s %-30s%.1s' $(caller 0)) $@"
  echo "$log_date $log_caller" >> /tmp/wataash/bashconf.log

  if [ "$BASHCONF_LOG_OUT" = 1 ]; then
    echo "$log_date $log_caller" 
  fi
  if [ "$BASHCONF_LOG_ERR" = 1 ]; then
    echo "$log_date $log_caller" >&2
  fi

  # echo "  caller 0: $(caller 0)"                >> /tmp/wataash/bashconf.log
  # echo "  caller 1: $(caller 1)"                >> /tmp/wataash/bashconf.log
  # echo "  caller 2: $(caller 2)"                >> /tmp/wataash/bashconf.log
  # echo "  caller 3: $(caller 3)"                >> /tmp/wataash/bashconf.log
}

wataash::conf::should_source() {
  wataash::conf::log "Determine whether this script should be sourced or not."

  if [ -n "$BASHCONF_SOURCED" ]; then
    wataash::conf::log "~/.bashconf.sh is already sourced.  Return 0."
    return 0
  fi

  if [ $0 = "/etc/gdm3/Xsession" ]; then
    wataash::conf::log '$0 = /etc/gdm3/Xsession, Ubuntu Unity (Xorg) login?'
    wataash::conf::log 'Return 0.'
    return 0
  fi

  return 1

  # TODO: cleanup

  # uname_s=$(uname -s)
  # wataash::conf::log "\$uname_s: $uname_s"

  # # https://unix.stackexchange.com/a/26782/231543
  # if ! shopt -q login_shell; then
  #   wataash::conf::log "It's a non-login shell."
  #   if [ $0 = "/etc/gdm3/Xsession" ]; then
  #     wataash::conf::log '$0 = /etc/gdm3/Xsession, '
  #     wataash::conf::log 'New linux Xorg session?  Return 0.'
  #     return 0
  #   fi
  #   wataash::conf::log 'bash on Linux Terminal enulator?  Return 1.'
  #   return 1
  # fi

  # Login shell

  # if [ $uname_s = "Darwin" ]; then
  #   wataash::conf::log "I'm darwin, it seems to be a new terminal. continue."
  #   return 1
  # fi

  # if [ -n "$SSH_TTY" ]; then
  #   wataash::conf::log "It's a SSH session, continue."
  #   return 1
  # fi

  # wataash::conf::log "It's a login shell, not an SSH sesssion, and not darwin."
  # wataash::conf::log "New linux console or Wayland session? should not continue."
  # return 0
}

wataash::conf::should_set_env() {
  wataash::conf::log "Determine whether environment should be set or not."

  if [ "$BASHCONF_NO_ENV" = 1 ]; then
    wataash::conf::log "\$BASHCONF_NO_ENV is 1, return 0."
    return 0
  fi

  return 1
}

wataash::conf::set_env_path() {
  wataash::conf::log "Set PATH."

  wataash::conf::log "Initial \$PATH: $PATH"
  wataash::conf::log "Initial \$MANPATH: $MANPATH"
  wataash::conf::log "Initial \$INFOPATH: $INFOPATH"
  wataash::conf::log "Initial \$(manpath): $(manpath)"

  # ~/.local/bin/ for binaries installed by pip
  p_dot_local=$HOME/.local/bin
  m_dot_local=$HOME/.local/share/man
  i_dot_local=""

  # conda
  p_conda=""
  m_conda=""
  i_conda=""
  if [ -d ~/anaconda/ ]; then
    p_conda=$HOME/anaconda/bin
    m_conda=$HOME/anaconda/share/man
  elif [ -d ~/miniconda3/ ]; then
    p_conda=$HOME/miniconda3/bin
    m_conda=$HOME/miniconda3/share/man
  fi

  # go
  export GOPATH=$HOME/go
  p_go=$GOPATH/bin
  m_go=""
  i_go=""

  # Home
  p_h=$HOME/usr/bin:$HOME/usr/sbin
  m_h=$HOME/usr/share/man
  i_h=$HOME/usr/share/info

  p_opt=$(       ls -d ~/usr/opt/*/sbin       | tr '\n' :)
  p_opt=$p_opt:$(ls -d ~/usr/opt/*/bin        | tr '\n' :)
  m_opt=$m_opt:$(ls -d ~/usr/opt/*/share/man  | tr '\n' :)
  i_opt=$i_opt:$(ls -d ~/usr/opt/*/share/info | tr '\n' :)

  # node
  # https://docs.npmjs.com/getting-started/fixing-npm-permissions
  # ~/.npmrc
  p_npm=$HOME/.npm-global/bin
  m_npm=""
  i_npm=""

  # os specific
  if [ $(uname -s) = Darwin ]; then
    # p_os=/usr/local/opt/coreutils/libexec/gnubin:'/Applications/Sublime Text.app/Contents/SharedSupport/bin'
    # don't have to add MANPATHs in $(manpath), such as:
    # /Applications/Xcode.app/Contents/Developer/usr/share/man
    # they will be added to $(manpath).
    # m_os=/usr/local/opt/coreutils/libexec/gnuman
    i_os=/usr/local/Cellar/make/4.2.1/share/info
  fi
  case "$(uname -v)" in
    *Ubuntu*) m_os=$(manpath) ;;
  esac

  # ruby
  p_rb=""
  m_rb=""
  i_rb=""
  [ -d ~/.rbenv/bin ] && p_rb=$HOME/.rbenv/bin:$HOME/.rbenv/shims

  export PATH_INIT____=$PATH
  export MANPATH_INIT_=$MANPATH
  export INFOPATH_INIT=$INFOPATH
      PATH="$p_go:$p_rb:$p_npm:$p_h:$p_os:$PATH_INIT____:$p_opt:$p_conda:$p_dot_local"
   MANPATH="$m_go:$m_rb:$m_npm:$m_h:$m_os:$MANPATH_INIT_:$m_opt:$m_conda:$m_dot_local"
  INFOPATH="$i_go:$i_rb:$i_npm:$i_h:$i_os:$INFOPATH_INIT:$i_opt:$i_conda:$i_dot_local"

  wataash::conf::log "\$PATH: $PATH"
  wataash::conf::log "\$MANPATH: $MANPATH"
  wataash::conf::log "\$INFOPATH: $INFOPATH"
  wataash::conf::log "\$(manpath): $(manpath)"

  # empty PATH (i.e. /bin::/sbin) seems to be equivalent to "."" (i.e. /bin:.:/sbin)
      PATH=$(echo     $PATH | sed -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/^:// -e s/:$//)
   MANPATH=$(echo  $MANPATH | sed -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/^:// -e s/:$//)
  INFOPATH=$(echo $INFOPATH | sed -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/^:// -e s/:$//)

  wataash::conf::log "\$PATH (after sed): $PATH"
  wataash::conf::log "\$MANPATH (after sed): $MANPATH"
  wataash::conf::log "\$INFOPATH (after sed): $INFOPATH"

  export PATH MANPATH INFOPATH
}

wataash::conf::set_env() {
  wataash::conf::log "Set environment variables."

  wataash::conf::should_set_env
  if [ $? -eq 0 ]; then
    wataash::conf::log "should_set_env() returned 0.  Return."
    return
  fi

  wataash::conf::set_env_path

  # fzf
  export FZF_DEFAULT_OPTS=--multi

  # go
  # export GOENV_ROOT=$HOME/.goenv
  # export GOPATH=$HOME/go  # must be before setting PATH

  # keychain
  eval $(keychain -q --eval --inherit any)
  ssh-add
  # confirm:
  #  ssh-add -l
  #  ssh -A some-host 'ssh-add -l'

  # less
  # https://wiki.archlinux.org/index.php/Color_output_in_console#man
  # doesn't work.
  # export LESS_TERMCAP_md "$(printf \e[01;31m)"
  # export LESS_TERMCAP_me "$(printf \e[0m)"
  # export LESS_TERMCAP_se "$(printf \e[0m)"
  # export LESS_TERMCAP_so "$(printf \e[01;44;33m)"
  # export LESS_TERMCAP_ue "$(printf \e[0m)"
  # export LESS_TERMCAP_us "$(printf \e[01;32m)"

  # z
  # https://github.com/oh-my-fish/plugin-z
  export Z_SCRIPT_PATH=$HOME/usr/bin/z.sh
  if [ $(uname -s) = Darwin ]; then
    export Z_SCRIPT_PATH=$(brew --prefix)/etc/profile.d/z.sh
  fi

  wataash::conf::log "Return."
}

wataash::conf::is_interactive() {
  wataash::conf::log "Determine whether this bash is interactive or not."

  # bash(1) - INVOCATION
  # https://www.gnu.org/software/bash/manual/html_node/Is-this-Shell-Interactive_003f.html
  if [ -n "$PS1" ]; then
    wataash::conf::log "PS1 is set, interactive mode.  Return 1."
    return 1
  fi

  if [[ SHELLOPTS == *emacs* ]]; then
    # found by print `env` and `set`.
    wataash::conf::log "SHELLOPTS includes \"emacs\".  emacs on Ubuntu."
    wataash::conf::log "Return 0."
    return 0
  fi

  if [[ $XPC_SERVICE_NAME == org.gnu.Emacs.* ]]; then
    # on Darwin emacs
    wataash::conf::log "XPC_SERVICE_NAME starts with \"org.gnu.Emacs.\"."
    # 0?
    wataash::conf::log "emacs on macOS.  Return 0."
    return 0
  fi

  if [[ $TERM == dumb ]]; then
    # TODO what it difference with above? GUI and -nw ?
    # 0?
    wataash::conf::log "TERM is \"dump\".  emacs on macOS.  Return 0."
    return 0
  fi
}

#######################################
# description here
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   1 if should run
#   0 if not
#######################################
wataash::conf::should_run_fish() {
  wataash::conf::log "Determine whether we should run fish or not."

  if [ "$BASHCONF_NO_FISH" = 1 ]; then
    wataash::conf::log "\$BASHCONF_NO_FISH is 1, return 0."
    return 0
  fi

  wataash::conf::is_interactive
  if [ $? -eq 0 ]; then
    wataash::conf::log "It's not interactive shell.  Return 0."
    return 0
  fi

  wataash::conf::log "Return 1."
  return 1
}

wataash::conf::run_fish() {
  wataash::conf::log "Run fish."

  wataash::conf::should_run_fish
  if [ $? -eq 0 ]; then
    # 234: no meaning
    wataash::conf::log "wataash::conf::should_run_fish returned 0.  Return 234."
    return 234
  fi

  wataash::conf::log "Run it!"
  fish
  rc=$?
  if [ $rc -ne 0 ] ; then
    wataash::conf::log "fish exited with $rc.  Return it."
  return $rc
  fi

  wataash::conf::log "fish exited with 0.  Return 0."
  return 0
}

#######################################
# Set PATH.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
wataash::conf::main() {
  wataash::conf::log "--------------------------------------------------"
  wataash::conf::log "Loading ~/.bashconf.sh"
  wataash::conf::log "caller: $(caller)"
  wataash::conf::log "\$0: $0"
  wataash::conf::log "\$@: $@"
  
  wataash::conf::should_source
  if [ $? -eq 0 ]; then
    wataash::conf::log "should_source() returned 0.  Return."
    return;
  fi

  wataash::conf::log "export BASHCONF_SOURCED=1"
  export BASHCONF_SOURCED=1

  wataash::conf::set_env

  wataash::conf::run_fish
  ret=$?
  if [ $ret -ne 0 ]; then
    # 234: no meaning
    wataash::conf::log "run_fish() returned $ret.  Return it."
    return $ret
  fi

  wataash::conf::log  "run_fish() returned 0.  exit 0."
  exit 0
}

wataash::conf::main

# -----------------------------------------------------------------------------
wataash::conf::__memo() {
  if ! do_something; then
    wataash::conf::err "Unable to do_something"
    exit "${E_DID_NOTHING}"
  fi

  if [ -n "$DEBUG" ]; then
    zenity --info --text="env: $(env)"
  fi

  if [ -n "$DEBUG" ]; then
    zenity --info --text="set: $(set)"
  fi

  case "$(uname -v)" in
    *Ubuntu*) zenity --info --text='loading .bashrc' ;;
    *) echo 'loading .bashrc' ;;
  esac

  [ -n "$DEBUG_GUI" ] && { export DEBUG=1; }
}
