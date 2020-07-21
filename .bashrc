
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM='gnome-256color';
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM='xterm-256color';
fi;

prompt_git() {
	local s='';
	local branchName='';

	# Check if the current directory is in a Git repository.
	if [ "$(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}")" == '0' ]; then

		# check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

			if [[ -O "$(git rev-parse --show-toplevel)/.git/index" ]]; then
				git update-index --really-refresh -q &> /dev/null;
			fi;

			# Check for uncommitted changes in the index.
			if ! git diff --quiet --ignore-submodules --cached; then
				s+='+';
			fi;

			# Check for unstaged changes.
			if ! git diff-files --quiet --ignore-submodules --; then
				s+='!';
			fi;

			# Check for untracked files.
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?';
			fi;

			# Check for stashed files.
			if git rev-parse --verify refs/stash &>/dev/null; then
				s+='$';
			fi;

		fi;

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')";

		[ -n "${s}" ] && s=" [${s}]";

		echo -e "${1}${branchName}${blue}${s}";
	else
		return;
	fi;
}

cloud=""
if [[ -f /proc/cpuinfo ]] && grep -q "^flags.* hypervisor" /proc/cpuinfo && [[ ! -d "/mnt/c/Windows/" ]]; then
	cloud="☁️ "
fi

if tput setaf 1 &> /dev/null; then
	tput sgr0; # reset colors
	bold=$(tput bold);
	reset=$(tput sgr0);
	# Solarized colors, taken from http://git.io/solarized-colors.
	black=$(tput setaf 0);
	blue=$(tput setaf 33);
	cyan=$(tput setaf 37);
	green=$(tput setaf 64);
	orange=$(tput setaf 166);
	purple=$(tput setaf 125);
	red=$(tput setaf 124);
	violet=$(tput setaf 61);
	white=$(tput setaf 15);
	yellow=$(tput setaf 136);
else
	bold='';
	reset="\\e[0m";
	# shellcheck disable=SC2034
	black="\\e[1;30m";
	blue="\\e[1;34m";
	cyan="\\e[1;36m";
	green="\\e[1;32m";
	# shellcheck disable=SC2034
	orange="\\e[1;33m";
	# shellcheck disable=SC2034
	purple="\\e[1;35m";
	red="\\e[1;31m";
	violet="\\e[1;35m";
	white="\\e[1;37m";
	yellow="\\e[1;33m";
fi;

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="${red}";
else
	userStyle="${blue}";
fi;

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
	hostStyle="${bold}${cyan}";
else
	hostStyle="${cyan}";
fi;

# Set the terminal title to the current working directory.
PS1="\\[\\033]0;\\w\\007\\]";
PS1+="\\[${bold}\\]\\n"; # newline
PS1+="\\[${userStyle}\\]\\u"; # username
PS1+="\\[${white}\\] at ";
PS1+="\\[${hostStyle}\\]${cloud}\\h"; # host
PS1+="\\[${white}\\] in ";
PS1+="\\[${green}\\]\\w"; # working directory
PS1+="\$(prompt_git \"${white} on ${violet}\")"; # Git repository details
PS1+="\\n";
PS1+="\\[${white}\\]\$ \\[${reset}\\]"; # `$` (and reset color)
export PS1;

PS2="\\[${yellow}\\]→ \\[${reset}\\]";
export PS2;

####
###########################################################
# GRC lets you execute commond commands with a lovely output
# full of colors that will make your life easier
###########################################################
GRC="$(which grc)"
if [ "$TERM" != dumb ] && [ -n "$GRC" ]; then
alias colourify="$GRC -es --colour=auto"
alias blkid='colourify blkid'
alias configure='colourify ./configure'
alias df='colourify df'
alias diff='colourify diff'
alias docker='colourify docker'
alias docker-machine='colourify docker-machine'
alias du='colourify du'
alias env='colourify env'
alias free='colourify free'
alias fdisk='colourify fdisk'
alias findmnt='colourify findmnt'
alias make='colourify make'
alias gcc='colourify gcc'
alias g++='colourify g++'
alias id='colourify id'
alias ip='colourify ip'
alias iptables='colourify iptables'
alias as='colourify as'
alias gas='colourify gas'
alias ld='colourify ld'
alias ls='colourify ls'
alias lsof='colourify lsof'
alias lsblk='colourify lsblk'
alias lspci='colourify lspci'
alias netstat='colourify netstat'
alias ping='colourify ping'
alias traceroute='colourify traceroute'
alias traceroute6='colourify traceroute6'
alias head='colourify head'
alias tail='colourify tail'
alias dig='colourify dig'
alias mount='colourify mount'
alias ps='colourify ps'
alias mtr='colourify mtr'
alias semanage='colourify semanage'
alias getsebool='colourify getsebool'
alias ifconfig='colourify ifconfig'
fi

# Color of your promt CLI
#PS1="\[\033[01;31m\]\u@\h\[\033[01;34m\] \w $\[\033[00m\]"

#export LANG=en_US.UTF-8
#export LANGUAGE=en_US.UTF-8
#export LC_COLLATE=C
#export LC_CTYPE=en_US.UTF-8

####################
#Other alias section
###################
alias cat='lolcat'

#### END TEST

## TMUX 
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
	    tmux attach -t foo || tmux new -s foo 
fi
