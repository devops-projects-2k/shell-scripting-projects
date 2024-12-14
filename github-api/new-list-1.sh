# GitHub API URL
API_URL="https://api.github.com"

# Function to get data from GitHub API
function github_api_get() {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"
    echo "Requesting URL:"
    echo $url
    echo "Sending Request..."
    response=$(curl -s -u "${username}:${token}" "${url}")

    if [[ $? -ne 0 ]]; then
        echo "Error in API request"
        return 1
    fi

    echo "Request Completed"
    echo "$response"
}

# Function to get list of repositories
function list_github_repos() {
    local endpoint="user/repos"
    local response=$(github_api_get "$endpoint")
    
    echo "Raw API response:"
    echo "$response"  # Print the raw response to help with debugging

    # Save response to a temporary file for debugging
    echo "$response" > response.json

    # Step-by-step jq parsing to diagnose the issue
    echo "Parsing JSON response:"
    echo "$response" | jq -r '.[]'  # Check if it can parse the array
    echo "$response" | jq -r '.[] | select(.name == "shell-scripting-projects")'  # Check select filter
    echo "$response" | jq -r '.[] | select(.name == "shell-scripting-projects") | .owner'  # Check owner object
    echo "$response" | jq -r '.[] | select(.name == "shell-scripting-projects") | .owner.login'  # Final extraction

    local list=$(echo "$response" | jq -r '.[] | select(.name == "shell-scripting-projects") | .owner.login')
    if [[ $? -ne 0 ]]; then
        echo "Error in processing JSON"
        cat response.json  # Print the response for debugging
        return 1
    fi
    
    echo "List of collaborators:"
    echo "$list"
}

# Main Execution
echo "Fetching list of repositories..."
list_github_repos

