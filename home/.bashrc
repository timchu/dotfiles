# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# begin tim changes
###### my shit
# alias askill="sudo pkill -KILL alphasheets-exe"
# alias kill-backend="askill; sudo pkill -KILL as-graph-server"
alias seas="bs; stack exec alphasheets-exe"
# alias npm="/home/user/.nvm/versions/node/v4.0.0/bin/npm"
# Timchu's aliases.
alias ac="bs; vi alphasheets.cabal"
alias bes="be; cd src/AS"
alias sv="be; cd graph-database; ./server"
alias pysv="be; cd pykernel; python server.py"
alias bs="bes"
alias ba="vi ~/.bashrc"
alias ld="source ~/.bashrc"
alias vm="vi ~/.vimrc"
export TERM="xterm-256color"
alias lf="ls -d */"
# Current item being worked on.
alias cur="bes; vi Dispatch/Core.hs"
function fin {
find . -name "*$1*"
}
function p {
grep -r -i "$1"
}
function fp { 
grep -r -i -l "$1"
}
function partialfilegrep { 
grep -r -i -l "$1" | head -3
}

# look for file containing haskell data or function definition.
function fo {
grep -r -i -l "\([A-z]*$1[A-z]\{0,5\} ::\\|data [A-z]\{0,4\}$1[A-z]*\\|type [A-z]\{0,4\}$1[A-z]*\)" | head -3
}

function fa {
grep -r -i "\([A-z]*$1[A-z]\{0,5\} ::\\|data [A-z]\{0,4\}$1[A-z]*\\|type [A-z]\{0,4\}$1[A-z]*\)" | head -3
}
function go {
vi "`fo "$1" | head -1`"
}

function repl {
find . -type f -exec sed -i "s/$1/$2/g" {} +
}

function newtab {
xdotool key ctrl+shift+t; 
}
function ce {
 cd "$1"
 clear
 ls
}
function cmmd {
 xdotool type --delay 1 "$1"
 xdotool key Return;
}
function backend {
 newtab
 cmmd "   bs; redis-server"
 newtab
 cmmd "   bs; redis-cli flushall"
 newtab
 cmmd "   bg; ./server"
 newtab
 cmmd "    seas"
 newtab
 cmmd "   pysv"
}

# newtab
# cmmd "bs; cd static; python file-input-handler.py"

function frontend {
 newtab
 cmmd "fe; npm start"
}

function run {
 backend
 frontend
}

function railsn {
  rails _5.0.0_ new "$1"
}

alias lightvim="perl -pi -e 's/set background=dark/set background=light/g' ~/.vimrc"
alias darkvim="perl -pi -e 's/set background=light/set background=dark/g' ~/.vimrc"
# Timchu's git aliases
alias gs="git status"
alias gcd="git checkout"
alias gaa="git add -A"
alias gpl="git pull"
function gcm {
git commit -m "$1"
}
alias xm="xmodmap ~/.Xmodmap"
alias gd="git diff"
alias gdn="git diff --name-only"

#alias sben="bs; stack bench --library-profiling --executable-profiling"
alias si="bes; stack install --fast"
alias gp="git pull --rebase"

alias ad="arc diff"_
alias adc="arc diff --create"
alias grc="git rebase --continue"
alias bmain="bs; vi bench/Main.hs"
alias main="bs; vi app/Main.hs"
alias py="be; cd as-libs/py/AS/"
alias pyd="py; cd data"
alias pyi="py; cd instruments"

# names to pahts in backend.
alias dc="bes; vi Dispatch/Core.hs"

alias grhead="git reset HEAD"
alias grhard="git reset --hard"
alias sg="stack ghci"
alias sgp="bs; stack ghci --library-profiling --executable-profiling"
alias sip="stack install --library-profiling --executable-profiling"
alias dark="~/gnome-terminal-colors-solarized/set_dark.sh; darkvim"
alias light="~/gnome-terminal-colors-solarized/set_light.sh; lightvim"
alias delswp="find . -type f -name '*\.swp' -delete"
alias delimg="bes; rm -rf ../../static/images/*"

alias pyRunDirectory="cd ~/alpha-sheets/backend/as-libs"
alias pks="py; vi kernel/serialize.py"
alias pfo="py; vi functions/openExcel.py"
alias ipy="pyRunDirectory; ipython --profile AS"
alias ipr="vi ~/.ipython/profile_AS/ipython_config.py"
alias vimprove="vi ~/vim_customization"
alias sheetjs="cat ~/demo/sheetJson|xclip -i -selection clipboard"
alias gtf="fe; gulp test-formula"
alias mc="vi ~/my-project/my-project.cabal"

alias lst="ls -t -1"

alias sag="sudo apt-get install"
alias seap="stack exec alphasheets-profiling-exe"
alias scra="vi  ~/scratch.hs"
alias bte="fe; vi int-tests/backend-test.js"
alias mp="cd ~/my-project/"
alias fm="p '<<<<'"
alias fm2="p '>>>>>'"
alias ti="python ~/python/timer.py"
alias pony="cd ~/tim/ponyfic"
alias tr="cd ~/js/trumpButton"
alias chr="cd ~/js/chromeExtension"

export PATH="$PATH:/home/timothy/somewhere/arcanist/bin/"
export PATH="$PATH:/home/timothy/.local/bin"
export PATH="$PATH:/usr/bin/python"
export PATH="$PATH:/usr/bin/"
export PATH="$PATH:/src"

export NVM_DIR="/home/timothy/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

PATH="$PATH:/home/timothy/flow/"

source "$HOME/.homesick/repos/homeshick/homeshick.sh"

alias tasks="vi ~/t/tasks.txt"
alias tas="vi ~/t/tasks.txt"
alias js="cd ~/js"
alias react="cd ~/js/react"
alias fluxchat="react; cd flux/examples/flux-chat/js"
alias fluxtest="react; cd fluxtest"
alias fluxtim="react; cd fluxtim"
alias wo="react; cd workflowy"
alias workflowy="wo"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"



### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
alias rs="rails server"
alias rn="railsn"
alias vact=". venv/bin/activate"
alias dact="deactivate"

function mkcd {
  mkdir "$1"; cd "$1"
}
function ginit {
  echo "https://github.com/timchu/${1}.git";
  git init;
  git remote add origin "https://github.com/timchu/${1}.git";
}

function gcm-init {
  gaa;
  gcm "$1";
  git branch --set-upstream-to origin/master;
  git push;
}

function gpup {
  git push --set-upstream origin master
}


# vi new
function vn {
  vi ~/t/"$1".txt
}

alias dti="vi ~/dailytaskimplement"
alias dt="vi ~/dailytask"
alias gp="gaa; gcm 'default commit'; git push"
alias journal="vi ~/t/journal"
alias j="journal"
alias refl="vi ~/t/reflection"
alias dailytask="vi ~/t/dailytask"
alias dt="dailytask"
alias dailytaskimplement="vi ~/t/dailytask"
alias dti="dailytaskimplement"
alias mun="evince ~/Downloads/Poor\ Charlie\'s\ Almanack_\ The\ Wit\ and\ Wisdom\ of\ Charles\ T.\ Munger\,\ Expanded\ Third\ Edition\ -\ Charles\ T.\ Munger.pdf&"
alias lsd="ls -d */"
alias lsf="ls --ignore='*/'"
alias app="python app.py"
alias ind="vi templates/index.html"
alias scr="vi ~/scraper/scraper.py"

xmodmap ~/.Xmodmap
