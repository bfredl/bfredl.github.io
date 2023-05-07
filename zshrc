# envirionment {{{

# this was for something
if [[ x$HASTHEENV == x ]]; then
    source ~/.zshenv
fi
# }}}
# aliases {{{
alias naut="nautilus --no-desktop ."
alias lo="loffice"

alias mplayerdump='echo mplayer \[-playlist\] _url_ -dumpstream  -dumpfile _file_ '

alias m=make
alias mm='make -j8'
alias i=ipython
alias i2=ipython2

# du df {{{
alias df='df -m'
alias du='du -h'
alias du1='du -h --max-depth=1'
du1s () {
    du -k --max-depth=1 $*|sort -g
}
# }}}
# ls {{{
alias h='ls'
alias l='ls -lh'
alias ll='ls -l'
alias la='ls -lha'
alias lls='ls -lhSa'
alias s='ls -lhSar'
alias t='ls -lhr --sort=time'
alias lsd='ls -lh --sort=time'
# }}}
alias u='diff -u'

alias ss="setsid"
if which pangoterm &> /dev/null; then
    alias te="setsid pangoterm 2> /dev/null"
else
    alias te="setsid xterm 2> /dev/null"
fi
alias hd='hexdump -C'

# TODO: luuuua instead of python
# release version
alias vi='nvim.py'
alias v='tnew neovim nvim.py --persist'
alias pager='nvim - +"set noswapfile nomodifiable nomodified ruler laststatus=1 buftype=nofile" +"color habamax" +"normal L" +"noremap <buffer> u <c-u>" +"noremap <buffer> d <c-d>" +"unmap ds" +"set notitle" +"silent file [PAGER]"'

# dev version
alias nv='nvim.py --dev --asan'
alias n='tnew neovim_dev nvim.py --persist --dev --asan'

sshtmux () {
  tnew sshtmux ssh $1 -t tmux -u a
}
alias sm=sshtmux

tnew () {
    if [[ "$DISPLAY" != "" && "$SSH_TTY" == "" ]]; then
      if which pangoterm &> /dev/null; then
        ( export NVIM_INSTANCE=1; exec -a $1 pangoterm --profile $1 -T "$3" -e ${@:2}) &> /dev/null &!
      else
        te -e $*
      fi
    elif [[ "$TMUX" != "" ]]; then
        tmux new-window $*
    else
        $*
    fi
}

function ag() {
  rg --color always $* | less
}

function vg() {
  # TODO: take errorlist on stdin
  rg --vimgrep $* | pager +cbuffer +copen
}

alias null='cat > /dev/null'
alias pl='pdflatex'
alias e='ss evince'
plshow () {
    pdflatex $1 && (evince ${1/%.tex/.pdf} &>/dev/null) &
}

alias rex="exec zsh"
alias konf="vi ~/.zshrc; rex"

alias se='setxkbmap se'
alias dv='setxkbmap dvorak'
alias ok='setxkbmap ownkeys standard'
# one will understand:
alias sv='setxkbmap ownkeys standard'

alias toc='top -o %CPU'
alias tom='top -o %MEM'

function zsh_stats() {
  history | awk '{print $2}' | sort | uniq -c | sort -rn | head
}

# ssh-add is not smart enough to only ask for pass-phase when necessary
function sa() {
  #  ssh-add -l | grep /home/bjorn/.ssh/id_rsa > /dev/null || ssh-add
}
alias lth="ssh -X login.student.lth.se"

# systéme D
alias sc="systemctl"
alias scs="systemctl start"
alias scr="systemctl restart"
alias scst="systemctl stop"
alias jc="journalctl"
alias nc="netctl"

battery_level () {
    echo $(( 1.0* `cat /sys/class/power_supply/BAT0/charge_now` / `cat /sys/class/power_supply/BAT0/charge_full` ))
}

# }}}
# dir handling {{{

alias pu='pushd'
alias po='popd'

setopt auto_name_dirs
setopt auto_pushd
setopt pushd_ignore_dups

alias ..='cd ..'
alias ...='cd ../..'

alias md='mkdir -p'
alias rd=rmdir

function ta() {
  mkdir -p $1
  cd $1
}

# }}}
# zsh options {{{

alias history='fc -l 1'

HISTFILE=$HOME/.zsh_history
HISTSIZE=20000
SAVEHIST=20000

setopt DVORAK

setopt hist_ignore_dups # ignore duplication command history list
setopt share_history # share command history data

setopt hist_verify
setopt inc_append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_space

setopt SHARE_HISTORY
setopt APPEND_HISTORY

setopt auto_cd
setopt multios
setopt cdablevarS

