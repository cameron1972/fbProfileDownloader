#!/bin/bash

# helper script to download given URI as $i with facebook credentials
# 

uri=${1##/}

[[ -z "$uri" ]] && echo 'No uri given as $1' && exit 1

credFile='credentials_curl_headers'


url="https://mbasic.facebook.com/$uri"
cred=`cat "$credFile"`

[[ -z $cred ]] && echo "Credentials not supplied in '$credFile'" && echo "Hint: select 'Copy as cURL' in browser network panel in developer tools and paste it into file '$credFile'. Cannot continue" && exit 1 

tries=0

cred=`sed 's/-H/&\n/;s/.*\n/-H/' <<< "$cred"` # strip out curl http://mbasic.facebok.com... until '-H'

while true
do

	echo "Downloading '$url' with credentials" >&2
	# -s = quiet
	# -L = follow redirects
	# -f = --fail = no output and exit code 22 if error
	bash <<< "curl \"$url\" -s -f -L $cred"
	# repeat if curl's exit code is 22 = error code >= 400
	[[ $? -eq 22 ]] || break
	
	tries=$((tries+1))
done;	

exit $?
