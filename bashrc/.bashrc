[[ -f /etc/bashrc ]] && . /etc/bashrc
unalias -a && [[ -f ~/.aliases ]] && . ~/.aliases
mkdir -p $HOME/.local/{log,bin,bak}
[[ -e ~/.nix-profile/etc/profile.d/nix.sh ]] && . ~/.nix-profile/etc/profile.d/nix.sh

[[ -x $(command -v fzf) ]] && eval "$(fzf --bash)"
[[ -x $(command -v fastfetch) ]] && fastfetch
[[ -x $(command -v vim) ]] && export EDITOR='vim' || export EDITOR='vi'
[[ -x $(command -v starship) ]] && eval "$(starship init bash --print-full-init)"

export PATH="~/.local/bin:$PATH"
# export PS1="\n\[\e]0;\u@\h: \w\a\]\[\033[;94m\]┌──${debian_chroot:+($debian_chroot)──}${VIRTUAL_ENV:+(\[\033[0;1m\]$(basename $VIRTUAL_ENV)\[\033[;94m\])}(\[\033[1;31m\]\u@\h\[\033[;94m\])-[\[\033[0;1m\]\w\[\033[;94m\]]\n\[\033[;94m\]└─\[\033[1;31m\]\$ \[\033[0m\]"

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Pretty, minimal BASH prompt, inspired by sindresorhus/pure(https://github.com/sindresorhus/pure)
#
# Author: Hiroshi Krashiki(Krashikiworks)
# released under MIT License, see LICENSE
# Colors
# Using standard ANSI escape codes instead of tput
readonly RESET=$'\e[0m'

# Regular colors
readonly BLACK=$'\e[30m'
readonly RED=$'\e[31m'
readonly GREEN=$'\e[32m'
readonly YELLOW=$'\e[33m'
readonly BLUE=$'\e[34m'
readonly MAGENTA=$'\e[35m'
readonly CYAN=$'\e[36m'
readonly WHITE=$'\e[37m'

# Bright colors
readonly BRIGHT_BLACK=$'\e[90m'
readonly BRIGHT_RED=$'\e[91m'
readonly BRIGHT_GREEN=$'\e[92m'
readonly BRIGHT_YELLOW=$'\e[93m'
readonly BRIGHT_BLUE=$'\e[94m'
readonly BRIGHT_MAGENTA=$'\e[95m'
readonly BRIGHT_CYAN=$'\e[96m'
readonly BRIGHT_WHITE=$'\e[97m'

# Symbols
pure_prompt_symbol="❯"
pure_symbol_unpulled="⇣"
pure_symbol_unpushed="⇡"
pure_symbol_dirty="*"

# Git status variables
pure_git_async_update=false
pure_git_raw_remote_status="+0 -0"

# Function to get git remote status
__pure_echo_git_remote_status() {
    local remote_status
    local unpulled_count unpushed_count

    # Use `git status` and a `grep` pipeline to find the exact line
    # with the push/pull numbers. This is more reliable than searching for `branch.upstream`.
    remote_status=$(git status --porcelain=v2 --branch 2>/dev/null | grep -E '^# branch.ab')
#    remote_status="${remote_status##*+}"

    # Exit if no remote status line was found
    if [[ -z "$remote_status" ]]; then
        return
    fi

    # Use a regular expression to capture the numbers. This is the most reliable way.
    # The regex `\+([0-9]+) -([0-9]+)` captures the two numbers.
    if [[ "$remote_status" =~ \+([0-9]+)\ -([0-9]+) ]]; then
        unpushed_count=${BASH_REMATCH[1]}
        unpulled_count=${BASH_REMATCH[2]}
    else
        unpushed_count=0
        unpulled_count=0
    fi

    # Check unpulled & unpushed status
    pure_git_unpulled=false
    pure_git_unpushed=false

    if [[ ${unpulled_count} -gt 0 ]]; then
        pure_git_unpulled=true
    fi
    if [[ ${unpushed_count} -gt 0 ]]; then
        pure_git_unpushed=true
    fi

    # Print the appropriate symbols
    if ${pure_git_unpulled}; then
        if ${pure_git_unpushed}; then
            echo "${RED}${pure_symbol_unpulled}${pure_symbol_unpushed}${RESET}"
        else
            echo "${BRIGHT_RED}${pure_symbol_unpulled}${RESET}"
        fi
    elif ${pure_git_unpushed}; then
        echo "${BRIGHT_BLUE}${pure_symbol_unpushed}${RESET}"
    fi
}

# Function to update git status
__pure_update_git_status() {
    pure_git_status=""

    # Check if inside a git repository
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]]; then
        local current_branch=$(git branch --show-current 2>/dev/null)
        pure_git_status="${current_branch}"

        # Check for dirty working tree
        git diff-index --quiet HEAD -- || pure_git_status="${pure_git_status}${pure_symbol_dirty}"

        # Color the status
        pure_git_status="${BRIGHT_BLACK}${pure_git_status}${RESET}"

        # Check if repository has a remote
        if [[ -n $(git remote 2>/dev/null) ]]; then
            pure_git_status="${pure_git_status} $(__pure_echo_git_remote_status)"
        fi
    fi
}

# Function to determine prompt color based on last command's exit code
__pure_echo_prompt_color() {
    if [[ $? = 0 ]]; then
        echo "${pure_user_color}"
    else
        echo "${RED}"
    fi
}

# Update prompt color
__pure_update_prompt_color() {
    pure_prompt_color=$(__pure_echo_prompt_color)
}

# Set user color based on UID
case ${UID} in
    0) pure_user_color=${BRIGHT_YELLOW} ;;
    *) pure_user_color=${BRIGHT_MAGENTA} ;;
esac

# Check if git is available and set PROMPT_COMMAND
if command -v git &>/dev/null; then
    PROMPT_COMMAND="__pure_update_git_status; ${PROMPT_COMMAND}"
fi

PROMPT_COMMAND="__pure_update_prompt_color; ${PROMPT_COMMAND}"

# The issue with escape characters not being printed as strings is due to how Bash processes PS1.
# The escape characters need to be enclosed in single quotes or escaped properly.
# `\[` and `\]` are used to tell Bash not to count the characters inside them,
# which prevents strange cursor behavior.
readonly FIRST_LINE="${CYAN}\w \${pure_git_status}\n"
readonly SECOND_LINE="\[\${pure_prompt_color}\]${pure_prompt_symbol}\[$RESET\] "
PS1="\[$(date +%T)\] ${FIRST_LINE}${SECOND_LINE}"

# Multiline command
PS2="\[${BLUE}\]${pure_prompt_symbol}\[$RESET\] "
