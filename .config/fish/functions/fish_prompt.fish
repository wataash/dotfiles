# powerline-go
# https://github.com/justjanne/powerline-go
# go get -u -v github.com/justjanne/powerline-go

# don't include trailing '/'
set -g wataash_ignore_repos (string join , \
    /___FREEBSD_SRC___ \
    /___NETBSD_SRC___ \
    /___OPENBSD_SRC___ \
    ~/qc/binutils-gdb \
    ~/qc/freebsd/src \
    ~/qc/linux \
    ~/qc/netbsd/src \
    ~/qc/openbsd/src \
    ~/src/binutils-gdb \
    ~/src/freebsd/src \
    ~/src/linux \
    ~/src/netbsd/src \
    ~/src/openbsd/src \
)

set -g wataash_paths_alias (string join , \
    go/src/github.com/wataash/tesgo=[tesgo] \
    go/src/github.com/wataash=[wataash] \
    go/src/github.com=[github] \
    qc/binutils-gdb=[gdb] \
    qc/freebsd=[fb] \
    qc/gcc=[gcc] \
    qc/git=[git] \
    qc/linux=[linux] \
    qc/netbsd/obj.amd64=[oamd64] \
    qc/netbsd/obj.amd64=[obj.amd64] \
    qc/netbsd/obj.arm=[oarm] \
    qc/netbsd/src/bin=[bin] \
    qc/netbsd/src/sbin=[sbin] \
    qc/netbsd/src/sys/arch/amd64=[amd64] \
    qc/netbsd/src/sys/arch/evbarm=[evbarm] \
    qc/netbsd/src/sys/arch=[arch] \
    qc/netbsd/src/sys=[sys] \
    qc/netbsd/src/usr.bin=[usr.bin] \
    qc/netbsd/src/usr.sbin=[usr.sbin] \
    qc/netbsd/src=[nb] \
    qc/openbsd=[ob] \
    qc/strongswan=[swan] \
    qc/tesc=[tesc] \
    qc=[qc] \
    qhs=[qhs] \
    qjava=[qjava] \
    qjs/tesjs=[tesjs] \
    qjs=[qjs] \
    qpy/tespy=[tespy] \
    qpy=[qpy] \
    qrb=[qrb] \
    qrs/tesrs=[tesrs] \
    qrs=[qrs] \
    src/tessh=[tessh] \
    src=[src] \
)

function fish_prompt
    # -l and _saved for paranoia
    set -l status_saved $status  # seems this doesn't modify CMD_DURATION
    set -l cmd_duration_saved $CMD_DURATION

    set -l duration (math -s6 "$CMD_DURATION / 1000")

    # set VAR 'foo' to indicate 'foo'
    # don't double-quote "$VAR" to avoid append ''
    set -lx WATAASH_POWERLINE_VAR (date '+%T') $VAR

    ~/go/bin/powerline-go \
        -shell bare \
        -colorize-hostname \
        # -cwd-max-depth 5       (: ~ > dir1 > dir2 > ... > dir7 > dir8 > dir9) \
        -cwd-max-dir-size 10     (: '~ > long-long-d > dir') \
        -cwd-mode fancy \
        -duration $duration \
        -duration-min 3 \
        -east-asian-width \
        -error $status_saved \
        -ignore-repos $wataash_ignore_repos \
        -mode patched \
        -modules shell-var,venv,user,host,load,ssh,cwd,perms,git,hg,jobs,exit,root,docker,duration,node \
        -newline \
        -numeric-exit-codes \
        -path-aliases $wataash_paths_alias \
        -shell-var WATAASH_POWERLINE_VAR \
        ;

    return $status
end
