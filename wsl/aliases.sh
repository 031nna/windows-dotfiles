#  ---------------------------------------------------------------------------
#
#  Description: My aliases and quick functions
#
#  Sections:
#  1.
#  2.   Make Terminal Better (remapping defaults and adding functionality)
#  3.   File and Folder Management
#  4.   Searching
#  5.   Process Management
#  6.   Networking
#  7.   System Operations & Information
#  8.   Web Development
#  9.   GIT
#  10. servers
#  11.  Playground
#
#  ---------------------------------------------------------------------------
#   -----------------------------
#   1.
#   -----------------------------

#   -----------------------------
#   2.  MAKE TERMINAL BETTER
#   -----------------------------

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias rm='rm -i'                            # makes 'rm' interactive and safe.
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ls='ls -lhpa'                         # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
cd() { builtin cd "$@"; ls; }               # Always list directory contents upon 'cd'
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias ob='o-urls-read'
alias godsghost="cd ${APP_DEV_PATH}/godsghost"
alias o-stripe-run="stripe listen --forward-to 127.0.0.1:8088/payments/webhook"
alias giggl='o-giggl-urls-read'
alias edit='vim'                            # edit:         Opens any file in vim editor
alias o-openfinder-MacOs='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display
alias which='type -all'                     # which:        Find executables
alias o-show-executable-paths='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop
alias pst='phpstorm'

#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#   -------------------------------
#   3.  FILE AND FOLDER MANAGEMENT
#   -------------------------------

alias numFiles='echo $(ls -1 | wc -l)'      # numFiles:     Count of non-hidden files in current dir
alias o-make1mb='fallocate -l 1M 1M.txt'         # make1mb:      Creates a file of 1mb size (all zeros)
alias o-make5mb='fallocate -l 5M 5M.txt'         # make5mb:      Creates a file of 5mb size (all zeros)
alias o-make10mb='fallocate -l 10M 10M.txt'      # make10mb:     Creates a file of 10mb size (all zeros)
alias oo="cd ~/Documents/Projects"
alias dotfiles="cd ~/dotfiles"
# alias o-tailscale-up=""

o-open-file() { xdg-open $1;}

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias o-emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

#   cdf:  'Cd's to frontmost window of MacOS Finder
#   ------------------------------------------------------
    cdf () {
        currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
        )
        echo "cd to \"$currFolderPath\""
        cd "$currFolderPath"
    }


#   ---------------------------
#   4.  SEARCHING
#   ---------------------------

alias qfind="find . -name "                 # qfind:    Quickly search for file

#   ---------------------------
#   5.  PROCESS MANAGEMENT
#   ---------------------------

#   o-findPid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   -----------------------------------------------------
o-findPid () { lsof -t -c "$@" ; }

#   memHogsTop, memHogsPs:  Find memory hogs
#   -----------------------------------------------------
alias memHogsTop='top -l 1 -o rsize | head -20'
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
#   -----------------------------------------------------
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   topForever:  Continual 'top' listing (every 10 seconds)
#   -----------------------------------------------------
alias topForever='top -l 9999999 -s 10 -o cpu'

#   ttop:  Recommended 'top' invocation to minimize resources
#   ------------------------------------------------------------
#       Taken from this macosxhints article
#       http://www.macosxhints.com/article.php?story=20060816123853639
#   ------------------------------------------------------------
alias o-ttop="top -R -F -s 10 -o rsize"

#   o-my_processes: List processes owned by my user:
#   ------------------------------------------------------------
o-my_processes() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

#   ---------------------------
#   6.  NETWORKING
#   ---------------------------
# IP addresses
alias o-myip="dig +short myip.opendns.com @resolver1.opendns.com"  # myip:         Public facing IP Address
alias o-localip="ifconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias o-flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias o-show-OpenUDPports='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias o-show-OpenTCPports='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias o-ipInfo-ifconf='ifconfig'              # ipInfo1:      Get info on connections for en1
alias o-show-openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias o-showBlocked-ips='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

#Displaying iptables information the easy way
# gotten from https://linuxhandbook.com/linux-alias-command/
alias o-show-IPtableRulesList='sudo /sbin/iptables -L -n -v --line-numbers'           #this will display all lines of your current iptables
alias o-show-incomingIPtableRules='sudo /sbin/iptables -L INPUT -n -v --line-numbers'   #this will display all your INCOMING rules in iptables
alias o-show-outgoingIPtableRules='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers' #this will display all your OUTGOING rules in iptables


