#!/bin/bash

user=$1
org_name=$2
token=$(cat token)

repos_json=$(curl -u $user:$token https://dev.azure.com/$org_name/_apis/git/repositories?api-version=2.0 | jq)
repo_ssh_urls=$(echo "$repos_json" | jq -r '.value[].sshUrl')

function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

for url in $repo_ssh_urls; do
    project_and_repo=$(urldecode "${url##*/$org_name/}")
    mkdir -p "$project_and_repo"
    git clone "$url" "$project_and_repo"
done
