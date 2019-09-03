#!/usr/bin/env bash

# cd aliases
alias cdh="cd ~"
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../'

# fs info aliases
# TODO: Fix unsupported --color for mac os
alias ls="ls --color=auto"
alias l="ls -lh"
alias ll="ls -lhA"
alias l.="ls -lhAd .*"
alias duof='du --max-depth=1 -h'

# Search
alias f='find . -iname'
alias ff='find . -type f -iname'
alias fd='find . -type d -iname'
alias g='grep . -ri -e'

# Other
alias hh='ak.bash.history'
alias j='jobs -l'
alias rr="rm -rf"
alias e="exit"
alias v="vim"
alias gpn="ak.git.push --no-verify"
alias akhelp="ak.bash.showConfig"

# Inet
alias ic="ak.inet.check; echo; ak.inet.ping.DNS"
alias ip='echo -e "IPv4: $(ak.inet.getExternalIPv4)\nIPv6: $(ak.inet.getExternalIPv6)"'
