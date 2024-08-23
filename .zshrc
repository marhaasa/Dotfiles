# ~~~~~~~~~~~~~~~ SSH ~~~~~~~~~~~~~~~~~~~~~~~~



# ~~~~~~~~~~~~~~~ Environment Variables ~~~~~~~~~~~~~~~~~~~~~~~~


# Set to superior editing mode

set -o vi

export VISUAL=nvim
export EDITOR=nvim
export TERM="tmux-256color"

# export BROWSER="firefox"

# Directories

export REPOS="$HOME/Repos"
export GITUSER="marhaasa"
export GHREPOS="$REPOS/github.com/$GITUSER"
export DOTFILES="$GHREPOS/Dotfiles"
export SCRIPTS="$DOTFILES/scripts"
export ICLOUD="$HOME/icloud"
export NOTES="$HOME/notes"


# ~~~~~~~~~~~~~~~ Path configuration ~~~~~~~~~~~~~~~~~~~~~~~~


setopt extended_glob null_glob

path=(
    $path                           # Keep existing PATH entries
    $HOME/bin
    $HOME/.local/bin
    $SCRIPTS
    /opt/homebrew/bin
    /Users/mariushogliaasarod/Library/Caches/pypoetry/virtualenvs/zettelkasten-cli-gtRlR78O-py3.12/bin
)

# Remove duplicate entries and non-existent directories
typeset -U path
path=($^path(N-/))

export PATH


# ~~~~~~~~~~~~~~~ History ~~~~~~~~~~~~~~~~~~~~~~~~


HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_SPACE  # Don't save when prefixed with space
setopt HIST_IGNORE_DUPS   # Don't save duplicate lines
setopt SHARE_HISTORY      # Share history between sessions


# ~~~~~~~~~~~~~~~ Prompt ~~~~~~~~~~~~~~~~~~~~~~~~


PURE_GIT_PULL=0


if [[ "$OSTYPE" == darwin* ]]; then
  fpath+=("$(brew --prefix)/share/zsh/site-functions")
else
  fpath+=($HOME/.zsh/pure)
fi

autoload -U promptinit; promptinit
prompt pure


# ~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~

sintef() {
  "cd /Users/Shared/repos/Sintef/Power BI/"
  "nvim"
}
# cd
alias ..="cd .."
alias repos="cd /Users/Shared/repos"
alias home="cd $HOME"
alias notes="cd $NOTES"
alias icloud="cd \$ICLOUD"
alias dot="cd \$DOTFILES"
# ls
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -lathr'

# programs
alias t='tmux'
alias python="python3"
alias v=nvim

# finds all files recursively and sorts by last modification, ignore hidden files
alias lastmod='find . -type f -not -path "*/\.*" -exec ls -lrt {} +'

# git
alias gp='git pull'
alias gs='git status'
alias lg='lazygit'

# fun
alias fishies=asciiquarium

# history
alias hist='history 0 | fzf'
alias hy="
  fc -ln 0 |
  awk '!a[\$0]++' |
  fzf --tac --multi --header 'Copy history' |
  pbcopy
"


# ~~~~~~~~~~~~~~~ Sourcing ~~~~~~~~~~~~~~~~~~~~~~~~
source <(fzf --zsh)


# ~~~~~~~~~~~~~~~ Functions ~~~~~~~~~~~~~~~~~~~~~~~~
# This function is stolen from rwxrob

clone() {
  local repo="$1" user name userd path
  repo="${repo#https://github.com/}"
  repo="${repo#git@github.com:}"
  if [[ $repo == */* ]]; then
    user="${repo%%/*}"
  else
    user="$GITUSER"
    [[ -z "$user" ]] && user="$USER"
  fi
  name="${repo##*/}"
  userd="$REPOS/github.com/$user"
  path="$userd/$name"
  
  echo "Debug: repo=$repo, user=$user, name=$name, userd=$userd, path=$path"
  
  # Ensure PATH is set correctly
  export PATH="/bin:/usr/bin:/usr/local/bin:/opt/homebrew/bin:$PATH"
  
  # Use command substitution to find full paths
  local mkdir_cmd=$(command -v mkdir)
  local gh_cmd=$(command -v gh)
  
  # Use full path for mkdir
  if [[ ! -d "$REPOS/github.com" ]]; then
    echo "Base directory $REPOS/github.com does not exist. Creating it..."
    $mkdir_cmd -p "$REPOS/github.com"
  fi
  
  if [[ ! -d "$userd" ]]; then
    echo "User directory $userd does not exist. Creating it..."
    $mkdir_cmd -p "$userd"
  fi
  
  if [[ -d "$path" ]]; then
    cd "$path" && return
  fi
  
  cd "$userd"
  echo "Running: gh repo clone $user/$name -- --recurse-submodule"
  $gh_cmd repo clone "$user/$name" -- --recurse-submodule
  cd "$name"
}

functions -M clone


# ~~~~~~~~~~~~~~~ Completion ~~~~~~~~~~~~~~~~~~~~~~~~


fpath+=~/.zfunc

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

autoload -Uz compinit
compinit -u

zstyle ':completion:*' menu select

# added to support case insensitive tab completion for cd
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'



# Example to install completion:
# talosctl completion zsh > ~/.zfunc/_talosctl


# ~~~~~~~~~~~~~~~ Misc ~~~~~~~~~~~~~~~~~~~~~~~~
