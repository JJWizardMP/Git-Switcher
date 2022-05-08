#!/bin/bash
# @argument mac or linux only
SYSTEM=$1
installDependecies(){
    while read -r line
    do
        case $SYSTEM in
            linux)
                sudo apt install "$line"
            ;;
            mac)
                sudo brew install "$line"
            ;;
            *)
                echo "Pass \"mac\" or \"linux\" for select the operating system"
                exit 1
            ;;
        esac
    done < requirements
}

installDependecies

exit 0