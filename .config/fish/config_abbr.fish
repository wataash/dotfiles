# Edit: slfa
# update: abs
# list in peco: abp

abbr .    cd ../
abbr ..   cd ../../
abbr ...  cd ../../../
abbr .2   cd ../../
abbr .3   cd ../../../
abbr .4   cd ../../../../

# TODO
# abbr -a gri (--cursor|-c) 1 grep /usr/include/
#                            ^0   ^1,-2         ^2,-1
# but fish's array starts 1?
# or,
# abbr -a gri (--cursor|-c) '{}' grep '{}' /usr/include/
# like xargs' -I option.
# echo foo bar | xargs -I '{}' grep '{}' /usr/include/
# will execute
# - grep foo /usr/include/
# - grep bar /usr/include/
#
# abbr -a agcmake ag (here!) ~/src/tes/cpp/CMakeLists.txt  ~/src/tes/cpp/CMakeLists_autotools.txt

# TODO
# completion for abbrs


# abbr -a abs   (string join ' ' \
#                "for a in (abbr --list); abbr --erase \$a; end;" \
#                "and" \
#                "source (grep 'abbr' ~/.config/fish/config.fish | psub)")

function abbr_files -d 'abbr_files <prefix> <expression>'
    echo --- abbr_files $argv

    set -l options 'h/help'
    argparse -n abbr_files --min-args=2 --max-args=2 $options -- $argv
    or return

    set -l prefix $argv[1]
    set -l exp $argv[2]

    set -l ev abbr -a "$prefix".   (string replace __placeholder__ ./                               $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$prefix"agl (string replace __placeholder__ \~/usr/bin/aglang                $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$prefix"b   (string replace __placeholder__ \~/.bashconf.sh                  $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$prefix"f   (string replace __placeholder__ \~/.config/fish/config.fish      $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$prefix"fa  (string replace __placeholder__ \~/.config/fish/config_abbr.fish $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$prefix"gi  (string replace __placeholder__ \~/.gitignore                    $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$prefix"h   (string replace __placeholder__ \~/                              $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$prefix"h   (string replace __placeholder__ \~/                              $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$prefix"m   (string replace __placeholder__ \~/mnt/                          $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$prefix"mw  (string replace __placeholder__ \~/mnt/wsh/                      $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$prefix"s   (string replace __placeholder__ \~/src/                          $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$prefix"sp  (string replace __placeholder__ \~/.spacemacs                    $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$prefix"ssh (string replace __placeholder__ \~/.ssh/config                   $exp) ; echo $ev; eval $ev
end

abbr -a a              ls -ahiFl
abbr -a ab             abbr
  abbr -a abe          'for a in (abbr --list); abbr --erase $a; end'
  abbr -a abp          'abbr | peco'
  abbr -a abs          "source ~/.config/fish/config_abbr.fish"
abbr -a agl            aglang
  abbr -a aglb         aglang -vvv bmake
  abbr -a aglf         aglang fish
  abbr -a aglp         aglang python
#                      .
abbr -a b              brew
abbr -a bi             brew install --verbose
abbr -a bs             brew search --verbose
#                      .
abbr -a c              cd
  abbr_files c 'cd __placeholder__'
abbr -a ca             cat
abbr -a cg             cd $GOPATH/src/github.com/wataash/
# cw is hard to type   .
abbr -a cx             cd $GOPATH/src/github.com/wataash/
#                      .
# abbr -a d            .
#                      .
abbr -a e              emacsclient -nw
  abbr_files e 'emacsclient -nw __placeholder__'
abbr -a ec             echo
abbr -a ed             emacs --daemon
#                      .
abbr -a f              find
  abbr_files fn 'find __placeholder__ -name'
#                      .
abbr -a g              git
  abbr -a ga           git add -v
    abbr_files ga 'git add -v __placeholder__'
    abbr -a gap        git add -v -p
    abbr -a gau        git add -v -u ./
#                      .
  abbr -a gb           git branch
  abbr -a gba          git branch -avv
  abbr -a gbb          git branch -vv
  abbr -a gc           git commit -S
  abbr -a gca          git commit -S --amend
  abbr -a gck          git checkout
  abbr -a gck.         git checkout ./
  abbr -a gckb         git checkout -b
  abbr -a gckp         git checkout -p
  abbr -a gcl          git clean -fd
  abbr -a gcl.         git clean -fd ./
  abbr -a gclx         git clean -fdx
  abbr -a gclx.        git clean -fdx ./
  abbr -a gcm          git commit -S -m \'
  abbr -a gcmf         git commit -S -m \'f
  abbr -a gcn          git commit -S --amend --no-edit
  abbr -a gcy          git cherry-pick
  abbr -a gcya         git cherry-pick --abort
  abbr -a gcyc         git cherry-pick --continue
  abbr -a gd           git diff          --color-words --word-diff
  abbr -a gdc          git diff --cached --color-words --word-diff
  abbr -a gf           git fetch
  abbr -a gfo          git fetch origin
  abbr -a gfod         git fetch origin develop
  abbr -a gfoh         git fetch origin head_
  abbr -a gfom         git fetch origin master
  abbr -a gfu          git fetch upstream
  abbr -a gfud         git fetch upstream develop
  abbr -a gfuh         git fetch upstream head_
  abbr -a gfum         git fetch upstream master
  abbr -a gid          git icdiff          --color-words --word-diff
  abbr -a gidc         git icdiff --cached --color-words --word-diff
  abbr -a gm           git mergetool
  abbr -a gp           git push
  abbr -a gpf          git push --force
  abbr -a gpfs         git push --force --set-upstream
  abbr -a gpfso        git push --force --set-upstream origin
  abbr -a gpfsu        git push --force --set-upstream upstream
  abbr -a gps          git push --set-upstream
  abbr -a gpso         git push --set-upstream origin
  abbr -a gpsu         git push --set-upstream upstream
  abbr -a gpu          git pull
  abbr -a gr           git reset
  abbr -a gr.          git reset ./
  abbr -a grb          git rebase
  abbr -a grba         git rebase --abort
  abbr -a grbc         git rebase --continue
  abbr -a grbi         git rebase --interactive
  abbr -a grbib        git rebase --interactive base
  abbr -a grbiod       git rebase --interactive origin/develop
  abbr -a grbioh       git rebase --interactive origin/head_
  abbr -a grbiom       git rebase --interactive origin/master
  abbr -a grbiud       git rebase --interactive upstream/develop
  abbr -a grbiuh       git rebase --interactive upstream/head_
  abbr -a grbium       git rebase --interactive upstream/master
  abbr -a grbod        git rebase               origin/develop
  abbr -a grboh        git rebase               origin/head_
  abbr -a grbom        git rebase               origin/master
  abbr -a grbud        git rebase               upstream/develop
  abbr -a grbuh        git rebase               upstream/head_
  abbr -a grbum        git rebase               upstream/master
  abbr -a gre          git remote -v
  abbr -a grh          git reset --hard
  abbr -a grhh         git reset --hard HEAD
  abbr -a grhhh        git reset --hard HEAD~
  abbr -a grhhhh       git reset --hard HEAD~~
  abbr -a grho         git reset --hard origin/'(git symbolic-ref --short HEAD)'
  abbr -a grhod        git reset --hard origin/develop
  abbr -a grhoh        git reset --hard origin/head_
  abbr -a grhom        git reset --hard origin/master
  abbr -a grhu         git reset --hard upstream/'(git symbolic-ref --short HEAD)'
  abbr -a grhud        git reset --hard upstream/develop
  abbr -a grhuh        git reset --hard upstream/head_
  abbr -a grhum        git reset --hard upstream/master
  abbr -a grp          git reset -p
  abbr -a grs          git reset --soft
  abbr -a grsh         git reset --soft HEAD
  abbr -a grshh        git reset --soft HEAD~
  abbr -a grshhh       git reset --soft HEAD~~
  abbr -a grso         git reset --soft origin/'(git symbolic-ref --short HEAD)'
  abbr -a grsu         git reset --soft upstream/'(git symbolic-ref --short HEAD)'
  abbr -a gs           git status ./
  abbr -a gsh          git show --color-words --word-diff
  abbr -a gsi          git status --ignored ./
  abbr -a gst          git stash
  abbr -a gstd         git stash drop
  abbr -a gstl         git stash list
  abbr -a gstp         git stash pop
  abbr -a gsts         git stash show -p
  abbr -a gsu          git status -u ./
#                      .
abbr -a h              dirh
abbr -a hm             history merge
#                      .
abbr -a i              ifconfig
#                      .
abbr -a j              ls -hiFl
#                      .
abbr -a k              kill
  abbr -a kk           kill -9
#                      .
# abbr -a l            .
abbr -a la              ls -aihlF
#                      .
abbr -a m              env PAGER=vimpager man
  abbr -a ma           man -aw
abbr -a mc             mkdircd
abbr -a mcb            mkdircd build/
abbr -a md             mkdir
#                      .
abbr -a n              nextd
abbr -a nv             nvim
  abbr_files nv 'nvim __placeholder__'
#                      .
abbr -a o              open
  abbr_files o 'open __placeholder__'
abbr -a p              prevd
abbr -a pr             printf
abbr -a psa            'ps aux | ag'
abbr -a psp            'ps aux | peco'
abbr -a py             python
#                      .
# abbr -a q            .
#                      .
abbr -a r              rm
  abbr -a rr           rm -rf
#                      .
abbr -a s              ssh
abbr -a sl             subl
  abbr_files sl 'subl __placeholder__'
#                      .
abbr -a t              tig --all
abbr -a teee           '2>&1 | tee'
abbr -a tm             'tmux a -d     ; or tmux'
  abbr -a tm0          'tmux a -d -t 0; or tmux'
  abbr -a tm1          'tmux a -d -t 1; or tmux'
  abbr -a tm2          'tmux a -d -t 2; or tmux'
abbr -a ty             type
  abbr -a tya          type -a
#                      .
# abbr -a u            .
#                      .
abbr -a v              vim
  abbr_files v 'vim __placeholder__'
#                      .
abbr -a wg             wget
#                      .
abbr -a wh             which
  abbr -a wha          which -a
#                      .
abbr -a x              xargs -L1
#                      .
# abbr -a y            .
#                      .
# abbr -a z            # command z
