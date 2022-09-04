#!/bin/bash
###################################################################################
# name: Git/Github Switcher
# version: 1.0.1
# description: This script allow you change in differents git and github accounts,
#               inclusive you log into your default browser
# keywords: Bash, Git, Github, JQ, gh
# author: JJWizardMP
# lastupdate: 22/05/2022
###################################################################################
# @params
# option: may be "github", "git" or "both" (for git and github account)
# account: label for a git account
# method: may be "token" or "browser" (Optional argument)
###################################################################################
declare -A ERRORS_MSGS=( \
    [TWO_ARGS_REQUIRED]='Pass the two require arguments!\n' \
    [FIRST_ARG_WRONG]='The first argument must be \"git\", \"github\" or \"both\"!\n' \
    [SECOND_ARG_WRONG]='Account is not defined in config.json file!\n'
    [THIRD_ARG_REQUIRED]='Pass the third arguments if you \
    use \"both\"  or \"github\" login!\n' \
    [THIRD_ARG_WRONG]='Pass \"token\" or \"browser\" as the third arguments \
    for select the mode of authentication' \
)

declare -A STATE_MSGS=( \
    [CURRENT_C]='Current credentials ...\n' \
    [CURRENT_S]='Current status ...\n' \
    [CURRENT_CS]='Current credentials and status...\n' \
    [SETTING_C]='Setting credentials ...\n' \
    [LOGIN]='Log In ...\n'
    [NEW_C]='New credentials ...\n' \
    [NEW_S]='New status ...\n' \
    [DOTS]='"\n........................................\n"' \
    [COMPLETED]='...........................\nCompleted!\n' \
)

declare -A G_MSGS=( \
    [GIT]='Git: \n' \
    [GITHUB]='Github: \n' \
)
setEnvVars(){
    export option=$1
    export account=$2
    export method=$3
}
unsetEnvVars(){
    unset option
    unset account
    unset method
    unset user
    unset email
    unset token
    unset ERRORS_MSGS
    unset STATE_MSGS
    unset G_MSGS
}
resetBash(){
    exec bash
    su - $(whoami)
}
# Show git credentials
showGitCredentials(){
    git config --list --show-origin
}
# Show github-cli status
showGithubStatus(){
    gh auth status
}
# delete file with the github tokenen
deleteToken(){
    if [[ -e /tmp/tokengithub ]]
    then
        rm /tmp/tokengithub
    fi
}
# Extract git credentials from a json file with the option jq
# (for more read the doc for jq)
setVariables(){
    export user=$( jq ".$account.user" config.json | tr -d '"' )
    export email=$( jq ".$account.email" config.json | tr -d '"' )
    export token=$( jq ".$account.token" config.json | tr -d '"' )
    echo $token > /tmp/tokengithub
}
# Change git credentials from a json file with the option jq
# (for more read the doc for jq)
changeGitCredentials() {
    git config --global user.name "$user"
    git config --global user.email "$email"
    git config --global user.mail "$email"
}
# Change github credentials from a json file with the option jq
# (for more read the doc for jq)
changeGithubCredentials(){
    gh auth logout
    case $method in
        token)
            gh auth login --with-token < /tmp/tokengithub
        ;;
        browser)
            gh auth login --web
        ;;
        *)
            throwError_thirdArgWrong
        ;;
    esac
}
verifyArguments(){
    throwError_twoArgsRequired
    throwError_secondArgWrong
    throwError_thirdArgRequired
}
throwError_twoArgsRequired(){
    if [[ -z $option ]] || [[ -z $account ]]
    then
        echo -e ${ERRORS_MSGS[TWO_ARGS_REQUIRED]}
        exit 1
    fi
}
throwError_thirdArgRequired(){
    if ( [[ $option = "both" ]] || [[ $option = "github" ]] ) && [[ -z $method ]]
    then
        echo -e ${ERRORS_MSGS[THIRD_ARG_REQUIRED]}
        exit 1
    fi
}
throwError_firstArgWrong(){
    echo -e ${ERRORS_MSGS[FIRST_ARG_WRONG]}
    exit 1
}
throwError_secondArgWrong(){
    testaccount=$( jq ".$account.user" config.json )
    if [[ $testaccount == "null" ]]
    then
        echo -e ${ERRORS_MSGS[SECOND_ARG_WRONG]}
        exit 1
    fi
}
throwError_thirdArgWrong(){
    echo -e ${ERRORS_MSGS[THIRD_ARG_WRONG]}
    exit 1
}
# Main script
main(){
    setEnvVars $1 $2 $3
    verifyArguments
    setVariables
    case $option in
        git)
            echo -e ${STATE_MSGS[CURRENT_C]}
            echo -e ${G_MSGS[GIT]}
            showGitCredentials
            echo -e ${STATE_MSGS[DOTS]}
            echo -e ${STATE_MSGS[SETTING_C]}
            changeGitCredentials
            echo -e ${STATE_MSGS[DOTS]}
            echo -e ${STATE_MSGS[NEW_C]}
            echo -e ${G_MSGS[GIT]}
            showGitCredentials
            echo -e ${STATE_MSGS[COMPLETED]}
        ;;
        github)
            echo -e ${STATE_MSGS[CURRENT_S]}
            echo -e ${G_MSGS[GITHUB]}
            showGithubStatus
            echo -e ${STATE_MSGS[DOTS]}
            echo -e ${STATE_MSGS[LOGIN]}
            changeGithubCredentials
            echo -e ${STATE_MSGS[DOTS]}
            echo -e ${STATE_MSGS[NEW_S]}
            echo -e ${G_MSGS[GITHUB]}
            showGithubStatus
            echo -e ${STATE_MSGS[COMPLETED]}
        ;;
        both)
            echo -e ${STATE_MSGS[CURRENT_CS]}
            echo -e ${G_MSGS[GIT]}
            showGitCredentials
            echo -e ${G_MSGS[GITHUB]}
            showGithubStatus
            echo -e ${STATE_MSGS[DOTS]}
            echo -e ${STATE_MSGS[SETTING_C]}
            changeGitCredentials
            echo -e ${STATE_MSGS[LOGIN]}
            changeGithubCredentials
            echo -e ${STATE_MSGS[DOTS]}
            echo -e ${STATE_MSGS[NEW_C]}
            echo -e ${G_MSGS[GIT]}
            showGitCredentials
            echo -e ${STATE_MSGS[NEW_S]}
            echo -e ${G_MSGS[GITHUB]}
            showGithubStatus
            echo -e ${STATE_MSGS[COMPLETED]}
        ;;
        *)
            throwError_firstArgWrong
        ;;
    esac
    deleteToken
    unsetEnvVars
    resetBash
}

main $1 $2 $3

exit 0