# Credits:
# - Armin Ronacher Dotfiles -- https://github.com/mitsuhiko/dotfiles
# - GA WDI Installfest -- https://github.com/GA-WDI/installfest
# - Bash Ref Manual -- https://www.gnu.org/software/bash/manual/bashref.html
# - LS Colors -- http://geoff.greer.fm/lscolors/
# - Bash Colors -- https://gist.github.com/vratiu/9780109#file-bash_aliases-L51
# - Bash History -- http://jorge.fbarr.net/2011/03/24/making-your-bash-history-more-efficient/


# Increase bash history size
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE



######################
#                    #
#   Aliases          #
#                    #
######################

# reload the shell
alias reload="clear; source ~/.bash_profile"



######################
#                    #
#   Colors           #
#                    #
######################

# Reset text
RESET="\033[0m"

# Regular colors
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"

# Bold colors
BBLACK="\033[1;30m"
BRED="\033[1;31m"
BGREEN="\033[1;32m"
BYELLOW="\033[1;33m"
BBLUE="\033[1;34m"
BPURPLE="\033[1;35m"
BCYAN="\033[1;36m"
BWHITE="\033[1;37m"


############################################################
#                                                          #
#   user  in full_path             on branch[state]        #
#   isaac in ~/Desktop/shenanigans on master[!]            #
#   $                                                      #
#                                                          #
############################################################

PS1="\n\n\[${GREEN}\]\u "           # 2 new lines of bash, user
PS1+="\[${RESET}\]in ${CYAN}\w"     # in working directory
PS1+="\$(prompt_git)"               # git information
PS1+="\n\[${RESET}\]\$ "            # new line, $


###############################
#                             #
#   Git Details               #
#                             #
###############################

# Show more information regarding git status in prompt
GIT_DIFF_IN_PROMPT=true

# Long git to show (+, ?, !)
is_git_repo() {
    $(git rev-parse --is-inside-work-tree &> /dev/null)
}

is_git_dir() {
    $(git rev-parse --is-inside-git-dir 2> /dev/null)
}

get_git_branch() {
    local branch_name
    # Get the short symbolic ref
    branch_name=$(git symbolic-ref --quiet --short HEAD 2> /dev/null) ||
    # If HEAD isn't a symbolic ref, get the short SHA
    branch_name=$(git rev-parse --short HEAD 2> /dev/null) ||
    # Otherwise, just give up
    branch_name="(unknown)"
    printf $branch_name
}

# Git status information
prompt_git() {
    local git_info git_state
    if ! is_git_repo || is_git_dir; then
        return 1
    fi
    git_info=$(get_git_branch)

    if $GIT_DIFF_IN_PROMPT; then
      # Check for uncommitted changes in the index
      if ! $(git diff --quiet --ignore-submodules --cached); then
          git_state+="${RED}+"
      fi
      # Check for unstaged changes
      if ! $(git diff-files --quiet --ignore-submodules --); then
          git_state+="${RED}!"
      fi
      # Check for untracked files
      if [ -n "$(git ls-files --others --exclude-standard)" ]; then
          git_state+="${RED}?"
      fi
      # Check for stashed files
      if $(git rev-parse --verify refs/stash &>/dev/null); then
          git_state+="${RED}$"
      fi
      # Combine branch and state
      if [[ $git_state ]]; then
          git_info="$git_info${RESET}[$git_state${RESET}]"
      fi
    fi

    printf "${RESET} on ${YELLOW}${git_info}"
}