#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
o-system-info() {
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    # echo -e "\n${RED}Current network location :$NC " ; scselect
    echo -e "\n${RED}Public facing IP Address :$NC " ;o-myip
    #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
    echo
}


#   ---------------------------------------
#   7.  SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------
alias o-tail_log="tail -n0 -F"
alias o-tail_log-chatbot="o-chatbot_log" # tail_logC:       tail codeigniter app
alias o-npm-watch_file="npm run dev && npm run watch-poll"    # watch_file:       watch files during frontend development
alias o-apacheEdit='sudo edit /etc/httpd/httpd.conf'      # apacheEdit:       Edit httpd.conf
alias o-apacheRestart="sudo service apache2 restart"      # apacheRestart:    Restart Apache
alias o-editHostsFile='sudo edit /etc/hosts'                  # editHosts:        Edit /etc/hosts file
alias o-tail_log_http_errorlog='tail /var/log/httpd/error_log'              # herr:             Tails HTTP error logs
alias o-composer_dump_autoload="composer dump-autoload -o"
alias o-tail_log_apacheLogs="less +F /var/log/apache2/error_log"   # Apachelogs:   Shows apache error logs
alias o-reloadTerminal="exec ${SHELL} -l"
alias o-npm-install="npm cache clean --force && npm install --legacy-peer-deps"
# "npm config set legacy-peer-deps true && npm cache clean --force"

#   ---------------------------------------
#   9.  GIT SHORTCUTS
#   ---------------------------------------
alias git-log-pretty-oneline="git log --pretty=oneline"
alias gls="log --pretty=format:'%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]' --decorate"
alias gs="git status"
alias git-standup="git standup"
alias grhh="git reset HEAD --hard"
alias git-cleanbranch='git branch --merged | grep -vE "(^\*|master|main)" | xargs git branch -D' # deletes branches except master in local git
alias git-changes="git log --no-merges --raw --since='2 weeks ago'"
alias git-diff="git diff --name-only | uniq | xargs $EDITOR"  # open merge conflicts in chosen editor
alias git-commitbyauthor="git shortlog"                            # commits grouped per author
alias git-short-log="git shortlog -s -n --all --no-merges"   # number of commits per author on all branches
alias git-log-pretty="git log --pretty=oneline --graph --decorate --all"    # Visualize the version tree.
alias git-push-force-with-lease="git push --force-with-lease"
alias git-pull-master-origin="git pull origin master --allow-unrelated-histories"
alias git-rebase-commits="git-squash-commits"

#   ---------------------------------------
#   10.  My servers
#   ---------------------------------------
alias o-server-jf="ssh root@$JF_SERVER"

# Dev machine app paths
alias apps="cd $APP_DEV_PATH"

# docker
alias o-docker-restart-all="docker restart $(docker ps -a -q)"
alias o-docker-start-docker-macOS="open --background -a Docker"
alias o-dcu-hard="o-dcd;o-docker-clean;o-dcu"
alias o-dcu="o-docker-compose-up"
alias o-dcd="o-docker-compose-down" 
alias o-dcs="docker compose stop" 

alias o-ansible_update-hosts="o-update_ansible_hosts"
alias o-cors-error-chrome="google-chrome --disable-site-isolation-trials --disable-web-security --allow-file-access-from-files --user-data-dir='~/tmp'"

# kubernetes/minikube
alias o-kubectl-get-node="kubectl get node"
alias o-kubectl-describe-pod="kubectl describe pod"
alias o-kubectl-delete-all-pods="kubectl delete pods --all --all-namespaces"
alias o-kubectl-destroy-all-resources="kubectl delete all --all; minikube delete"
alias o-minikube-status="minikube status"
alias o-minikube-stop="minikube stop; minikube delete; docker stop $(docker ps -q --filter "name=k8s_") ; 
 docker rm -f $(docker ps -a -q --filter "name=k8s_"); minikube delete --all"

# set vagrant exec for windows
if [[ -d ${WINDOWS_MOUNT_PATH} ]]; then
    alias vagrant="vagrant.exe"
    alias VBoxManage="VBoxManage.exe"
fi
 