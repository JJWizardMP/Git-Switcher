#!/bin/bash

###################################
# @params
# account: label for a git account
###################################
acc=$1

# Extract git credentials from a json file with the command jq (for more read the doc)
changeGitCredentials() {
    usr=$( jq ".$acc.user" config.json | tr -d '"' )
    eml=$( jq ".$acc.email" config.json | tr -d '"' )
    tok=$( jq ".$acc.token" config.json | tr -d '"' )
    echo $tok > /tmp/tokengithub
    git config --global user.name "$usr"
    git config --global user.email "$eml"
    git config --global user.mail "$eml"
}

runScript(){
    echo "Current credentials..."
    git config --list --show-origin
    echo -e "\n..........\n"
    echo "Setting credentials..."
    changeGitCredentials
    echo -e "\n..........\n"
    echo "New credentials..."
    git config --list --show-origin
    echo -e "..........\nCompleted!"
}

runScript

exit 0