autoload colors; colors;
# }}}
# application configuration {{{
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
export PAGER=less
export LESS="-r"
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Enable ls colors
# Find the option for using colors in ls, depending on the version: Linux or BSD
  ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'

export EDITOR=vim
which nvim &> /dev/null && which nvim.py &> /dev/null && export EDITOR=nvim.py
# }}}
# Completion {{{
unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

WORDCHARS=''

autoload -U compinit
compinit -i

zmodload -i zsh/complist

## case-insensitive (all),partial-word and then substring completion
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

zstyle ':completion:*' list-colors ''

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# use /etc/hosts and known_hosts for hostname completion
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}} } || _etc_hosts=()
hosts=(
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh-cache/

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
        dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
        hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
        mailman mailnull mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
        operator pcap postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# ... unless we really want to.
zstyle '*' single-ignored show
# }}}
# git {{{
alias g='git'
alias gl='git clone'
alias gs='git status -s -b'
alias gc='git commit -av'
alias gca='git commit -av --amend'
alias gcm='git commit -v'
alias gcma='git commit -v --amend'
alias gd='git diff'
alias gds='git --no-pager diff --stat'
alias gdh='git diff HEAD'
alias gdp='git diff HEAD^'
alias gda='git diff origin/master...HEAD' #closest common ancestor
alias gdc='git diff --cached'
alias gco='git checkout'
alias gb='git branch'
alias gcb='git checkout -b'
alias ga='git add'
alias gau='git add -u'
alias gap='git add -p'
alias gan='git add -N'
alias grm='git rm'
alias grmc='git rm --cached'
alias gmv='git mv'
alias gm='git merge'
alias gh='git push'
alias ghu='git push -u'
alias ghrr='git push --force-with-lease' # intensionally a bit difficult...
alias gpo='gp -u origin HEAD'
alias gu='git pull'
alias gur='git pull --rebase'
alias gt='git fetch'
alias gg='git log'
alias ggs='git log -S'
alias gst='git stash'
alias gr='git reset'
alias grh='git reset --hard'
alias grhu='git reset --hard @{upstream}'
alias gri='git rebase -i'
alias grim='git rebase -i master'
alias grom='git rebase -i origin/master'
alias grc='git rebase --continue'
alias grac='git add -u && git rebase --continue'
alias gra='git rebase --abort'
alias ge='git remote -v'
alias gcp='git cherry-pick --allow-empty'

gbd () {
    for k in `git branch | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort
    }

revclone() {
    ssh $1 "sleep 10" &
    sleep 0.7
    ssh $1 "which git" || return
    git remote add origin $1:$2 || return
    if ssh $1 "[[ ! -e $2 ]] && mkdir -p $2 && cd $2 && git init && git checkout -b local"; then
        git push --all -u origin
        ssh $1 " cd $2 && git reset --hard master"
    else
        git remote rm origin
    fi
}

alias hub=/usr/bin/gh
alias hl="hub repo clone"
alias hk="hub repo fork fork"
#lias hc="hub create"
#alias hme="hub remote add -p bfredl"
#lias hco='hub checkout'

git_current_branch() {
    git status &> /dev/null || return
    if ref=$(git symbolic-ref HEAD 2> /dev/null); then
        echo ${ref#refs/heads/}
    else
        echo ""
    fi
}
git_is_dirty() {
    [[ -n $(git status --porcelain -uno 2> /dev/null) ]]
}

git_has_untracked() {
    git status --porcelain 2>/dev/null| grep "^??" &> /dev/null
}

git_incoming_commits() {
    tracking_branch=$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD))
    git rev-list --left-only --count $tracking_branch...HEAD 2> /dev/null
}
git_outgoing_commits() {
    tracking_branch=$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD))
    git rev-list --right-only --count $tracking_branch...HEAD 2> /dev/null
}
# }}}
# prompt {{{
setopt prompt_subst
setopt long_list_jobs
# FX FG BG {{{
typeset -Ag FX FG BG

FX=(
    reset     "%{[00m%}"
    bold      "%{[01m%}" no-bold      "%{[22m%}"
    italic    "%{[03m%}" no-italic    "%{[23m%}"
    underline "%{[04m%}" no-underline "%{[24m%}"
    blink     "%{[05m%}" no-blink     "%{[25m%}"
    reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

for color in {000..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done
# }}}zo
# hostname color HNCOLOR % {{{
if [[ $UID == 0 ]]; then
    HNCOLOR=$fg_bold[red]
elif [[ "$SSH_TTY" != "" ]]; then
  HNCOLOR=$fg_bold[white]$bg_bold[black]
else
    HNCOLOR=$fg_bold[magenta]
fi
# }}}

PROMPT='%{$HNCOLOR%}%m%{$reset_color%} $(git_prompt_info)%{$fg_bold[blue]%}%c%{$reset_color%}%(0?.. %{$fg_bold[yellow]%}%?%{$reset_color%})%# '
RPS1='$(vi_mode_prompt_info)'

# vi prompt {{{

MODE_INDICATOR="%{$fg_bold[red]%}<%{$fg[red]%}<<%{$reset_color%}"

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}
# }}}
# git prompt {{{
GIT_PROMPT_PREFIX=""
GIT_PROMPT_SUFFIX="%{$reset_color%}:"
GIT_PROMPT_DIRTY="%{$fg_bold[red]%}"
GIT_PROMPT_DETACHED="%{$fg_bold[yellow]%}"
GIT_PROMPT_CLEAN="%{$fg_bold[green]%}"
GIT_PROMPT_INCOMING="%{$fg_bold[red]%}>"
GIT_PROMPT_OUTGOING="%{$fg_bold[red]%}<"
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}?"
# get the name of the branch we are on
git_prompt_info() {
    branch=$(git_current_branch) || return
    echo -n "$GIT_PROMPT_PREFIX"
    if [[ $(git_incoming_commits) > 0 ]]; then
        echo -n "$GIT_PROMPT_INCOMING"
    fi
    if [[ $(git_outgoing_commits) > 0 ]]; then
        echo -n "$GIT_PROMPT_OUTGOING"
    fi
    if git_is_dirty; then
        echo -n "$GIT_PROMPT_DIRTY"
    elif [[ -z $branch ]]; then
        echo -n "$GIT_PROMPT_DETACHED"
    else
        echo -n "$GIT_PROMPT_CLEAN"
    fi
    [[ -z $branch ]] && branch="(none)"
    echo -n $branch
    if git_has_untracked; then
        echo -n "$GIT_PROMPT_UNTRACKED"
    fi
    echo $GIT_PROMPT_SUFFIX
}

# }}}
# }}}
# correction {{{
#setopt correct_all
unset CORRECT

alias man='nocorrect man'
alias mv='nocorrect mv'
alias mkdir='nocorrect mkdir'
alias cp='nocorrect cp'
# }}}
#Keybindings {{{
function zle-line-init zle-keymap-select {
  zle reset-prompt
  case "$TERM" in
      xterm*|rxvt*)
          if [ $KEYMAP = vicmd ]; then
              echo -ne "\033[2 q"
          else
              echo -ne "\033[5 q"
          fi
          ;;
  esac
}

zle -N zle-line-init
zle -N zle-keymap-select

bindkey -v

autoload -U compinit
compinit -i

bindkey '^L' push-line
bindkey '^O' copy-prev-shell-word
bindkey '^?' backward-delete-char
bindkey '^R' history-incremental-search-backward
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history

bindkey '^[[1~' vi-beginning-of-line   # Home
bindkey '^[[7~' vi-beginning-of-line   # Home
bindkey '^[[4~' vi-end-of-line         # End
bindkey '^[[8~' vi-end-of-line         # End
bindkey '^[[2~' beep                   # Insert
bindkey '^[[3~' delete-char            # Del
bindkey '^[[5~' vi-backward-blank-word # Page Up
bindkey '^[[6~' vi-forward-blank-word  # Page Down

# This reversal feels more logical to me
bindkey '^[[B' down-line-or-history
bindkey '^[[A' up-line-or-history
bindkey -M vicmd 'j' vi-down-line-or-history
bindkey -M vicmd 'k' vi-up-line-or-history

bindkey -s "^E" "^V\n"

# the good times are comming for everyone
bindkey -s "^[[32;2u" " "
# }}}
# title handling {{{
function title {
    case "$TERM" in
      xterm*|rxvt*)
        print -nR $'\033]0;'$2$'\a'
        ;;
      screen*)
        print -nR $'\033k'$1$'\033\\'
        print -nR $'\033]0;'$2$'\a'
        ;;
    esac
}

function precmd {
  if [[ "$SSH_TTY" != "" ]]; then
      if [[ "$USER" = "atf10bli" ]]; then
          title zsh "`print -Pn '['%m']' %~`"
      else
          title zsh "`print -Pn %n@%m: %~`"
      fi
  else
      title zsh "`print -Pn %\# %~`"
  fi

}

function preexec {
  emulate -L zsh
  local -a cmd; cmd=(${(z)1})
  #title $cmd[1]:t "`print -Pn %n@%m: $1\a`"  # xterm
  title $cmd[1]:t $1
  case "$TERM" in
      xterm*|rxvt*)
          echo -ne "\033[2 q"
  esac

}
# }}}
if [[ -e ~/.zshrc_local ]]; then
    source ~/.zshrc_local
fi
