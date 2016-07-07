#!/bin/bash

# expecting stdin = list of user:name of users
# $1 = output_dir
# ./get_friends_list.sh is run in paralel for every row in stdin, output is stored in "$output_dir/$username"

output_dir="$1"
max_running=10 # limit subprocess count

function error {
	echo "$1" >&2
	exit 1
}

[[ -z $output_dir ]] && error "output_dir as \$1 not defined" 

while IFS=':' read user name; 
	
	while [ `jobs | wc -l` -ge $max_running ]
   	do
   		echo "Max running count reached, waiting a while..."
      	sleep 2
   	done

	do echo "----------------- $user $name"; 
	./friends_list.sh "$user" > "$output_dir/$user" & 
done