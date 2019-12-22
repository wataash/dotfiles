#!/bin/bash

# https://scrapbox.io/wataash/.bashconf.sh

# follow shellcheck
# https://github.com/koalaman/shellcheck

set -u

# ------------------------------------------------------------------------------
# usage

# source me from .bash_profile:
#   source ~/.bashconf.sh
# if ~/.bash_profile doesn't exist, source me from ~/.bashrc

# ------------------------------------------------------------------------------
# logging

# echo_black()  { tput setaf 0 ; echo "$@" ; tput sgr0 ; }
# echo_red()    { tput setaf 1 ; echo "$@" ; tput sgr0 ; }
# echo_green()  { tput setaf 2 ; echo "$@" ; tput sgr0 ; }
# echo_yellow() { tput setaf 3 ; echo "$@" ; tput sgr0 ; }
# echo_blue()   { tput setaf 4 ; echo "$@" ; tput sgr0 ; }
# echo_purple() { tput setaf 5 ; echo "$@" ; tput sgr0 ; }
# echo_cyan()   { tput setaf 6 ; echo "$@" ; tput sgr0 ; }
# echo_white()  { tput setaf 7 ; echo "$@" ; tput sgr0 ; }

# https://google.github.io/styleguide/shell.xml?showone=STDOUT_vs_STDERR#STDOUT_vs_STDERR
_log() {
  echo -n "$(date +'%Y-%m-%d %H:%M:%S')"
  # 108 set_env_path /home/wsh/.bashconf.sh
  printf ' %20s %3d  ' "${FUNCNAME[2]}" ${BASH_LINENO[1]}
  echo "  $*"

  # echo "${FUNCNAME[0]}"   # _log
  # echo "${FUNCNAME[1]}"   # debug
  # echo "${FUNCNAME[2]}"   # set_env
  # echo $LINENO            # lineno for here
  # echo ${BASH_LINENO[0]}  # lineno in debug
  # echo ${BASH_LINENO[1]}  # lineno in set_env

  # echo "caller  : $(caller)"    # caller  : 91 /home/wsh/.bashconf.sh
  # echo "caller 0: $(caller 0)"  # caller 0: 91 debug /home/wsh/.bashconf.sh
  # echo "caller 1: $(caller 1)"  # caller 1: 299 should_run_fish /home/wsh/.bashconf.sh
  # echo "caller 2: $(caller 2)"  # caller 2: 314 run_fish /home/wsh/.bashconf.sh
  # echo "caller 3: $(caller 3)"  # caller 3: 355 source /home/wsh/.bashconf.sh
}

LOGFILE=/tmp/wataash/bashconf.log

# all functions must call debug() first:
#   func() {
#     debug
#     ...
#   }
err()   {         { tput setaf 1 ; _log "$@" ; tput sgr0 ; } | tee -a $LOGFILE >&2 ; }
warn()  {         { tput setaf 3 ; _log "$@" ; tput sgr0 ; } | tee -a $LOGFILE >&2 ; }
info()  { return; { tput setaf 4 ; _log "$@" ; tput sgr0 ; } | tee -a $LOGFILE >&2 ; }
debug() { return; { tput setaf 7 ; _log "$@" ; tput sgr0 ; } | tee -a $LOGFILE >&2 ; }

if [ "$0" = "/etc/gdm3/Xsession" ]; then
# avoid >&2 ; at Ubuntu login (gdm3), error dialog appears if any stderr
err()   {         { tput setaf 1 ; _log "$@" ; tput sgr0 ; } >> $LOGFILE ; }
warn()  {         { tput setaf 3 ; _log "$@" ; tput sgr0 ; } >> $LOGFILE ; }
info()  {         { tput setaf 4 ; _log "$@" ; tput sgr0 ; } >> $LOGFILE ; }
denug() {         { tput setaf 7 ; _log "$@" ; tput sgr0 ; } >> $LOGFILE ; }
fi

# ------------------------------------------------------------------------------
# main

