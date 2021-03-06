#!/usr/bin/env bash

###
# some colorized echo helpers
# @author Adam Eivy
###

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"


#ESC_SEQ="\e[0;"
#ESC_SEQ="\x1b["
#COL_RESET=$ESC_SEQ"m"
#COL_RESET=$ESC_SEQ"39;49;00m"
#COL_RED=$ESC_SEQ"31m"
#COL_RED=$ESC_SEQ"31;01m"
#COL_GREEN=$ESC_SEQ"32m"
#COL_GREEN=$ESC_SEQ"32;01m"
#COL_YELLOW=$ESC_SEQ"33m"
#COL_YELLOW=$ESC_SEQ"33;01m"
#COL_BLUE=$ESC_SEQ"34m"
#COL_BLUE=$ESC_SEQ"34;01m"
#COL_MAGENTA=$ESC_SEQ"35m"
#COL_MAGENTA=$ESC_SEQ"35;01m"
#COL_CYAN=$ESC_SEQ"36m"
#COL_CYAN=$ESC_SEQ"36;01m"

function ok() {
    echo -e "${COL_GREEN}[ok]${COL_RESET} "$1
}

function fail() {
    echo -e "${COL_RED}[fail]${COL_RESET} "$1
}

function bot() {
    echo -e "\n${COL_CYAN}\[._.]/ - "$1"${COL_RESET} "
}

function running() {
    echo -en "${COL_BLUE} ⇒ ${COL_RESET} "$1": "
}

function action() {
    echo -e "\n${COL_MAGENTA}[action]:${COL_RESET} $1... \n"
    #echo -e "\n${COL_YELLOW}[action]:$COL_RESET\n ⇒ $1..."
}

function warn() {
    echo -e "${COL_YELLOW}[warning]${COL_RESET} "$1
}

function error() {
    echo -e "${COL_RED}[error]${COL_RESET} "$1
}
