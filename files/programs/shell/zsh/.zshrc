# Enable Zsh options
setopt AUTO_CD
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY

# History settings
HISTSIZE=10000
HISTFILE="$HOME/.zsh_history"

# FZF configuration
export FZF_DEFAULT_OPTS="-m --color='light' --bind 'ctrl-/:toggle-preview' --preview 'head -500 {}' --height 80% --preview-window=up:40%:hidden --layout=reverse --border"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


# Set default keymap to viins (Vim mode)
bindkey -v


# Zsh completions
autoload -Uz compinit
compinit

# Cursor shape change for different vi modes
function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]] || [[ $1 == 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ $KEYMAP == main ]] || [[ $KEYMAP == viins ]] || [[ $KEYMAP == "" ]] || [[ $1 == 'beam' ]]; then
    echo -ne '\e[3 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q'; } # Use beam shape cursor for each new prompt.

# Custom functions
function awsl() {
  server=$1
  ssh_file=${2:-~/.ssh/devops.pem}
  login="ec2-user@$server"
  echo $login
  ssh -i $ssh_file $login -y
}

function xclip_in() {
  cat $1 | xclip -i -selection clipboard
}

function vicd() {
  local dst="$(command ~/.vifm/scripts/vifmrun "$@")"
  if [ -z "$dst" ]; then
    echo 'Directory picking cancelled/failed'
    return 1
  fi
  cd "$dst"
}

# Aliases
alias adab="cd ~/code/projects/adabtive && r"
alias cc="rm -rf ~/.config/Cypress"
alias cfb="vim ~/.bashrc"
alias cfi="vim ~/.config/nixpkgs/program/window-manager/i3/config"
alias cfv="vim ~/.config/nixpkgs/program/editor/neovim/default.nix"
alias cfx="vim ~/.Xresources"
alias cfz="vim ~/.config/nixpkgs/program/shell/zsh/default.nix"
alias conflicts="git diff --name-only --diff-filter=U"
alias die="pkill -i \$1 -f -e"
alias dstop="docker stop \$(docker ps -q); docker rm --force \$(docker ps -a -q); docker system prune -af --volumes"
alias dstopz="docker stop \$(docker ps -q); docker rm --force \$(docker ps -a -q)"
alias fzfi="rg --files --hidden --follow --no-ignore-vcs -g '!{node_modules,.git}' | fzf"
alias gd="cd ~/Downloads && r"
alias gdev="cd ~/code/projects && r"
alias gf="cd ~/code/Consular.Kairos.Frontend/src/Portals/kairos && r"
alias gh="cd ~ && r"
alias gn="cd ~/Nextcloud/Documents && r"
alias kk="kill -9 \$(pgrep KeeWeb)"
alias k="kubectl"
alias kswp="cd ~/.local/state/nvim/swap && rm *.* && ls -a"
alias nixos-rb="sudo nixos-rebuild switch -I nixos-config=/home/chai/.config/nixpkgs/system/configuration.nix"
alias nx="~/.config/nixpkgs"
alias nxo="nx && o"
alias nxr="nx && r"
alias o="x=\$(fzfi); if [[ ! -z \$x ]]; then vim \$x; fi"
alias p="cd ~/code/try-outs && python"
alias r="vicd ./";
alias reboot="dstop && shutdown -r now"
alias swp="cd ~/.local/state/nvim/swap && ls -a"
alias trash="cd ~/.local/share/Trash && r"
alias try="cd ~/code/try-outs && r"
alias vtrash="cd ~/.local/share/vifm/Trash && r"
alias vi='nvim'
alias vim='nvim'
alias vimii="x='/home/chai/.vim/pack/coc/start'; if [ ! -d '\$x' ]; then mkdir -p \$x && cd \$x && git clone 'git@github.com:neoclide/coc.nvim.git'; fi; echo 'check your vim alias for coc bs' && nvim"
alias x="exit"
alias xc="xclip_in"

# direnv hook
eval "$(direnv hook zsh)"
