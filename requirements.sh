#!/bin/bash
###################################################################################
# name: Requirements Script
# version: 1.0.1
# description: This script install all dependecies in the requirements file
# keywords: Bash, Dependecies
# author: JJWizardMP
# lastupdate: 15/05/2022
###################################################################################
# arguments:
# @SYSTEM:
#   mac: Mac OS
#   debian: Ubuntu/Debian
#   rhl(Red Hat Linux Original): RHEL / CentOS / Fedora (yum)
#   open: OpenSUSE
#   arch: ArchLinux
###################################################################################
declare -A ERRORS_MSGS=( [SYSTEM]="Pass the correct argument for select \
the operating system:\n-debian\n-rhl\n-open\n-arch\n-mac" )
# Handle enviroment variables
setEnvVars(){
    export SYSTEM=$1
}
unsetEnvVars(){
    unset SYSTEM
}
# Handle argument error
throwError_wrongSystem(){
    echo -e ${ERRORS_MSGS[SYSTEM]}
    exit 1
}
# Update dependecies before install requirements
updateSystemDependecies(){
    case $SYSTEM in
        debian)
            sudo apt update -y
        ;;
        rhl)
            sudo yum update -y
        ;;
        open)
            sudo zypper update -y
        ;;
        arch)
            sudo pacman -Sy
        ;;
        mac)
            sudo brew update -y
        ;;
        *)
            throwError_wrongSystem
        ;;
    esac
}
# Install Dependecies for project
installDependecies(){
    while read -r line
    do
        case $SYSTEM in
            debian)
                sudo apt install "$line" -y
            ;;
            rhl)
                sudo yum install "$line" -y
            ;;
            open)
                sudo zypper install "$line" -y
            ;;
            arch)
                sudo pacman -Sy install "$line"
            ;;
            mac)
                sudo brew install "$line" -y
            ;;
            *)
                throwError_wrongSystem
            ;;
        esac
    done < requirements
}
# Main Function
main(){
    setEnvVars $1
    updateSystemDependecies
    installDependecies
    unsetEnvVars
}
# Run main function
main $1
exit 0