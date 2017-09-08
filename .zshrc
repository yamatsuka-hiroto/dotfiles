#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
# http://webtech-walker.com/archive/2008/12/15101251.htmlを参考
eval "$(rbenv init -)"

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/Users/a13184/.gvm/bin/gvm-init.sh" ]] && source "/Users/a13184/.gvm/bin/gvm-init.sh"

# UTF-8
export LANG=ja_JP.UTF-8

# alias
alias ll='ls -al'
alias emacsclient='/usr/local/Cellar/emacs/24.3/bin/emacsclient'
alias E='emacsclient -t'
alias kill-emacs="emacsclient -e '(kill-emacs)'"
alias Emacs='/usr/local/Cellar/emacs/24.3/Emacs.app/Contents/MacOS/Emacs'
# 僕は後述の物を全部付けてます（-L 以外）
export LESS='-g -i -M -R -S -W -z-4 -x4'

# Emacs ライクな操作を有効にする（文字入力中に Ctrl-F,B でカーソル移動など）
# Vi ライクな操作が好みであれば `bindkey -v` とする
bindkey -e

# alias 
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ll='ls -al'
alias cdcar='cd /Users/a13184/Documents/workspace/car/'
alias cdupm='cd /Users/a13184/Documents/workspace/gopath/src/github.com/car-upm/'
alias cdw='cd /Users/a13184/Documents/workspace/'
# 自動補完を有効にする
autoload -Uz compinit && compinit -i
compinit

# 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する
# コマンド履歴とは今まで入力したコマンドの一覧のことで、上下キーでたどれる
setopt hist_ignore_all_dups

# <Tab> でパス名の補完候補を表示したあと、
# 続けて <Tab> を押すと候補からパス名を選択できるようになる
# 候補を選ぶには <Tab> か Ctrl-N,B,F,P
zstyle ':completion:*:default' menu select=1

# カレントディレクトリ、ユーザ名を2行で表示
autoload colors
colors

# 表示フォーマットの指定
# %b ブランチ情報
# %a アクション名(mergeなど)
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

# バージョン管理されているディレクトリにいれば表示，そうでなければ非表示
#RPROMPT="%1(v|%F{green}%1v%f|)"

# 履歴
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups
setopt share_history
setopt hist_ignore_space
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# cdの設定
setopt auto_cd

# タイトル
case "${TERM}" in
kterm*|xterm)
  precmd() {
    echo -ne "\033]0;${USER}@${HOST}\007"
  }
  ;;
esac

# 色の設定
export LSCOLORS=gxfxxxxxcxxxxxxxxxgxgx
export LS_COLORS='di=01;36:ln=01;35:ex=01;32'
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'ex=32'

#ビープ音ならなさない
setopt nobeep

#エディタ
export EDITOR=vim

#改行のない出力をプロンプトで上書きするのを防ぐ
unsetopt promptcr

# VCSの情報を取得するzshの便利関数 vcs_infoを使う
autoload -Uz vcs_info

export PATH=$HOME/.rbenv/bin:$PATH
export PATH=$PATH:$HOME/bin:/usr/local/mysql/bin
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export SCALA_HOME=/usr/local/share/scala-2.11.2
export PATH=$PATH:$SCALA_HOME/bin
# golang
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=/Users/a13184/Documents/workspace/gopath
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin
# rust
export PATH=$PATH:$HOME/.cargo/bin
# pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval "$(direnv hook zsh)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export WORKON_HOME=~/.virtualenvs


export NVM_DIR="$HOME/.nvm" 
 . "$(brew --prefix nvm)/nvm.sh"
# The next line updates PATH for the Google Cloud SDK.
source '/Users/a13184/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
source '/Users/a13184/google-cloud-sdk/completion.zsh.inc'

# istio
export PATH=$PATH:/Users/a13184/Documents/workspace/istio-0.1.6/bin

# stern
source <(stern --completion=zsh)

# kubernetes
source <(kubectl completion zsh)

fpath=(/usr/local/share/zsh-completions $fpath)

if which lesspipe.sh > /dev/null; then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

# peco & ghq
setopt hist_ignore_all_dups

function peco_select_history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco_select_history
bindkey '^r' peco_select_history

function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^g' peco-src
