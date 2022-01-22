# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"


# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  colored-man-pages
  # ssh-agent
  bgnotify
  rsync
  command-not-found
  zsh-interactive-cd
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# zstyle :omz:plugins:ssh-agent identities id_rsa

source $ZSH/oh-my-zsh.sh
source $(dirname $(gem which colorls))/tab_complete.sh
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS
setopt NULL_GLOB
unsetopt PROMPT_SP

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
[[ -d ~/.automaticScripts ]] && PATH=${PATH}${PATH:+:}~/.automaticScripts
[[ -d ~/.local/bin ]] && PATH=${PATH}${PATH:+:}~/.local/bin
[[ -d ~/.local/sbin ]] && PATH=${PATH}${PATH:+:}~/.local/sbin
[[ -d ~/bin ]] && PATH=${PATH}${PATH:+:}~/bin
[[ -d ~/sbin ]] && PATH=${PATH}${PATH:+:}~/sbin

export PATH

_change_dir() {
  dirtomove=$(ls | fzf)
  cd "$dirtomove"
}

_reverse_search(){
  local selected_command=$(fc -rl 1 | awk '{$1="";print substr($0,2)}' | fzf)
  LBUFFER=$selected_command
}

_show_open_files(){
  selected=$(ps axc | awk 'NR > 1' | awk '{print substr($0,index($0,$5))}' | sort -u | fzf)

  if [ ! -z $1 ]; then
    lsof -r 2 -c "$selected"
  else
    lsof -c "$selected"
  fi
}

_add_ssh(){
  eval $(ssh-agent -s)
  ssh-add ~/.ssh/id_rsa
  ssh-add ~/.ssh/id_rsa_rappi
  ssh-add ~/.ssh/id_rsa_avalith
}

zle -N _change_dir
bindkey '^h' _change_dir

zle -N _reverse_search
bindkey '^r' _reverse_search

zle -N _show_open_files

zle -N _add_ssh

# FIXES! DO NOT CHANGE
alias man='nocorrect man '
alias mv='nocorrect mv '
alias mv='nocorrect cp '
alias mysql='nocorrect mysql '
alias mkdir='nocorrect mkdir '
alias sudo='nocorrect sudo '
if [[ -f /usr/bin/batcat ]]; then
  alias bat='batcat'
fi

# ALIAS COMMANDS
# alias l='colorls -lah --sd'
# alias la='colorls -lAh --sd'
# alias lc='colorls -lAh --sd'
# alias ll='colorls -lh --sd'
# alias ls='colorls --sd'
# alias lsa='colorls -lah --sd'

alias uos='sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove'
alias uzsh='bash ~/.dotfiles/update.sh && omz update && src'
alias pzsh='cd ~/.dotfiles && git pull && bash ~/.dotfiles/update.sh && omz update && src'

alias open='xdg-open'
alias cdc='cd ~/code'
alias c='code .'

alias ls="exa --icons --group-directories-first"
alias ll="exa --icons --group-directories-first -l"
alias grep='grep --color'

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Goto
[[ -s "/usr/local/share/goto.sh" ]] && source /usr/local/share/goto.sh

# NVM lazy load
# if [ -s "$HOME/.nvm/nvm.sh" ]; then
#   [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
#   alias nvm='unalias nvm node npm && . "$NVM_DIR"/nvm.sh && nvm'
#   alias node='unalias nvm node npm && . "$NVM_DIR"/nvm.sh && node'
#   alias npm='unalias nvm node npm && . "$NVM_DIR"/nvm.sh && npm'
# fi

# Fix Interop Error that randomly occurs in vscode terminal when using WSL2
fix_wsl2_interop() {
    for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
        if [[ -e "/run/WSL/${i}_interop" ]]; then
            export WSL_INTEROP=/run/WSL/${i}_interop
        fi
    done
}

# Colormap
function colormap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}


# find out which distribution we are running on
_distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')

# set an icon based on the distro
case $_distro in
    *kali*)                  ICON="ﴣ";;
    *arch*)                  ICON="";;
    *debian*)                ICON="";;
    *raspbian*)              ICON="";;
    *ubuntu*)                ICON="";;
    *elementary*)            ICON="";;
    *fedora*)                ICON="";;
    *coreos*)                ICON="";;
    *gentoo*)                ICON="";;
    *mageia*)                ICON="";;
    *centos*)                ICON="";;
    *opensuse*|*tumbleweed*) ICON="";;
    *sabayon*)               ICON="";;
    *slackware*)             ICON="";;
    *linuxmint*)             ICON="";;
    *alpine*)                ICON="";;
    *aosc*)                  ICON="";;
    *nixos*)                 ICON="";;
    *devuan*)                ICON="";;
    *manjaro*)               ICON="";;
    *rhel*)                  ICON="";;
    *)                       ICON="";;
esac

export STARSHIP_DISTRO="$ICON "
export IP="$(dig +short myip.opendns.com @resolver1.opendns.com)"
# export IP="$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')"

# Load Starship
eval "$(starship init zsh)"
