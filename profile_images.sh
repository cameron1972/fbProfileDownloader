#!/bin/bash

# download profile image in original quality of user given as $1 to dir $2 named as 0.jpg, 1.jpg etc...

username="$1"
dir="$2"

[[ -z $username ]] && echo "Username \$1 not set" && exit 1
[[ -z $dir ]] && echo "Output directory \$2 not set" && exit 1

[[ -d $dir ]] || mkdir -p "$dir"


if [[ $username =~ ^[0-9]+$ ]]
then
	photo_uri="profile.php?v=photos&id=$username"
else
	photo_uri="$username/photos"
fi

# get profile album url
profileAlbumUri=$(./download.sh "$photo_uri" | grep -Po "$username"'/albums/\d+/(\?[^"]+)?(?=">Profile Pictures)')

echo "Profile pictures album URI: '$profileAlbumUri'"


i=0
page=1


while [[ $profileAlbumUri ]]
do

  echo "Downloading page $page"


  album_html=$(./download.sh "$profileAlbumUri")
  # set next page URI
  profileAlbumUri=$(echo "$album_html" | hxselect -c '#m_more_item' | grep -Po '(?<=href=").*?(?=")' | sed 's/&amp;/\&/g')

  echo "Extracted URI for next page: $profileAlbumUri"

  while read url
  do

  	echo "Downloading image no. $i (page $page)"
  	# download image itself after extracting full sized photo from photo html page
  	./download.sh "$url" | grep -Po '(?<=href=")[^"]+?(?=">View Full Size)' | sed 's/&amp;/\&/g' | xargs curl -s > "$dir/$i.jpg"

  	i=$((i+1))

  done < <(echo "$album_html" | egrep -o '/photo.php[^"]+' | sed 's/&amp;/\&/g')

  page=$((page+1))
  
  # move to next page
 
done

echo "Succesfully downloaded $i profile images in original quality of user '$username' into directory '$dir'"
