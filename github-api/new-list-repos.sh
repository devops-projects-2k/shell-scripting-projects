#!/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# Function to get data from GitHub API
function github_api_get() {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"
    echo "Requesting URL:"
    echo $url
    echo "Sending Request..."
    curl -s -u "${username}:${token}" "${url}"
}

# Function to get list of repositories
function list_github_repos() {
    local endpoint="user/repos"
    local response=$(github_api_get "$endpoint")
    
    echo "Raw API response:"
    echo "$response"  # Print the raw response to help with debugging

    # Using echo and pipe to ensure proper JSON parsing
    local list=$(echo "$response" | jq -r '.[] | select(.name == "shell-scripting-projects") | .owner.login')
    if [[ $? -ne 0 ]]; then
        echo "Error in processing JSON"
        return 1
    fi
    
    echo "List of collaborators:"
    echo "$list"
}

# Main Execution
echo "Fetching list of repositories..."
list_github_repos

