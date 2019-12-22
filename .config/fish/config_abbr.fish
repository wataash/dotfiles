# Edit: slfa
# update: abs
# list in peco: abp

# frequency analysis:
#
# history | awk '{ print $1 }' | sort | uniq -c | sort -h
#     ...
#       4079 ls
#       4167 ag
#      14735 git
#
# history | awk '{ print $1 " " $2 }' | sort | uniq -c | sort -h
#     ...
#     1598 git add
#     2293 ls -hiFl
#     2636 git commit

function abbrp -d 'abbr with paths; abbrp <abbr> <expansion with __path__>'
    set_color green
    echo abbrp $argv
    set_color normal

    set -l options 'h/help'
    argparse -n abbrp --min-args=2 --max-args=2 $options -- $argv
    or return

    set -l _abbr $argv[1]
    set -l exp $argv[2]

    set_color white
    set -l ev abbr -a "$_abbr"    (string replace __path__ ''                                 $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$_abbr".   (string replace __path__ ./                                 $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$_abbr"/   (string replace __path__ /                                  $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$_abbr"b   (string replace __path__ '\~/.bashconf.sh'                  $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$_abbr"f   (string replace __path__ '\~/.config/fish/config.fish'      $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$_abbr"fa  (string replace __path__ '\~/.config/fish/config_abbr.fish' $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$_abbr"gi  (string replace __path__ '\~/.gitignore'                    $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$_abbr"h   (string replace __path__ '\~/'                              $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$_abbr"i   (string replace __path__ /usr/include/                      $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$_abbr"m   (string replace __path__ '\~/mnt/'                          $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$_abbr"mw  (string replace __path__ '\~/mnt/wsh/'                      $exp) ; echo $ev; eval $ev
    set -l ev abbr -a "$_abbr"s   (string replace __path__ '\~/src/'                          $exp) ; echo $ev; eval $ev
    set_color normal
end

abbr -a .              cd ../
abbr -a ..             cd ../../
abbr -a ...            cd ../../../
abbr -a .2             cd ../../
abbr -a .3             cd ../../../
abbr -a .4             cd ../../../../
abbr -a a              ag
abbr -a ab             abbr
abbr -a abe           'for a in (abbr --list); abbr --erase $a; end'
abbr -a abp           'abbr | peco'
abbr -a abs           "source ~/.config/fish/config_abbr.fish"
abbrp   ag            'ag __path__'
abbr -a agg            ag -G
abbr -a agl            aglang
abbr -a aglb           aglang -vvv bmake
abbr -a aglf           aglang fish
abbr -a aglp           aglang python
abbr -a aps            apt search
abbr -a b              bat
abbr -a bl             bat -l
abbr -a bls            bat -l sh
abbr -a bll            bat -L
abbr -a bn             ./build.sh -m amd64 -T ../tools/ -O ../obj.amd64/ -D ../dest.amd64/ -R ../rel.amd64/ -X ../xsrc/ -u -U -VMKDEBUG=yes -VMKKDEBUG=yes -j3 tools kernel=GENERIC  # netbsd tools GENERIC -j3
abbr -a br             brew
abbr -a bri            brew install -v
abbr -a brin           brew info -v
abbr -a brs            brew search -v
abbr -a bru            brew update -v
abbr -a brug           brew upgrade -v
abbrp   c             'cd __path__'
abbrp   cl            'clion __path__'
abbr -a ca             cat
abbr -a cg             cd '$'GOPATH/src/
abbr -a cgg            cd '$'GOPATH/src/github.com/
abbr -a cw             cd '$'GOPATH/src/github.com/wataash/
abbr -a d              docker
abbr -a dr             docker run
abbr -a dp             docker ps
abbr -a ec             echo
abbr -a ed             emacs --daemon
abbr -a f              find
abbrp   fn            'find __path__ -name'
abbr -a g              git
abbrp   ga            'git add -v __path__'
abbr -a gap            git add -v -p
abbr -a gau            git add -v -u ./
abbr -a gb             git branch
abbr -a gba            git branch -avv
abbr -a gbb            git branch -vv
abbr -a gc             git commit -S
abbr -a gca            git commit -S --amend
abbr -a gck            git checkout
abbr -a gck.           git checkout ./
abbr -a gckb           git checkout -b
abbr -a gckp           git checkout -p
abbr -a gcl            git clean -fd
abbr -a gcl.           git clean -fd ./
abbr -a gclx           git clean -fdx
abbr -a gclx.          git clean -fdx ./
abbr -a gcm            git commit -S -m \'
abbr -a gcms           git commit -S -m "(string join ' ' (git diff --name-only --cached))"  # commit one staged file
abbr -a gcn            git commit -S --amend --no-edit
abbr -a gcy            git cherry-pick
abbr -a gcya           git cherry-pick --abort
abbr -a gcyc           git cherry-pick --continue
abbr -a gd             git diff          --color-words --word-diff
abbr -a gdc            git diff --cached --color-words --word-diff
abbr -a gf             git fetch --prune
abbr -a gfo            git fetch --prune origin
abbr -a gfod           git fetch --prune origin develop
abbr -a gfoh           git fetch --prune origin head_
abbr -a gfom           git fetch --prune origin master
abbr -a gfu            git fetch --prune upstream
abbr -a gfud           git fetch --prune upstream develop
abbr -a gfuh           git fetch --prune upstream head_
abbr -a gfum           git fetch --prune upstream master
abbr -a gfw            git fetch --prune wataash
abbr -a gfwd           git fetch --prune wataash develop
abbr -a gfwh           git fetch --prune wataash head_
abbr -a gfwm           git fetch --prune wataash master
abbr -a gg             go get -u -v
abbr -a ggg            go get -u -v github.com/
abbr -a gid            git icdiff          --color-words --word-diff
abbr -a gidc           git icdiff --cached --color-words --word-diff
abbr -a gl             git log
abbr -a glp            git log --follow -p
abbr -a gm             git mergetool
abbrp   gol           'goland __path__'
abbr -a gp             git push
abbr -a gpf            git push --force
abbr -a gpfo           git push --force                origin
abbr -a gpfu           git push --force                upstream
abbr -a gpfw           git push --force                wataash
abbr -a gpfs           git push --force --set-upstream
abbr -a gpfso          git push --force --set-upstream origin
abbr -a gpfsu          git push --force --set-upstream upstream
abbr -a gpfsw          git push --force --set-upstream wataash
abbr -a gps            git push --set-upstream
abbr -a gpso           git push --set-upstream origin
abbr -a gpsu           git push --set-upstream upstream
abbr -a gpsw           git push --set-upstream wataash
abbr -a gpu            git pull
abbr -a gr             git reset
abbr -a gr.            git reset ./
abbr -a grb            git rebase
abbr -a grba           git rebase --abort
abbr -a grbc           git rebase --continue
abbr -a grbi           git rebase --interactive
abbr -a grbib          git rebase --interactive base
abbr -a grbiod         git rebase --interactive origin/develop
abbr -a grbioh         git rebase --interactive origin/head_
abbr -a grbiom         git rebase --interactive origin/master
abbr -a grbiud         git rebase --interactive upstream/develop
abbr -a grbiuh         git rebase --interactive upstream/head_
abbr -a grbium         git rebase --interactive upstream/master
abbr -a grbiwd         git rebase --interactive wataash/develop
abbr -a grbiwh         git rebase --interactive wataash/head_
abbr -a grbiwm         git rebase --interactive wataash/master
abbr -a grbod          git rebase               origin/develop
abbr -a grboh          git rebase               origin/head_
abbr -a grbom          git rebase               origin/master
abbr -a grbud          git rebase               upstream/develop
abbr -a grbuh          git rebase               upstream/head_
abbr -a grbum          git rebase               upstream/master
abbr -a grbwd          git rebase               wataash/develop
abbr -a grbwh          git rebase               wataash/head_
abbr -a grbwm          git rebase               wataash/master
abbr -a gre            git remote -v
abbr -a grh            git reset --hard
abbr -a grhh           git reset --hard HEAD
abbr -a grhhh          git reset --hard HEAD~
abbr -a grhhhh         git reset --hard HEAD~~
abbr -a grho           git reset --hard origin/'(git symbolic-ref --short HEAD)'
abbr -a grhod          git reset --hard origin/develop
abbr -a grhoh          git reset --hard origin/head_
abbr -a grhom          git reset --hard origin/master
abbr -a grhu           git reset --hard upstream/'(git symbolic-ref --short HEAD)'
abbr -a grhud          git reset --hard upstream/develop
abbr -a grhuh          git reset --hard upstream/head_
abbr -a grhum          git reset --hard upstream/master
abbr -a grhw           git reset --hard wataash/'(git symbolic-ref --short HEAD)'
abbr -a grhwd          git reset --hard wataash/develop
abbr -a grhwh          git reset --hard wataash/head_
abbr -a grhwm          git reset --hard wataash/master
abbr -a grp            git reset -p
abbr -a grs            git reset --soft
abbr -a grsh           git reset --soft HEAD
abbr -a grshh          git reset --soft HEAD~
abbr -a grshhh         git reset --soft HEAD~~
abbr -a grso           git reset --soft origin/'(git symbolic-ref --short HEAD)'
abbr -a grsu           git reset --soft upstream/'(git symbolic-ref --short HEAD)'
abbr -a grsw           git reset --soft wataash/'(git symbolic-ref --short HEAD)'
abbr -a gs             git status ./
abbr -a gsh            git show --color-words --word-diff
abbr -a gsi            git status --ignored ./
abbr -a gst            git stash
abbr -a gstd           git stash drop
abbr -a gstl           git stash list
abbr -a gstp           git stash pop
abbr -a gsts           git stash show -p
abbr -a gsu            git status -u ./
abbr -a gt             git tag
abbr -a h              dirh
abbr -a hm             history merge
abbr -a i              ifconfig
abbrp   ij            'idea __path__'
abbr -a ipa            ip address
abbr -a ipaa           ip a add 192.168.0.1/24 dev eth0
abbr -a ipaad          ip a del 192.168.0.1/24 dev eth0
abbr -a ipl            ip link
abbr -a j              ls -hiFl
abbr -a k              kubectl
abbr -a ka             kubectl apply -f
abbr -a kg             kubectl get -owide
abbr -a kga            kubectl get -owide all,cm
abbr -a kl             kubectl logs
abbr -a l              ln
abbr -a la             ls -aihlF
abbr -a lns            ln -s
abbr -a m              mv
abbr -a ma             man
abbr -a maw            man -aw
abbr -a mc             mkdircd
abbr -a mcb            mkdircd build/
abbr -a mk             mkdir
abbr -a n              nextd
abbrp   nv            'nvim __path__'
abbrp   o             'open __path__'
abbr -a p              prevd
abbrp   pc            'pycharm __path__'
abbr -a pr             printf
abbr -a psa            'ps aux | ag'
abbr -a psp            'ps aux | peco'
abbr -a py             python
abbr -a q             'qemu-system-x86_64  (: -boot)  -m 1G  -hda ~/vm/.qcow2  (: -cdrom)  (: -drive)  (: -sd)  ([ (uname -s) = Linux ] && echo -virtfs)  -nographic  (: -nic)  (: -kernel)  (: -append)  (: -initrd)  (: -dtb)  (: -S)  (: -gdb tcp::1234)  ([ (uname -s) = Linux ] && echo -enable-kvm)  -no-reboot  (: -rtc base=utc)'
abbr -a qc             cd ~/qc/
abbr -a qhs            cd ~/qhs/
abbr -a qjava          cd ~/qjava/
abbr -a qjs            cd ~/qjs/
abbr -a qpy            cd ~/qpy/
abbr -a qrs            cd ~/qrs/
abbr -a r              rm
abbrp   rbm           'rubymine __path__'
abbr -a rr             rm -rf
abbr -a rs            'rsync -vva -n -e \'ssh -p 22\' (: --delete --max-delete=1) (: --chown=wsh:wsh) (: --include --exclude) (: -s) (: -h --progress) ./src ./dst  #'
abbr -a s              ssh
abbr -a sa             sudo apt
abbr -a sai            sudo apt install
abbr -a sar            sudo apt remove
abbr -a sas            sudo apt search
abbr -a sash           sudo apt show
abbr -a sau            sudo apt update
abbr -a saug           sudo apt upgrade
abbr -a sd             sudo
abbrp   sl            'subl __path__'
abbr -a sp             ssh -p0 root@localhost
abbr -a spp            ssh -p0 -oPreferredAuthentications=password root@localhost
abbr -a t              tig --all
abbr -a teee          '2>&1 | tee'
abbr -a tm            'tmux a -d     ; or tmux'
abbr -a tm0           'tmux a -d -t 0; or tmux'
abbr -a tm1           'tmux a -d -t 1; or tmux'
abbr -a tm2           'tmux a -d -t 2; or tmux'
abbr -a ty             type
abbr -a tya            type -a
abbr -a u              uniq
abbr -a um             umount
abbr -a un             uname
abbrp   v             'vim __path__'
abbr -a wg             wget
abbr -a wh             which
abbr -a wha            which -a
abbrp   ws            'webstorm __path__'
abbr -a xi             xsel -b -i
abbr -a xl             xargs -L1
abbr -a xo             xsel -b -o
abbr -a y              yarn
abbr -a ya             yarn add
abbr -a yad            yarn add -D
abbr -a yg             yarn global add
abbr -a yu             yarn upgrade-interactive --latest
#       z                https://github.com/clvv/fasd
#       z                https://github.com/fishgretel/fasd
abbr -a z              fasd_cd -d
abbr -a zz             fasd_cd -d -i
