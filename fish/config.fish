alias cdw="cd ~/Documents/workspace"
alias cdcg="cd ~/Documents/workspace/cg"
alias cdcar="cd ~/Documents/workspace/car"
alias ll='ls -al'

# goenv
set -x GOPATH $HOME/Documents/workspace/gopath
set -x PATH $PATH $GOPATH/bin
eval (goenv init - | source)

# pyenv
set -x PYENV_ROOT $HOME/.pyenv
set -x PATH $PATH $PYENV_ROOT/bin
eval (pyenv init - | source)

# pyenv-virtualenv
status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source

function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'
  bind \cg 'peco_select_ghq_repository'
end

set -U GHQ_SELECTOR peco

source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc'
