#!/usr/bin/env bash
source ./lib_sh/echos.sh
source ./lib_sh/parse_yaml.sh

prefix="trangtt" #Beware when changing, hard coding below
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


link_dotfiles () {
    pushd "$HOME" >/dev/null 2>&1

    bot "Checking & Updating dotfiles repo..."
    if [ ! -d $(eval echo ${trangtt_dotfiles_repo_local_destination}) ] ; then
        git clone "${trangtt_dotfiles_repo}" "${trangtt_dotfiles_repo_local_destination}"
        cd "${trangtt_dotfiles_repo_local_destination}"
    else
        cd $(eval echo "${trangtt_dotfiles_repo_local_destination}")
        read -r -p "Do want to update dotfiles repo? [y|N]" res
        if [[ $res =~ (yes|y|Y) ]]; then
            git pull --ff-only
        fi
    fi

    bot "Back up old dotfiles and link new files"
	
	cd ~
	now=$(date +"%Y.%m.%d.%H.%M.%S")

	for file in "${trangtt_dotfiles_files[@]}"; do
	  	if [[ $file == "." || $file == ".." ]]; then
			continue
	    fi
	    running "${file}"
	    # if the file exists:
	    if [[ -e ~/.$file ]]; then
	        mkdir -p ~/dotfiles_backup/$now
	        mv ~/.$file ~/dotfiles_backup/$now/$file
	        echo "backup ~/.$file saved as ~/dotfiles_backup/$now/$file"
	    fi
	    # symlink might still exist
	    unlink ~/.$file > /dev/null 2>&1
	    # create the link
	    ln -s ~/dotfiles/$file ~/.$file
	    echo -en '\tlinked ';ok
	done
    popd >/dev/null 2>&1
}
