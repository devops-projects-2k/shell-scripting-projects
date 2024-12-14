#!/bin/bash


#######################
# Name: list-collaborators.sh
# Version: v1
# Description: 
# Lists collaborators present in github project
#
#
#
#
# Date Created: 12/14/2024
################################################

# Github API URL
API_URL="https://api.github.com"

#function to get list of repositories
function github_api_get(){
	local endpoint="$1"
	local url="${API_URL}/${endpoint}"
        echo 'print arg' >&2 
	echo $url >&2
	echo 'printed' >&2
	#send a GET request with username and password for authentication 
	#-s - silent mode
	#-u - username and password
	curl -s -u "${username}:${token}" "${url}"
        echo 'authentication func end' >&2
}


#function to get list of repositories
function list_github_repos(){
	local endpoint="user/repos"
	resp=$(github_api_get "$endpoint") 
	echo 'RAW response:' >&2
	echo "$resp" > resp.json

	local list=$(jq -r '.[] | select(.name == "shell-scripting-projects") | .owner.login' resp.json)

	echo $list >&2
}
echo "List of collaborators"
      list_github_repos
