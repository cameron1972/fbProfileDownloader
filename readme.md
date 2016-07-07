

Facebook profile images and friend list downloader
====================

A collection of simple script to download all profile pictures and friend list of given people on Facebook.

Usage:
-----

1. Download these scripts to one directory (`git clone` or download & extract zip)
2. **important!** you must provide credentials to the scripts:
	1. Open browser and login to mbasic.facebook.com
	2. Open Developer tools (F12) and network panel
	3. Login to mbasic.facebook.com
	4. Right click on first GET request and select "Copy as cURL"
	5. Paste copied content into file credentials_curl_headers
3. Continue with either of following scenarios:

Requirements:
-----------

 - Unix system with Bash, tested on Linux Ubuntu 14.04, 16.04, Mint 17.1, 17.3
 - installed `html-xml-utils` (`sudo apt-get install html-xml-utils`) for command `hxselect`


Description of scripts:
-------------------------

### friend_list.sh
- download friend list of given user
- example:  `./friend_list.sh me` download all your friends (in case of other users, only friends **visible by you as a provider of credentials**) and outputs them into standard output in format `username:fullname`, one friend at a row.


### profile_images.sh
 - download all profile images on **original quality** of given user into given directory named as 0.jpg, 1.jpg etc...
 -  example: `./profile_images zuck photos` download all profile photos of Mark Zuckerberg into folder photos named as 0.jpg, 1.jpg, 2.jpg, 3.jpg and 4.jpg

### batch_friend_list.sh
- download friend list of all people provided in standard input in format `username:fullname`, outputs them in file `$ourput_dir/$username`, where `$output_dir` is $1 (first argument of this script). Subprocesses are run in parallel.
- example: `./friend_list.sh me | ./batch_friend_list.sh friends` downloads names of friends of your friends into directory `friends` containing files named as your friends usernames.

### batch_profile_images.sh
- download all profile images of all people given in standard input in format `username:fullname`, and saves them in provided directory
- example: `./friend_list.sh me | ./batch_profile_images.sh images` download profile images of all your friends and saves them in directories by your friends' username.

For more details browse the source code. These are really simple scripts.
