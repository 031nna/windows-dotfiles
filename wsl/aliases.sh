#!/usr/bin/env bash
#   Set base Paths
#   ------------------------------------------------------------
export PATH="$PATH:/mnt/c/Windows/System32/"  #for wsl ubuntu executables eg vagrant.exe up
export PATH="$PATH:/usr/local/bin/"
export PATH="/usr/local/git/bin:/sw/bin/:/usr/local/bin:/usr/local/:/usr/local/sbin:/usr/local/mysql/bin:$PATH"
export LD_PRELOAD=/lib/x86_64-linux-gnu/libstdc++.so.6 # pathfixfor GLIBCXX_3.4.29 error
#   Set custom path variables
#   ------------------------------------------------------------
export PROJECTS_PATH='Documents/Projects'
export DOTFILE_PATH='dotfiles'
export SSHFS_SERVER_PATH='Documents/Projects/Volumes'
export WINDOWS_MOUNT_PATH='/mnt/c/Users'
# allow vagrant executable in WSL
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
# export VAGRANT_WSL_ACCESS_WINDOWS_USER="0"
export CHROME_BROWSER_WSL="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
export BRAVE_BROWSER_WSL="/mnt/c/Users/meren/AppData/Local/BraveSoftware/Brave-Browser/Application/brave.exe"
export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox"
export LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH
export ANSIBLE_CONF_PATH='/etc/ansible'
export ANSIBLE_HOST_KEY_CHECKING=False
export PYTHON=python3