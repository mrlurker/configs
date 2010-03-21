# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/spell/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinostall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
bindkey -e
# End of lines configured by zsh-newuser-install

# Keybindings {{{
bindkey '^[[3~' delete-char
#}}}

#Aliases {{{
alias ls='ls --color=auto -F'
#alias for cpi breaks batery time widget?
#alias acpi='acpi -V'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias emacscmd="emacs -Q -nw --eval '(menu-bar-mode)'"
# }}}

#{{{ Opts
setopt histignorealldups
setopt histsavenodups
setopt incappendhistory
#}}}

# {{{ Prompt settings
function precmd {
    ###
    # terminal width to one less than the actual width for lineup
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))
    ###
    # truncate the path if it's too long
    PR_FILLBAR=""
    PR_PWDLEN=""
    local promptsize=${#${(%):---(%n@%m:%l)---()--}}
    local pwdsize=${#${(%):-%~}}
    if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
	((PR_PWDLEN=$TERMWIDTH - $promptsize))
    else
        PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
    fi
}
###
# set the window title in screen to the currently running program
setopt extended_glob
function preexec () {
    if [[ "$TERM" == "screen-256color" ]]; then
        local CMD=${1[(wr)^(*=*|sudo|-*)]}
        echo -n "\ek$CMD\e\\"
    fi
}
function setprompt () {
    ###
    # need this so the prompt will work
    setopt prompt_subst
    ###
    # try to use colors
    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
        colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	(( count = $count + 1 ))
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"
    ###
    # try to use extended characters to look nicer
    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}
    PR_SET_CHARSET="%{$terminfo[enacs]%}"
    PR_SHIFT_IN="%{$terminfo[smacs]%}"
    PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
    PR_HBAR=${altchar[q]:--}
    PR_ULCORNER=${altchar[l]:--}
    PR_LLCORNER=${altchar[m]:--}
    PR_LRCORNER=${altchar[j]:--}
    PR_URCORNER=${altchar[k]:--}
    ###
    # set titlebar text on a terminal emulator
    case $TERM in
	xterm*)
            PR_TITLEBAR=$'%{\e]0;%(!.*ROOT* | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
	    ;;
	rxvt*)
            PR_TITLEBAR=$'%{\e]0;%(!.*ROOT* | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
	    ;;
	screen*)
            PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.*ROOT* |.)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
            # ensure SSH agent is still usable after an X restart
            SSH_AUTH_SOCK=`find /tmp/gpg-* -name S.gpg-agent.ssh`
	    ;;
	*)
            PR_TITLEBAR=''
	    ;;
    esac
    ###
    # Linux console and Emacs ansi-term get simpler prompts, the rest have:
    #   - (user@hostname:tty)--($PWD) and an exit code of the last command
    #   - right hand prompt which makes room if the command line grows past it
    #   - PS2 continuation prompt to match PS1 in color
    case $TERM in
        dumb)
            unsetopt zle
            PROMPT='%n@%m:%~%% '
            ;;
	eterm-color)
            PROMPT='$PR_YELLOW%n$PR_WHITE:%~$PR_NO_COLOUR%% '
	    ;;
        linux)
            # zenburn for the Linux console
            echo -en "\e]P01e2320" #zen-black (norm. black)
            echo -en "\e]P8709080" #zen-bright-black (norm. darkgrey)
            echo -en "\e]P1705050" #zen-red (norm. darkred)
            echo -en "\e]P9dca3a3" #zen-bright-red (norm. red)
            echo -en "\e]P260b48a" #zen-green (norm. darkgreen)
            echo -en "\e]PAc3bf9f" #zen-bright-green (norm. green)
            echo -en "\e]P3dfaf8f" #zen-yellow (norm. brown)
            echo -en "\e]PBf0dfaf" #zen-bright-yellow (norm. yellow)
            echo -en "\e]P4506070" #zen-blue (norm. darkblue)
            echo -en "\e]PC94bff3" #zen-bright-blue (norm. blue)
            echo -en "\e]P5dc8cc3" #zen-purple (norm. darkmagenta)
            echo -en "\e]PDec93d3" #zen-bright-purple (norm. magenta)
            echo -en "\e]P68cd0d3" #zen-cyan (norm. darkcyan)
            echo -en "\e]PE93e0e3" #zen-bright-cyan (norm. cyan)
            echo -en "\e]P7dcdccc" #zen-white (norm. lightgrey)
            echo -en "\e]PFffffff" #zen-bright-white (norm. white)
            # avoid 'artefacts'
            #clear
            #
            PROMPT='$PR_GREEN%n@%m$PR_WHITE:$PR_YELLOW%l$PR_WHITE:$PR_RED%~$PR_YELLOW%%$PR_NO_COLOUR '
            ;;
	*)
            PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_CYAN$PR_SHIFT_IN$PR_ULCORNER$PR_CYAN$PR_HBAR$PR_SHIFT_OUT(\
$PR_CYAN%(!.%SROOT%s.%n)$PR_CYAN@%m$PR_WHITE:$PR_YELLOW%l\
$PR_CYAN)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_HBAR${(e)PR_FILLBAR}$PR_CYAN$PR_HBAR$PR_SHIFT_OUT(\
$PR_RED%$PR_PWDLEN<...<%~%<<$PR_CYAN)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_URCORNER$PR_SHIFT_OUT\

$PR_CYAN$PR_SHIFT_IN$PR_LLCORNER$PR_CYAN$PR_HBAR$PR_SHIFT_OUT(\
%(?..$PR_RED%?$PR_WHITE:)%(!.$PR_RED.$PR_YELLOW)%#$PR_CYAN)$PR_NO_COLOUR '

            RPROMPT=' $PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'

            PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_YELLOW%_$PR_CYAN)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
            ;;
    esac
}

# Prompt init
setprompt
# }}}

