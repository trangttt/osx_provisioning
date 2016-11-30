#!/usr/bin/env bash

###########################
# This script installs the dotfiles and runs all other system configuration scripts
# @author Adam Eivy
###########################

# include my library helpers for colorized echo and require_brew, etc
source ./lib_sh/echos.sh
source ./lib_sh/requirers.sh

bot "Hi! I'm going to install tooling and tweak your system settings. Here I go..."

# Ask for the administrator password upfront
if sudo grep -q "# %wheel ALL=(ALL) NOPASSWD: ALL" "/etc/sudoers"; then

  # Ask for the administrator password upfront
  bot "I need you to enter your sudo password so I can install some things:"
  sudo -v

  # Keep-alive: update existing sudo time stamp until the script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

  bot "Do you want me to setup this machine to allow you to run sudo without a password?\nPlease read here to see what I am doing:\nhttp://wiki.summercode.com/sudo_without_a_password_in_mac_os_x \n"

  read -r -p "Make sudo passwordless? [y|N] " response

  if [[ $response =~ (yes|y|Y) ]];then
      #sed --version 2>&1 > /dev/null
      sudo sed -i '' 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers
      #if [[ $? == 0 ]];then
          #sudo sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers
      #fi
      sudo dscl . append /Groups/wheel GroupMembership $(whoami)
      bot "You can now run sudo commands without password!"
  fi
fi

#########################################################################
# Install HomeBrew (CLI Packages)
#########################################################################

bot "Install HomeBrew. Make sure XCode and XCode command line are installed."
running "checking homebrew install"
brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then

  running "Checking XCode installed"
  which g++ >/dev/null 2>&1 
  if [[ $? != 0 ]]; then
	error "XCode is not installed. Please install XCode using App Store"
  else
      ok
  fi

  running "Checking XCode command line installed."
  xcode-select -p >/dev/null 2>&1
  if [[ $? != 0 ]]; then
      error "XCode command line is not installed.\nPlease install using: xcode-select --install"
      exit 2
  else
      ok 
  fi

  action "Installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [[ $? != 0 ]]; then
      error "unable to install homebrew, script $0 abort!"
      exit 2
  fi
else
  ok
  # Make sure we’re using the latest Homebrew
  bot "do you want updating homebrew?"
  read -r -p "run brew update? [y|N]" response
  if [[ $response =~ ^(y|yes|Y) ]]; then
      action "update brew....."
      brew update
      ok "brew updated."
  fi
  bot "before installing brew packages, we can upgrade any outdated packages."
  read -r -p "run brew upgrade? [y|N] " response
  if [[ $response =~ ^(y|yes|Y) ]];then
      # Upgrade any already-installed formulae
      action "upgrade brew packages..."
      brew upgrade
      ok "brews packages upgraded."
  else
      ok "skipped brew package upgrades.";
  fi
fi

#########################################################################
# Install  Brew Cask (UI Packages)
#########################################################################
running "checking brew-cask install"
output=$(brew tap | grep cask)
if [[ $? != 0 ]]; then
  action "installing brew-cask"
  require_brew caskroom/cask/brew-cask
fi
brew tap caskroom/versions > /dev/null 2>&1
ok
#########################################################################
# Install some essential apps
#########################################################################
action "Install git"
which git >/dev/null 2>&1
if [[ $? != 0 ]]; then
    require_brew git
fi
ok

action "Install zsh zsh-completions"
require_brew zsh zsh-completions

#########################################################################
# Continue using Ansible
#########################################################################

running "Checking ansible install...."
ansible --version >/dev/null 2>&1
if [[ $? != 0  ]]; then
    action "Installing ansible using brew."
    require_brew ansible
else
    ok "Installed."
fi

action "Using ansible to automate provisioning"
ansible-playbook playbook.yml -i inventory  


########################################################################
# Set up ZSH as default login shell, oh-my-zsh, powerlevel9k
########################################################################
# set zsh as the user login shell
CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
if [[ "$CURRENTSHELL" != "/usr/local/bin/zsh" ]]; then
  bot "setting newer homebrew zsh (/usr/local/bin/zsh) as your shell (password required)"
  # sudo bash -c 'echo "/usr/local/bin/zsh" >> /etc/shells'
  # chsh -s /usr/local/bin/zsh
  sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/zsh > /dev/null 2>&1
  ok
fi

#Install prezto
action "Install zprezto"
running "Checking zprezto installed...."
if [[ -d "${ZDOTDIR:-$HOME}/.zprezto" ]] ; then
    ok
else 
    echo
    running "Installing zprezto..."
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" >/dev/null 2>&1
    if [[ $? == 0  ]]; then
        ok
    else
        error "Install zprezto failed."
        exit 2
    fi
fi

#Install OH-MY-ZSH
action "Install oh-my-zsh"
running "Checking oh-my-zsh install"
if [[ -d "$HOME/.oh-my-zsh" ]] ; then
    ok 
else
    echo 
    running "Installing oh-my-zsh"
    curl -s -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh >/dev/null 2>&1 | sh >/dev/null 2>&1
    ok
fi

#Install powerlevel9k
running "Installing powerlevel9k"
if [[ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel9k" ]]; then
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k >/dev/null 2>&1
fi
ok

########################################################################
# Initialize git account
########################################################################
source ./lib_sh/config_git.sh

########################################################################
# Install tmux plugins
########################################################################
action "Install tmux plugins"
running "Checking TPM install...."
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm >/dev/null 2>&1
fi
ok

running "Install plugins using TPM....."
~/.tmux/plugins/tpm/bin/install_plugins >/dev/null 2>&1
if [[ $? == 0  ]] ; then
    ok 
else 
    error "tmux plugins installation failed."
fi

########################################################################
# Install vim plugins
########################################################################
action "Installing vim plugins"
if [[ ! -e ~/.vimrc ]]; then
    error "~/.vimrc missing."
    exit 2
else
    vim -E -s -c "source ~/.vimrc" -c PluginInstall -c qa
    ok
fi


