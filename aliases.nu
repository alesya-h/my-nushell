alias ag = ag --pager=less -i

alias fda = fd -I
alias ec =  emacsclient -c 
alias em = emacsclient -c -n
alias gedit = gnome-text-editor
alias rv = rvim
alias killall = pkill -f
alias grep = grep --color=auto
alias diff = diff --color=auto
alias cdd = cd $"(fd --type=d|fzf)"
def l [ --all(-a) path='.'] {
  let cmd = (if ($all) {{|x| ls -a $x}} else {{|x| ls $x}})
  do $cmd $path
  | sort-by modified
  | sort-by type
}
def la [path='.'] { l -a $path }
alias lt = lsd -l --tree
alias lta = lsd -l -A --tree
alias tailf = tail -f
alias nix-fetch = nix-store -r

# alias cp='cp --reflink=auto'
alias mini = ssh alesya@mini.alesya.cloud

alias pmount = udisksctl mount -b
alias pumount = udisksctl unmount -b

alias dmesg = sudo dmesg -H -w -l info
alias alsamixer = alsamixer -V all

alias v = nvim
alias e = emacsclient
alias ef = emacsclient $"(fzf)"
#alias mc = env LC_COLLATE=C DISABLE_DIRENV=true SHELL=zsh mc
alias mc = env DISABLE_DIRENV=true SHELL=zsh mc -U

def p   [] { ^ps -o pid,pcpu,etime,cmd xf | less }
def pa  [] { ^ps -o user,pid,pcpu,etime,cmd axf|less }
def pf  [] { ^ps -o pid,pcpu,etime,cmd xf | fzf --header-lines=1' }
def paf [] { ^ps -o user,pid,pcpu,etime,cmd axf | fzf --header-lines=1' }
alias pu = htop -u me

alias mpi = mtr 8.8.8.8
alias pi0 = ping 192.168.0.1
alias pi1 = ping 192.168.1.1

def du1 [] { du -d 1|sort-by apparent }
def du2 [] { du -d 2|sort-by apparent }
def du3 [] { du -d 3|sort-by apparent }

alias ga. = git add -A .
alias ga = git add -A
alias gb = git branch
alias gba = git branch -a
alias gc = git commit
alias gca = git commit --amend
alias gclean = git clean -f
alias gclone = git clone
alias gcb = git checkout (git branch|fzf|str replace -r '^..' '')
alias gcba = git checkout (git branch -a|fzf|str replace -r '^..' ''|str replace 'remotes/origin/' '')
# alias gswh = "git reflog|grep checkout|grep ' to '|sed -E 's|^.+ to ||'|grep -v -E '^.{40}$'|uniq|fzf|xargs git switch"
# alias gco. = git checkout .
alias gco = git checkout
alias gcp = git cherry-pick
alias gcpc = git cherry-pick --continue
alias gcpa = git cherry-pick --abort
alias gdiff = git diff
alias gd = git diff HEAD
alias gda = git diff HEAD
alias gdu = git diff
alias gds = git diff --staged
alias gdd = git difftool -d
alias gf = git fetch
alias gfa = git fetch --all
alias gff = git merge --ff-only
alias gfff = git pull --ff-only
alias gfr = sh -c 'git fetch && git rebase'
alias gg = git grep
alias ggrep = git grep
alias ggui = sh -c 'git gui&'
alias gguia = sh -c 'git gui citool --amend&'
def gh [] { git branch|cut -c3-|lines|each {|b| {name: $b, date: (git show -s '--format=format:%cI' $b|into datetime)}}|sort-by date }
alias gim = git imerge merge
alias gir = git imerge rebase
alias gic = git imerge continue
alias gid = git imerge diagram
alias gif = git imerge finish
alias gl = git lg
alias gl. = git lg .
alias glp = git lg -p
alias glp. = git lg -p .
alias glf = git lg --follow
alias glr = git lgr
alias gla = git lg --all
alias glg = git lg --branches
alias gls = git lg --stat
alias glgr = git lgr --branches
alias glgs = git lg --stat --branches
alias gm = git merge
alias gma = git merge --abort
alias gmr = git mr
alias gmw = git merge -Xignore-all-space
alias gpull = git pull
alias gpush = git push
alias gpushf = git push -f
alias gpushu = git push -u origin HEAD
alias gr = git rebase
alias gra = git rebase --abort
alias grc = git rebase --continue
alias gre = git restore
alias gre. = git restore .
alias grh = git reset --hard
alias grs = git reset --soft
alias grr = git reset --mixed
alias grs1 = git reset --soft HEAD^
alias gri = git rebase --interactive
alias gro = git rebase --interactive $"(git rev-parse --abbrev-ref --symbolic-full-name @{u})"
alias grl = git reflog
alias grm = git rm
alias gs = git status
alias gsh = git show
# alias gst = git status --long
def gst [...args] {
  let rel_path = (pwd|str replace $"^(git rev-parse --show-toplevel)/" '')
  git status --porcelain $args|sed -E 's/^(.)(.)/\1|\2|/'
  | lines
  | split column '|' staged unstaged name
  | update staged   {|e| let val = $e.staged;   if ($val == ' ') { null } else { $val }}
  | update unstaged {|e| let val = $e.unstaged; if ($val == ' ') { null } else { $val }}
  | update name {|e| $e.name|str trim| str replace $"^($rel_path)/" ""}
  | each {|e| $e| merge ( try { ls -D $e.name|reject name|get 0 } catch { {} }) }
  | sort-by name -r
  | sort-by unstaged -r
  | sort-by staged -r
  | reverse
  | update name {|e|
      let color = if ($e.staged != null) { if ($e.unstaged != null) { 'yellow' } else { 'green' } } else { 'red' };
      $"(ansi $color)($e.name)(ansi reset)"
    }
}
alias gst. = git status .
alias gsl = git stash list
alias gss = git stash push -u
alias gsp = git stash pop --index
alias gsu = git stash-unindexed -u
alias gstu = git status -uno
alias gsw = git switch
alias gti = git
#alias gunstage = git reset HEAD
alias gunstage = git restore --staged
alias gwd = git wdiff
alias gcd = git cdiff
