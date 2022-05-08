#!/bin/bash
# argument mac o linux only
SYSTEM=$1
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
            echo "Pass \"mac\" o \"linux\" for select the operating system"
        ;;
    esac
done < requirements

exit 0