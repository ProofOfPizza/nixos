
''
  HISTSIZE="10000"
  HISTSAVE="10000"
  HISTFILE="/home/chai/zsh_history"
  setopt HIST_FCNTL_LOCK
  setopt HIST_IGNORE_DUPS
  setopt HIST_IGNORE_SPACE
  setopt HIST_EXPIRE_DUPS_FIRST
  setopt SHARE_HISTORY
  export FZF_DEFAULT_OPTS="-m"
  FZF_DEFAULT_OPTS+=" --color='light'"
  FZF_DEFAULT_OPTS+=" --bind 'ctrl-/:toggle-preview'"
  FZF_DEFAULT_OPTS+=" --preview 'head -500 {}' --height 80%"
  FZF_DEFAULT_OPTS+=" --preview-window=up:40%:hidden"
  FZF_DEFAULT_OPTS+=" --height=80%"
  FZF_DEFAULT_OPTS+=" --layout=reverse"
  FZF_DEFAULT_OPTS+=" --border"
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

  alias authaws='_authaws(){bash ~/.config/nixpkgs/scripts/aws-set-auth.sh "$1" && . ./tmp.env && rm ./tmp.env;}; _authaws'

  export KEYTIMEOUT=1

  # Change cursor shape for different vi modes.
  function zle-keymap-select {
    if [[ ''\${KEYMAP} == vicmd ]] ||
      [[ $1 = 'block' ]]; then
      echo -ne '\e[1 q'
    elif [[ ''\${KEYMAP} == main ]] ||
        [[ ''\${KEYMAP} == viins ]] ||
        [[ ''\${KEYMAP} = "" ]] ||
        [[ $1 = 'beam' ]]; then
      echo -ne '\e[3 q'
    fi
  }
  zle -N zle-keymap-select
  zle-line-init() {
      echo -ne "\e[5 q"
  }
  zle -N zle-line-init
  echo -ne '\e[5 q' # Use beam shape cursor on startup.
  preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

  function awsl()
  {
    server=$1
    ssh_file=''\${2:-~/.ssh/devops.pem}
    login=ec2-user@$server
    echo $login
    ssh -i $ssh_file $login -y
  }

  function xclip_in()
  {
    cat $1 | xclip -i -selection clipboard
  }

  vicd()
  {
    local dst="$(command ~/.vifm/scripts/vifmrun "$@")"
    if [ -z "$dst" ]; then
      echo 'Directory picking cancelled/failed'
      return 1
    fi
    cd "$dst"
  }
  eval "$(direnv hook zsh)"
''
