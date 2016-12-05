#!/usr/bin/env bash
source ./lib_sh/parse_yaml.sh
source ./lib_sh/echos.sh



prefix="trangtt"
vars=( "${prefix}_dotfiles_repo"
           "${prefix}_dotfiles_home"
           "${prefix}_dotfiles_repo_accept_hostkey"
           "${prefix}_dotfiles_repo_local_destination"
           "${prefix}_dotfiles_files"
           "${prefix}_homebrew_packages"
           "${prefix}_homebrew_cask_appdir"
           "${prefix}_homebrew_cask_apps"
           )


read_apps () {
    eval $(parse_yaml ./osx/vars/main.yml "${prefix}_")
    for item in "${vars[@]}"; do
        if [[ "$(declare -p ${item})" =~ "declare -a" ]]; then
            eval var=\( \"\${${item}[@]}\"  \)
            [[ -z {var:+"123"} ]] && return 1 
            #echo "$item :"
            #for i in "${var[@]}";do
                #echo -e "\t[$i]" 
            #done
        else
            var="{!item}"
            [[ -z {var:+"123"} ]] && return 1
            #echo "[${item}]"
        fi
        
    done
    return 0     
}


install_apps () {
    bot "Installing brew packages"
    installed_apps=$(brew ls)
    for p in "${trangtt_homebrew_packages[@]}"; do
        running "Install $p"
        if echo "$installed_apps" | grep "$p" >/dev/null 2>&1 ; then
            ok "Already installed."
        else
            eval brew install "$p" >/dev/null  
            [[ $? == 0 ]] && ok "Succeeded." || error "Failed."
        fi
    done


    bot "Installing apps via brew cask."
    installed_apps=$(brew cask list)
    for p in "${trangtt_homebrew_cask_apps[@]}"; do
        running "Install $p"
        if echo "$installed_apps" | grep "$p" >/dev/null 2>&1 ; then
            ok "Already installed."
        else
            eval brew cask install "$p" >/dev/null  
            [[ $? == 0 ]] && ok "Succeeded." || error "Failed."
        fi
 
    done
}


#read_apps && install_apps
#echo $?
