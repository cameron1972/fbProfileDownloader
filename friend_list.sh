#!/bin/bash

# download all friends into data_* files and output friends in format url:name into stdout

# example:
# ./friend_list.sh matej116
# = get all friends visible by you of user matej116 and output them in format "username:name" to stdout

username="$1"

function log {

	echo "$1" >&2
}

function error {
	log "$1";
	exit 1;
}


[[ -z $username ]] && error "Username as \$1 not set";


function download {

	i="$1";

	[ -z $i ] && error "Index not set (\$1 of download())";

	./download.sh "$username/friends?startindex=$i" > data_${username}_$i

	cat data_${username}_$i | hxselect -c '#m_more_friends' | egrep -o '[0-9]+' | tail -n1
}

i=${2:-0} # start from 0


while [ ! -z $i ]
do

	log "Downloading $i:"

	i=$(download "$i")

	log "Downloaded, next i = $i"
done

log "Downloaded all friends in data_${username}_* files, extracting "

cat data_${username}_* | hxselect -s '\n' 'div table a' | grep fr_tab | sed -r 's/^.*href="\/(profile\.php\?id=)?([^\?&]+).*">(.*)<\/a>.*$/\2:\3/g'

log "Friends downloaded"

log "Deleting temporary files data_${username}_*..."
rm data_${username}_*