should_source() {
  debug

  # BUG
  # 5.0.7(1)-release:
  # -bash: /Users/wsh/.bashconf.sh: line 87: conditional binary operator expected
  # -bash: /Users/wsh/.bashconf.sh: line 87: syntax error near `BASHCONF_SOURCED'
  # -bash: /Users/wsh/.bashconf.sh: line 87: `  if [[ -v BASHCONF_SOURCED ]]; then'
  # fixed on bash99
  #
  # if [[ -v BASHCONF_SOURCED ]]; then
  #   warn ".bashconf.sh is already sourced; return 0"
  #   return 0
  # fi

  set +u
  if [ -n "$BASHCONF_SOURCED" ]; then
    set -u
    warn ".bashconf.sh is already sourced; return 0"
    return 0
  fi
  set -u

  if [ "$0" = "/etc/gdm3/Xsession" ]; then
    # at login
    warn 'from /etc/gdm3/Xsession, logging in? return 0'
    return 0
  fi

  debug "return 1"
  return 1
}

set_env_path() {
  debug

  set +u
  debug "Initial \$PATH: $PATH"
  debug "Initial \$MANPATH: $MANPATH"
  debug "Initial \$INFOPATH: $INFOPATH"
  debug "Initial \$(manpath): $(manpath)"
  set -u

  # cargo
  p_cargo=$HOME/.cargo/bin
  m_cargo=
  i_cargo=

  # dot_local: ~/.local/bin/ for binaries installed by pip
  p_dot_local=$HOME/.local/bin
  m_dot_local=$HOME/.local/share/man
  i_dot_local=

  # go
  export GOPATH=$HOME/go
  p_go=$GOPATH/bin
  m_go=
  i_go=

  # Home
  p_h=$HOME/usr/bin:$HOME/usr/sbin
  m_h=$HOME/usr/share/man
  i_h=$HOME/usr/share/info

  # netbsd
  p_netbsd=$HOME/qc/netbsd/tools/bin
  m_netbsd=
  i_netbsd=
  [ -d "$p_netbsd" ] || p_netbsd=

  # node
  # https://docs.npmjs.com/getting-started/fixing-npm-permissions
  # ~/.npmrc
  p_npm=$HOME/.npm-global/bin
  m_npm=
  i_npm=

  # opt
  # note - Use find instead of ls to better handle non-alphanumeric filenames. [SC2012]
  # shellcheck disable=SC2012
  p_opt=$(ls -d ~/opt/*/sbin           | tr '\n' :)
  # shellcheck disable=SC2012
  p_opt=$p_opt:$(ls -d ~/opt/*/bin     | tr '\n' :)
  # shellcheck disable=SC2012
  m_opt=$(ls -d ~/opt/*/share/man      | tr '\n' :)
  # shellcheck disable=SC2012
  i_opt=$(ls -d ~/opt/*/share/info     | tr '\n' :)

  # suppress:
  # ls: cannot access '/home/wsh/usr/opt/*/sbin': No such file or directory
  # mkdir -p ~/usr/opt/dummy/{bin,sbin,share/man,share/info}/

  # os specific
  p_os=
  m_os=
  i_os=
  if [ "$(uname -s)" = Darwin ]; then
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
  p_rb=
  m_rb=
  i_rb=
  [ -d ~/.rbenv/bin ] && p_rb=$HOME/.rbenv/bin:$HOME/.rbenv/shims

  set +u
  PATH_INIT____=$PATH
  MANPATH_INIT_=$MANPATH
  INFOPATH_INIT=$INFOPATH
  set -u
  # paths likely not conflicting first (e.g. gdb99, nbmake-amd64)
  # lexicographically
  PATH____="$p_netbsd:$p_opt"
  MANPATH_="$m_netbsd:$m_opt"
  INFOPATH="$i_netbsd:$i_opt"
  # easy-to-rename binaries next; lexicographically
  # if it conflicts with built-in commands, just rename it!
  PATH____="$PATH____:$p_cargo:$p_h:$p_go:$p_rb:$p_dot_local:$p_npm"
  MANPATH_="$MANPATH_:$m_cargo:$m_h:$m_go:$m_rb:$m_dot_local:$m_npm"
  INFOPATH="$INFOPATH:$i_cargo:$i_h:$i_go:$i_rb:$i_dot_local:$i_npm"
  # hard-to-rename (system) binaries and inits last
  PATH____="$PATH____:$p_os:$PATH_INIT____"
  MANPATH_="$MANPATH_:$m_os:$MANPATH_INIT_"
  INFOPATH="$INFOPATH:$i_os:$INFOPATH_INIT"

  debug "\$PATH____: $PATH____"
  debug "\$MANPATH_: $MANPATH_"
  debug "\$INFOPATH: $INFOPATH"
  debug "\$(manpath): $(manpath)"

  # remove empty PATH; it will be "."
  # i.e. /bin::/sbin -> /bin:.:/sbin
      PATH=$(echo "$PATH____" | sed -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/^:// -e s/:$//)
   MANPATH=$(echo "$MANPATH_" | sed -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/^:// -e s/:$//)
  INFOPATH=$(echo "$INFOPATH" | sed -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/::/:/g -e s/^:// -e s/:$//)

  debug "\$PATH (after sed): $PATH"
  debug "\$MANPATH (after sed): $MANPATH"
  debug "\$INFOPATH (after sed): $INFOPATH"

  export PATH MANPATH INFOPATH
}

set_env() {
  debug

  set_env_path

  # # fzf
  # export FZF_DEFAULT_OPTS=--multi

  # keychain
  eval "$(keychain -q --eval --inherit any)"
  ssh-add 2>&1 | grep -v 'Identity added: '
  # confirm:
  #  ssh-add -l
  #  ssh -A some-host 'ssh-add -l'

  # z
  # https://github.com/oh-my-fish/plugin-z
  export Z_SCRIPT_PATH=$HOME/usr/bin/z.sh
  if [ "$(uname -s)" = Darwin ]; then
    export Z_SCRIPT_PATH=$(brew --prefix)/etc/profile.d/z.sh
  fi

  debug "return 0"
}

# *0* if interactive
is_interactive() {
  debug

  # https://www.gnu.org/software/bash/manual/html_node/Is-this-Shell-Interactive_003f.html
  if [ -n "$PS1" ]; then
    debug "interactive"
    return 0
  fi

  if [[ $SHELLOPTS == *emacs* ]]; then
    # found by print `env` and `set`
    info "emacs on Ubuntu; not interactive"
    return 1
  fi

  if [[ $XPC_SERVICE_NAME == org.gnu.Emacs.* ]]; then
    info "emacs on macOS; not interactive"
    return 1
  fi

  if [ "$TERM" = dumb ]; then
    # TODO what it difference with above? GUI and -nw ?
    # 0?
    info "emacs on macOS (dumb); not interactive"
    return 0
  fi

  warn "unknown; non-interactive?"
  return 1
}

# *0* if should run
should_run_fish() {
  debug

  if ! is_interactive; then
    info "not interactive shell; should not"
    return 1
  fi

  debug "shoud run"
  return 0
}

run_fish() {
  debug

  if ! should_run_fish; then
    # 234: no meaning; just to aware that "234" is from bashconf.sh
    info "return 234"
    return 234
  fi

  info "run it!"
  fish
  rc=$?
  if [ $rc -ne 0 ] ; then
    info "fish exited with $rc; stty sane and return it"
  stty sane
  return $rc
  fi

  debug "fish exited with 0.  Return 0."
  return 0
}

main() {
  mkdir -p /tmp/wataash/
  export TERM=xterm-256color  # for tput in not a tty
  debug

  info "loading .bashconf.sh"
  debug "\$0: $0"
  debug "\$@: $*"

  if should_source; then
    info "should_source() returned 0; return 0"
    return 0
  fi

  debug "export BASHCONF_SOURCED=1"
  export BASHCONF_SOURCED=1

  set_env

  run_fish
  ret=$?
  if [ $ret -ne 0 ]; then
    info "run_fish() returned $ret; return it"
    return $ret
  fi

  info  "run_fish() returned 0; exit 0"
  exit 0
}

main
debug "end of .bashconf.sh"

set +u
