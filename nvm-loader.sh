#!/usr/bin/env bash

# works faster then via brew
# http://broken-by.me/lazy-load-nvm/
# https://www.reddit.com/r/node/comments/4tg5jg/lazy_load_nvm_for_faster_shell_start/d5ib9fs/
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export __ak_nvm_isLoaded=0
export __ak_nvm_msgPrefix='NVM Loader:'
function _ak.nvm.load() {
  if [[ "$__ak_nvm_isLoaded" == "0" ]]; then
    export __ak_nvm_isLoaded=1

    local command="$1"; shift
    unset -f nvm node npm npx ng yarn

    if [[ "${command}" == "automatically" ]]; then
      echo "${__ak_nvm_msgPrefix} .nvmrc found --> Loading NVM ..."
    else
      echo "${__ak_nvm_msgPrefix} Loading ..."
    fi

    # This dir will contains node.js installations
    export NVM_DIR="$HOME/.nvm"
    if [[ ! -d "${NVM_DIR}" ]]; then
      mkdir "$NVM_DIR"
    fi

    local nvmShDir="$(realpath -e $(brew --prefix nvm))"
    local nvmShLoader="${nvmShDir}/nvm.sh"
    local nvmShCompletion="${nvmShDir}/etc/bash_completion.d/nvm"
    [[ -s "$nvmShLoader" ]]     && source "$nvmShLoader"
    [[ -s "$nvmShCompletion" ]] && source "$nvmShCompletion"

    # load .nvmrc from the current working directory in case it exists
    if [[ -f "$PWD/.nvmrc" ]]; then
      nvm use > /dev/null
      ak.nvm.version 1
    else
      ak.nvm.version 0
    fi

    if [[ ! -f "$(which node)" ]]; then
      return 1
    fi

    # execute only in case at least one argument passed
    if [[ "${1}" != "" ]]; then
      "${command}" "$@"
    fi
  fi
}

# automatically loading nvm on SHELL open in case .nvmrc found
function _ak.nvm.autoloadNvmRc() {
  if [[ -f "$PWD/.nvmrc" ]]; then
    _ak.nvm.load 'automatically'
  fi
}

function ak.nvm.version() {
  local isNvmRcUsed="${1:-unknown}"

  # TODO: Use global styles function after it will be implemented
  local style_Off='\033[0m' # Text Reset
  local style_Bold='\033[1m'
  local style_BoldRed='\033[1;31m'
  local style_BoldGreen='\033[1;32m'
  local cursorToPreviousLine='\e[1A'

  local nvmRcInfo=''
  if [[ "${isNvmRcUsed}" == "1" ]]; then
    nvmRcInfo=' (From .nvmrc)'
  elif [[ "${isNvmRcUsed}" == "0" ]]; then
    nvmRcInfo=' (Default)'
  fi

  if [[ -f "$(which node)" ]]; then
    echo -e "\r${cursorToPreviousLine}${__ak_nvm_msgPrefix} ${style_BoldGreen}Loaded${style_Off} --> " \
      "node: ${style_Bold}$(node --version)${style_Off}${nvmRcInfo}   " \
      "npm: ${style_Bold}$(npm --version)${style_Off}   " \
      "nvm: ${style_Bold}$(nvm --version)${style_Off}"
  else
    echo -e "${__ak_nvm_msgPrefix} ${style_BoldRed}Can not load NodeJS${style_Off}" >&2
  fi
}

function nvm()  { _ak.nvm.load nvm  "$@" }
function node() { _ak.nvm.load node "$@" }
function npm()  { _ak.nvm.load npm  "$@" }
function npx()  { _ak.nvm.load npx  "$@" }
function ng()   { _ak.nvm.load ng   "$@" }
function yarn() { _ak.nvm.load yarn "$@" }

_ak.nvm.autoloadNvmRc
