#!/bin/bash
###############################################################
# @params
# command: may be "github", "git" or "both" (for git and github account)
# account: label for a git account
# method: may be "token" or "browser" (Optional argument)
###############################################################
cmd=$1
acc=$2
med=$3
# Show git credentials
showGitCredentials(){
    git config --list --show-origin
}
# Show github-cli status
showGithubStatus(){
    gh auth status
}
# delete file with the github token
deleteToken(){
    rm -rf /tmp/tokengithub
}
# Extract git credentials from a json file with the command jq (for more read the doc for jq)
setVariables(){
    usr=$( jq ".$acc.user" config.json | tr -d '"' )
    eml=$( jq ".$acc.email" config.json | tr -d '"' )
    tok=$( jq ".$acc.token" config.json | tr -d '"' )
    echo $tok > /tmp/tokengithub
}
# Change git credentials from a json file with the command jq (for more read the doc for jq)
changeGitCredentials() {
    git config --global user.name "$usr"
    git config --global user.email "$eml"
    git config --global user.mail "$eml"
}
# Change github credentials from a json file with the command jq (for more read the doc for jq)
changeGithubCredentials(){
    gh auth logout
    case $med in
        token)
            gh auth login --with-token < /tmp/tokengithub
        ;;
        browser)
            gh auth login --web
        ;;
        *)
            echo "Pass \"token\" or \"browser\" for select the mode of authentication"
            exit 1
        ;;
    esac
}
# Main script
main(){
    setVariables
    case $cmd in
        git)
            echo "Current credentials ..."
            echo -e "Git:\n"
            showGitCredentials
            echo -e "\n..........\n"
            echo "Setting credentials ..."
            changeGitCredentials
            echo -e "\n..........\n"
            echo "New credentials ..."
            echo -e "Git:\n"
            showGitCredentials
            echo -e "..........\nCompleted!"
        ;;
        github)
            echo "Current status ..."
            echo -e "Github:\n"
            showGithubStatus
            echo -e "\n..........\n"
            echo "Setting credentials ..."
            changeGithubCredentials
            echo -e "\n..........\n"
            echo "New status ..."
            echo -e "Github:\n"
            showGithubStatus
            echo -e "..........\nCompleted!"
        ;;
        both)
            echo "Current credentials and status ..."
            echo -e "Git:\n"
            showGitCredentials
            echo -e "Github:\n"
            showGithubStatus
            echo -e "\n..........\n"
            echo "Setting credentials ..."
            changeGitCredentials
            changeGithubCredentials
            echo -e "\n..........\n"
            echo "New credentials ..."
            echo -e "Git:\n"
            showGitCredentials
            echo -e "Github:\n"
            showGithubStatus
            echo -e "..........\nCompleted!"
        ;;
        *)
            echo "Pass \"token\" or \"browser\" for select the mode of authentication"
            exit 1
        ;;
    esac
    deleteToken
}

main

exit 0