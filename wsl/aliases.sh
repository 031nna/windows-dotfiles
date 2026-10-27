#!/usr/bin/env bash

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gco='git checkout'

# Docker
alias d='docker'
alias dps='docker ps'
alias dc='docker compose'
alias dlogs='docker logs'

# Kubernetes
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgn='kubectl get nodes'
alias kctx='kubectl config current-context'

# Terraform
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'

# Linux
alias ll='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'