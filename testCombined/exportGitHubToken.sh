#!/bin/bash
shopt -s lastpipe
export SECRET_TOKEN=$(cat /run/secrets/github_access_token.txt)
echo $SECRET_TOKEN


#set -euo pipefail
# if [ -f /run/secrets/github_access_token.txt ]; then
#    export SECRET_TOKEN=$(cat /run/secrets/github_access_token.txt)
# fi
# echo $SECRET_TOKEN
