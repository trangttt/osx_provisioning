#!/usr/bin/env bash
#
# vim: set ft=sh:
#
# Based on https://gist.github.com/pkuczynski/8665367

parse_yaml() {
    local prefix=$2
    local s
    local w
    local fs
    s='[[:space:]]*'
    w='[a-zA-Z0-9_-]*'
    fs="$(echo @|tr @ '\034')"
    sed -e "s|^\(.*\)#\(.*\)$|\1|" -e "/^$/d" "$1" |
    sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s[:-]$s\(.*\)$s\$|\1$fs\2$fs\3|p" |  
    awk -F"$fs" '{
        indent = length($1)/2;
        sub(" ", "", $2);
        vname[indent] = $2;
        for (i in vname) {
            if (i > indent) {
                delete vname[i]
            }
        }
        if (length($3) > 0) {
            vn=""; 
            for (i=0; i<indent; i++) {
                vn=(vn)(vname[i])("_")
            }
            gsub(/[[:space:]]+$/, "", $3);
            printf("%s%s%s=(\"%s\")\n\n", "'"$prefix"'",vn, $2, $3);
        }
    }' | sed 's/_=/+=/g'
}

#parse_yaml config.yml
