#!/usr/bin/env bash
# @ VERSION   0.2.0
# @ AUTHOR    John Yoon
# @ LICENSE   MIT
#   
#   For initial setup, run "source env_setup.sh" to create virtual python environment 
#       for MNIST_DNN project.
#
#   If there's any issues, please contact John Yoon <fedelejohn7008@gmail.com>
#
#   ** This setup will create "dev/" file, do not upload this to git **
#   ** Do not upgrade venv pip to the newest version, it may cause critical bug **

# script configuration data
PROJECT="MNIST_DNN"
VERSION="0.2.0"
CLEAR=False
HELP=False
REFRESH=False
INSTRUCTION=False
SETTINGS_FILE="settings.txt"
INITIAL_DIR=$(pwd)

# validate configurable os
if [[ "${OSTYPE}" == "linux-gnu"* ]]; then
    OS="${OSTYPE}"
    VERIFIED_OS="False"
elif [[ "${OSTYPE}" == "darwin"* ]]; then
    OS="MacOS"
    VERIFIED_OS="True"
elif [[ "${OSTYPE}" == "cygwin" ]]; then
    # POSIX compatibility layer and Linux environment emulation for Windows
    OS="cygwin"
    VERIFIED_OS="False"
elif [[ "${OSTYPE}" == "msys" ]]; then
    # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    OS="Windows"
    VERIFIED_OS="True"
elif [[ "${OSTYPE}" == "win32" ]]; then
    OS="${OSTYPE}"
    VERIFIED_OS="False"
elif [[ "${OSTYPE}" == "freebsd"* ]]; then
    OS="${OSTYPE}"
    VERIFIED_OS="False"
else
    OS="${OSTYPE}"
    VERIFIED_OS="False"
fi

# continue with script configuration data
if [[ ${OS} == MacOS ]]; then
    PROJECT_ROOT=${0:a:h}
else
    PROJECT_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
fi
# IF Project root path contains 'space', it will cause error
if [[ "${PROJECT_ROOT}" =~ ( ) ]]; then
    echo -e "\e[33m[WARNING] Project root path contains 'space' which is not allowed: ${PROJECT_ROOT}.\e[0m"
    echo -e "Please move the project to different location and try again - run 'pwd' command to check if current directory contains 'space'"
    return 1 2> /dev/null; exit 1
fi
LOG_DIR="${PROJECT_ROOT}/dev/log/env_setup"

# helper functions
is_sourced() {
    if [ -n "$ZSH_VERSION" ]; then 
        case $ZSH_EVAL_CONTEXT in *:file:*) return 0;; esac
    else # Add additional POSIX-compatible shell names here, if needed.
        case ${0##*/} in dash|-dash|bash|-bash|ksh|-ksh|sh|-sh) return 0;; esac
    fi
    return 1  # NOT sourced.
}

usage () {
    echo -e "To setup virtual environment for MNIST_DNN project development, goto project's directory and run \"\e[3m\e[35msource env_setup.sh\e[0m\""
    echo -e "For any issues, please notify John Yoon <\e[4mfedelejohn7008@gmail.com\e[0m>"
    echo -e ""
    echo -e "\e[1mUsage:\e[0m"
    echo -e "  \e[35msource env_setup.sh \e[3m\e[33m<option>\e[0m"
    echo -e ""
    echo -e "\e[1mOptions:\e[0m"
    echo -e "  \e[3m\e[33m-c\e[0m, \e[3m\e[33m--clear\e[0m\t\tRemove the setting."
    echo -e "  \e[3m\e[33m-h\e[0m, \e[3m\e[33m--help\e[0m\t\tShow help."
    echo -e "  \e[3m\e[33m-i\e[0m, \e[3m\e[33m--instruction\e[0m\tShow instructions."
    echo -e "  \e[3m\e[33m-r\e[0m, \e[3m\e[33m--refresh\e[0m\t\tReset the setting."
}

instruction () {
    echo -e "\e[36mMNIST_DNN DEVELOP ENVIRONMENT FEATURES\e[0m"
    echo -e "\e[1mVariables:\e[0m"
    echo -e "  \e[33mPROJECT_ROOT\e[0m\t\t\tPath to MNIST_DNN repository root."
    echo -e "  \e[33mOS\e[0m\t\t\t\tCurrent running environment's operating system."
    echo -e "  \e[33mMNIST_DEV\e[0m\t\t\tCurrently activated MNIST developing virtual environment."
    echo -e ""
    echo -e "\e[1mFunctions:\e[0m"
    echo -e "  \e[33mroot\e[0m\t\t\t\tMove to MNIST_DNN repository root"
    echo -e "  \e[33mdnn\e[0m\t\t\t\tMove to dnn package root"
    echo -e "  \e[33mapi\e[0m\t\t\t\tMove to api package root"
    echo -e "  \e[33mstatus\e[0m\t\t\tshow current status of project setup"
    echo -e "  \e[33menter \e[3m<option>\e[0m\t\tActivate or Deactivate virtual environment for development (use 'enter help' for the usage)"
    echo -e "  \e[33mupdate_package \e[3m<option>\e[0m\tUpdate requirements.txt for selected package (use 'update_package help' for the usage)"
    echo -e ""
    echo -e "NOTE: Python project should be run while virtual environment is activated."
}

set_alias () {
    MNIST_DEV=NONE
    alias root="cd '${PROJECT_ROOT}'; echo -e \"\e[35mMOVING TO ${PROJECT} ROOT\e[0m\""
    alias dnn="cd '${PROJECT_ROOT}/packages/dnn'; echo -e \"\e[35mMOVING TO MNIST_DNN PACKAGE\e[0m\""
    alias api="cd '${PROJECT_ROOT}/packages/api'; echo -e \"\e[35mMOVING TO MNIST_DNN_API PACKAGE\e[0m\""

    status () {
        echo -e "\e[36m${PROJECT} ENVIRONMENT\e[0m"
        echo -e "  \e[33m\${PROJECT_ROOT}\e[0m = ${PROJECT_ROOT}"
        echo -e "  \e[33m\${OS}\e[0m = ${OS}"
        echo -e "  \e[33m\${SHELL}\e[0m = ${SHELL}"
        echo -e "  \e[33m\${MNIST_DEV}\e[0m = ${MNIST_DEV}"
    }

    enter () {
        if [[ ${OS} == "Windows" ]]; then
            _PATH_TO_ACTIVATE="Scripts"
        else
            _PATH_TO_ACTIVATE="bin"
        fi

        if [[ ${#} -eq 0 ]]; then
            echo -e "\e[35mDEACTIVATING ${MNIST_DEV}\e[0m"
            deactivate 1> /dev/null 2> /dev/null
            MNIST_DEV=NONE
            return 0
        elif [[ ${#} -eq 1 ]]; then
            if [[ ${1} == "d" || ${1} == "dnn" ]]; then
                if [[ ${MNIST_DEV} == "DNN" ]]; then
                    echo -e "\e[33mYOU ARE ALREADY IN DNN ENVIRONMENT\e[0m"
                    return 0
                elif [[ ${MNIST_DEV} != "NONE" ]]; then
                    echo -e "\e[35mDEACTIVATING ${MNIST_DEV}\e[0m"
                    deactivate 1> /dev/null 2> /dev/null
                    MNIST_DEV=NONE
                fi
                source ${PROJECT_ROOT}/dev/mnist-dnn-venv/${_PATH_TO_ACTIVATE}/activate
                echo -e "\e[36mACTIVATING DNN\e[0m"
                MNIST_DEV=DNN
                return 0
            elif [[ ${1} == "a" || ${1} == "api" ]]; then
                if [[ ${MNIST_DEV} == "API" ]]; then
                    echo -e "\e[33mYOU ARE ALREADY IN API ENVIRONMENT\e[0m"
                    return 0
                elif [[ ${MNIST_DEV} != "NONE" ]]; then
                    echo -e "\e[35mDEACTIVATING ${MNIST_DEV}\e[0m"
                    deactivate 1> /dev/null 2> /dev/null
                    MNIST_DEV=NONE
                fi
                source ${PROJECT_ROOT}/dev/mnist-api-venv/${_PATH_TO_ACTIVATE}/activate
                echo -e "\e[36mACTIVATING API\e[0m"
                MNIST_DEV=API
                return 0
            elif [[ ${1} == "p" || ${1} == "publish" ]]; then
                if [[ ${MNIST_DEV} == "PUBLISH" ]]; then
                    echo -e "\e[33mYOU ARE ALREADY IN PUBLISH ENVIRONMENT\e[0m"
                    return 0
                elif [[ ${MNIST_DEV} != "NONE" ]]; then
                    echo -e "\e[35mDEACTIVATING ${MNIST_DEV}\e[0m"
                    deactivate 1> /dev/null 2> /dev/null
                    MNIST_DEV=NONE
                fi
                source ${PROJECT_ROOT}/dev/publish-venv/${_PATH_TO_ACTIVATE}/activate
                echo -e "\e[36mACTIVATING PUBLISH\e[0m"
                MNIST_DEV=PUBLISH
                return 0
            elif [[ ${1} == "o" || ${1} == "off" ]]; then
                echo -e "\e[35mDEACTIVATING ${MNIST_DEV}\e[0m"
                deactivate 1> /dev/null 2> /dev/null
                MNIST_DEV=NONE
                return 0
            elif [[ ${1} == "h" || ${1} == "help" ]]; then
                echo -e "\e[1mPurpose:\e[0m"
                echo -e "  Enter the virtual environment for ${PROJECT} components: publish, dnn, api"
                echo -e ""
                echo -e "\e[1mUsage:\e[0m"
                echo -e "  \e[35menter \e[3m\e[33m<option>\e[0m"
                echo -e ""
                echo -e "\e[1mOptions:\e[0m"
                echo -e "  \e[3m\e[33ma\e[0m, \e[3m\e[33mapi\e[0m\t\tEnter mnist-api-venv."
                echo -e "  \e[3m\e[33md\e[0m, \e[3m\e[33mdnn\e[0m\t\tEnter mnist-dnn-venv."
                echo -e "  \e[3m\e[33mp\e[0m, \e[3m\e[33mpublish\e[0m\t\tEnter publish-venv."
                echo -e "  \e[3m\e[33mo\e[0m, \e[3m\e[33moff\e[0m\t\tDeactivate from current virtual environment."
                echo -e "  \e[3m\e[33mh\e[0m, \e[3m\e[33mhelp\e[0m\t\tShow this help."
                echo -e ""
                echo -e "\e[35m\e[1m\e[3mIf you leave \e[33m<option>\e[35m blank, it will deactivate current virtual environment.\e[0m"
                return 0
            else
                echo -e "\e[31mINVALID ARGUMENT: ${@}\e[0m"
                echo -e "\e[33mPlease check \e[3m'enter help'\e[0m\e[33m for the usage."
                return 1
            fi
        else
            echo -e "\e[31mINVALID ARGUMENT: ${@}\e[0m"
            echo -e "\e[33mPlease check \e[3m'enter help'\e[0m\e[33m for the usage."
            return 1
        fi
    }

    update_package () {
        if [[ ${OS} == "Windows" ]]; then
            _PATH_TO_ACTIVATE="Scripts"
        else
            _PATH_TO_ACTIVATE="bin"
        fi

        if [[ ${#} -eq 0 ]]; then
            echo -e "\e[31mINVALID ARGUMENT: Please check \e[3m'update_package help'\e[0m\e[31m for the usage.\e[0m"
            return 1
        elif [[ ${#} -eq 1 ]]; then
            if [[ ${1} == "a" || ${1} == "api" ]]; then
                _CURRENT_DEV=${MNIST_DEV}
                if [[ ${MNIST_DEV} != "NONE" && ${MNIST_DEV} != "API" ]]; then
                    deactivate 1> /dev/null 2> /dev/null
                    MNIST_DEV=NONE
                fi

                if [[ ${MNIST_DEV} == "NONE" ]]; then
                    source ${PROJECT_ROOT}/dev/mnist-api-venv/${_PATH_TO_ACTIVATE}/activate
                    MNIST_DEV=API
                fi
                
                pip freeze --exclude-editable > ${PROJECT_ROOT}/packages/api/requirements.txt
                
                deactivate 1> /dev/null 2> /dev/null
                if [[ ${_CURRENT_DEV} == "PUBLISH" ]]; then
                    source ${PROJECT_ROOT}/dev/publish-venv/${_PATH_TO_ACTIVATE}/activate
                elif [[ ${_CURRENT_DEV} == "API" ]]; then
                    source ${PROJECT_ROOT}/dev/mnist-api-venv/${_PATH_TO_ACTIVATE}/activate
                elif [[ ${_CURRENT_DEV} == "DNN" ]]; then
                    source ${PROJECT_ROOT}/dev/mnist-dnn-venv/${_PATH_TO_ACTIVATE}/activate
                fi
                MNIST_DEV=${_CURRENT_DEV}
            elif [[ ${1} == "d" || ${1} == "dnn" ]]; then
                _CURRENT_DEV=${MNIST_DEV}
                if [[ ${MNIST_DEV} != "NONE" && ${MNIST_DEV} != "DNN" ]]; then
                    deactivate 1> /dev/null 2> /dev/null
                    MNIST_DEV=NONE
                fi

                if [[ ${MNIST_DEV} == "NONE" ]]; then
                    source ${PROJECT_ROOT}/dev/mnist-dnn-venv/${_PATH_TO_ACTIVATE}/activate
                    MNIST_DEV=DNN
                fi
                
                pip freeze --exclude-editable > ${PROJECT_ROOT}/packages/dnn/requirements.txt
                
                deactivate 1> /dev/null 2> /dev/null
                if [[ ${_CURRENT_DEV} == "PUBLISH" ]]; then
                    source ${PROJECT_ROOT}/dev/publish-venv/${_PATH_TO_ACTIVATE}/activate
                elif [[ ${_CURRENT_DEV} == "API" ]]; then
                    source ${PROJECT_ROOT}/dev/mnist-api-venv/${_PATH_TO_ACTIVATE}/activate
                elif [[ ${_CURRENT_DEV} == "DNN" ]]; then
                    source ${PROJECT_ROOT}/dev/mnist-dnn-venv/${_PATH_TO_ACTIVATE}/activate
                fi
                MNIST_DEV=${_CURRENT_DEV}
            elif [[ ${1} == "h" || ${1} == "help" ]]; then
                echo -e "\e[1mPurpose:\e[0m"
                echo -e "  Update the current libraries enlisted in selected virtual environment into requirements.txt"
                echo -e ""
                echo -e "\e[1mUsage:\e[0m"
                echo -e "  \e[35mupdate_package \e[3m\e[33m<option>\e[0m"
                echo -e ""
                echo -e "\e[1mOptions:\e[0m"
                echo -e "  \e[3m\e[33ma\e[0m, \e[3m\e[33mapi\e[0m\t\tUpdate packages/api/requirements.txt to current libraries installed in mnist-api-venv."
                echo -e "  \e[3m\e[33md\e[0m, \e[3m\e[33mdnn\e[0m\t\tUpdate packages/dnn/requirements.txt to current libraries installed in mnist-dnn-venv."
                echo -e "  \e[3m\e[33mh\e[0m, \e[3m\e[33mhelp\e[0m\t\tShow this help."
                return 0
            else
                echo -e "\e[31mINVALID ARGUMENT: ${@}\e[0m"
                echo -e "\e[33mPlease check \e[3m'update_package help'\e[0m\e[33m for the usage."
                return 1
            fi
        else
            echo -e "\e[31mINVALID ARGUMENT: ${@}\e[0m"
            echo -e "\e[33mPlease check \e[3m'update_package help'\e[0m\e[33m for the usage."
            return 1
        fi
    }

    export -f enter
    export -f status
    export -f update_package
}

# argument parsing 
if [[ ${#} -eq 1 ]]; then
    if [[ ${1} == "-c" || ${1} == "--clear" ]]; then
        CLEAR="True"
    elif [[ ${1} == "-h" || ${1} == "--help" ]]; then
        HELP="True"
    elif [[ ${1} == "-i" || ${1} == "--instruction" ]]; then
        INSTRUCTION="True"
    elif [[ ${1} == "-r" || ${1} == "--refresh" ]]; then
        CLEAR="True"
        REFRESH="True"
    else
        echo -e "\e[31mInvalid option value, please check \"source env_setup.sh --help\" for help.\e[0m"
        return 1 2> /dev/null; exit 1
    fi
elif [[ ${#} -gt 1 ]]; then
    echo -e "\e[31mInvalid option value, please check \"source env_setup.sh --help\" for usage.\e[0m"
    return 1 2> /dev/null; exit 1
fi

# help flag
if [[ ${HELP} == True ]]; then
    # print help
    usage

    # exit with code 0
    return 0 2> /dev/null; exit 0
fi

# instruction flag
if [[ ${INSTRUCTION} == True ]]; then
    # print instruction
    instruction

    # exit with code 0
    return 0 2> /dev/null; exit 0
fi

# script description
echo -e "\e[36m${PROJECT} ENVIRONMENT SETUP ROUTINE\e[0m"

echo -e "\e[0m   VERSION: \t\e[32m${VERSION}\e[0m"

echo -en "\e[0m   SOURCED: "
(return 0 2>/dev/null) && sourced=1 || sourced=0
if [[ ${sourced} -eq 0 ]]; then
    echo -e "\t\e[31mFalse\e[0m"
    echo -e "\e[31m[WARNING] Script is not sourced, please run \e[3m\"source env_setup.sh\"\e[0m\e[31m instead.\e[0m"
    echo -e "For more information, please check \e[3m\"source env_setup.sh --help\"\e[0m for more usages."
    return 1 2> /dev/null; exit 1
else
    echo -e "\t\e[32mTrue\e[0m"
fi

echo -en "\e[0m        OS: \t\e[0m"
if [[ ${VERIFIED_OS} == True ]]; then
    echo -e "\e[32m${OS} (VERIFIED)\e[0m"
else
    echo -e "\e[31m${OS} (NOT VERIFIED)\e[0m"
    echo -e "\e[33m[WARNING] Not verified OS setup may cause unexpected error.\e[0m"
    echo -e "Would you like to continue anyway? [y/N]\e[0m"
    read _USER_ANSWER
    if [[ ${_USER_ANSWER} =~ (y|Y)((e|E)(s|S))? ]]; then
        echo -e "\e[32mProceeding the setup\e[0m"
    else
        echo -e "\e[31mAborting the setup\e[0m"
        return 1 2> /dev/null; exit 1
    fi
fi

echo -e "\e[0m     SHELL: \t\e[32m${SHELL}\e[0m"
echo -e "\e[0m      ROOT: \t\e[32m${PROJECT_ROOT}\e[0m"

# goto project root
cd ${PROJECT_ROOT}

# clear flag
if [[ ${CLEAR} == True ]]; then
    echo -e ""
    echo -e "\e[36mREMOVING ${PROJECT} ENVIRONMENT SETUP\e[0m"
    echo -en "Removing 'dev/' --- "
    if [[ -d "dev" ]]; then
        # remove 'dev/'
        rm -rf dev/
        echo -e "\e[32mDone\e[0m"

        # exit when refresh flag is down
        if [[ ${REFRESH} == False ]]; then
            # go back to initial directory
            cd ${INITIAL_DIR}

            # exit with code 0
            return 0 2> /dev/null; exit 0
        fi
    else
        echo -e "\e[32m'dev/' not found\e[0m"
        if [[ ${REFRESH} == False ]]; then
            # go back to initial directory
            cd ${INITIAL_DIR}
            
            # exit with code 0
            return 0 2> /dev/null; exit 0
        fi
    fi
fi

# If setting file already exists
if [[ -f dev/.${SETTINGS_FILE} ]]; then
    # Check the verison
    cat "dev/.${SETTINGS_FILE}" | egrep "version==${VERSION}" 1> /dev/null 2> /dev/null
    if [[ ${?} -eq 0 ]]; then
        # set alias
        set_alias 1> /dev/null 2> /dev/null

        # current version is already installed, show instruction and exit
        echo -e ""
        echo -e "\e[36mENVIRONMENT SETUP COMPLETED\e[0m"
        echo -e "\e[90mIf you want to refresh the setup, run \"source env_setup.sh --refresh\"\e[0m"
        echo -e ""

        # print instruction
        instruction

        # go back to initial directory
        cd ${INITIAL_DIR}
        
        # exit with code 0
        return 0 2> /dev/null; exit 0
    else
        # new version is available clear the dev/
        echo -e "New update is found, proceeding upgrade"
        rm -rf dev/
    fi
fi

echo -e ""
echo -e "\e[36mCREATING ${PROJECT} DEVELOPING ENVIRONMENT\e[0m"

# Create dev local directory for the virtual environment (this is not commited to git)
echo -en "Creating 'dev/' --- "
if [[ ! -d "dev" ]]; then
    mkdir "dev"
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[32malready exists\e[0m"
fi

# Search for python executable
# Python version ordering is from most prefered version to least prefered version
PYTHON_LIST=('python3.10' 'python3.9' 'python3.8' 'python3' 'python3.11' 'python3.7' 'python3.6' 'python')
_ALTERNATIVE=False
_FOUND=False

for python_version in ${PYTHON_LIST[@]}; do
    # locate Python
    if [[ ${_ALTERNATIVE} == True ]]; then
        echo -e "\e[33mSearch for alternative: ${python_version}\e[0m"
    fi
    echo -en "Locating ${python_version} --- "
    which ${python_version} 1> /dev/null 2> /dev/null
    PYTHON_INSTALLED=${?}
    if [[ ${PYTHON_INSTALLED} == 0 ]]; then
        echo -e "\e[32mDone\e[0m"

        # verify python
        echo -en "Verifying ${python_version} --- "
        PYTHON_LOC=$(which ${python_version})
        ${PYTHON_LOC} -V 1> /dev/null 2> /dev/null
        PYTHON_VERIFIED=${?}

        if [[ ${PYTHON_VERIFIED} == 0 ]]; then
            echo -e "\e[32mDone\e[0m"

            # verify pip3
            echo -en "Verifying pip --- "
            ${PYTHON_LOC} -m pip -V 1> /dev/null 2> /dev/null
            PIP_VERIFIED=${?}
            if [[ ${PIP_VERIFIED} == 0 ]]; then
                echo -e "\e[32mDone\e[0m"
                _FOUND=True
                break
            else
                echo -e "\e[31mFailed\e[0m"
                _ALTERNATIVE=True
            fi
        else
            echo -e "\e[31mFailed\e[0m"
            _ALTERNATIVE=True
        fi
    else
        echo -e "\e[31mFailed\e[0m"
        _ALTERNATIVE=True
    fi
done

if [[ ${_FOUND} == False ]]; then
    echo -e "\e[31mPython not found\e[0m"

    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

if [[ ! -e "${LOG_DIR}" ]]; then
    mkdir -p "${LOG_DIR}"
fi

# Upgrade pip to the newest version
echo -en "Upgrading pip --- "
if [[ -f "${LOG_DIR}/main_pip_upgrade.log" ]]; then
    rm -f "${LOG_DIR}/main_pip_upgrade.log"
fi
${PYTHON_LOC} -m pip install --upgrade pip >> "${LOG_DIR}/main_pip_upgrade.log" 2>&1
if [[ ${?} == 0 ]]; then
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[31mFailed\e[0m"
    echo -en "\e[90m"; cat "${LOG_DIR}/main_pip_upgrade.log"; echo -e "\e[31mAborting the setup\e[0m"

    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

# Install virtualenv
echo -en "Installing virtualenv --- "
if [[ -f "${LOG_DIR}/main_install_virtualenv.log" ]]; then
    rm -f "${LOG_DIR}/main_install_virtualenv.log"
fi
${PYTHON_LOC} -m pip list | egrep "virtualenv" 1> /dev/null 2> /dev/null
if [[ ${?} == 0 ]]; then
    echo -e "\e[32malready exists\e[0m"
else
    ${PYTHON_LOC} -m pip install virtualenv >> "${LOG_DIR}/main_install_virtualenv.log" 2>&1
    if [[ ${?} == 0 ]]; then
        echo -e "\e[32mDone\e[0m"
    else
        echo -e "\e[31mFailed\e[0m"
        echo -en "\e[90m"; cat "${LOG_DIR}/main_install_virtualenv.log"; echo -e "\e[31mAborting the setup\e[0m"

        # go back to initial directory
        cd ${INITIAL_DIR}
        
        # exit with code 1
        return 1 2> /dev/null; exit 1
    fi
fi

#########################################################################
# Initiate virtual environment for package publishing
echo -en "Creating 'dev/publish-venv' --- "
if [[ -f "${LOG_DIR}/main_create_publish_venv.log" ]]; then
    rm -f "${LOG_DIR}/main_create_publish_venv.log"
fi
${PYTHON_LOC} -m venv dev/publish-venv >> "${LOG_DIR}/main_create_publish_venv.log" 2>&1
if [[ ${?} == 0 ]]; then
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[31mFailed\e[0m"
    echo -en "\e[90m"; cat "${LOG_DIR}/main_create_publish_venv.log"; echo -e "\e[31mAborting the setup\e[0m"
    
    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

# Activate venv
echo -en "Activating 'dev/publish-venv' --- "
if [[ -f "${LOG_DIR}/main_activate_publish_venv.log" ]]; then
    rm -f "${LOG_DIR}/main_activate_publish_venv.log"
fi
if [[ ${OS} == "Windows" ]]; then
    source dev/publish-venv/Scripts/activate >> "${LOG_DIR}/main_activate_publish_venv.log" 2>&1
else
    source dev/publish-venv/bin/activate >> "${LOG_DIR}/main_activate_publish_venv.log" 2>&1
fi

if [[ ${?} == 0 ]]; then
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[31mFailed\e[0m"
    echo -en "\e[90m"; cat "${LOG_DIR}/main_activate_publish_venv.log"; echo -e "\e[31mAborting the setup\e[0m"
    
    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

# Parse python
if [[ ${OS} == "Windows" ]]; then
    VENV_PYTHON_LOC="${PROJECT_ROOT}/dev/publish-venv/Scripts/python"
    VENV_PIP_LOC="${PROJECT_ROOT}/dev/publish-venv/Scripts/pip"
else
    VENV_PYTHON_LOC="${PROJECT_ROOT}/dev/publish-venv/bin/python"
    VENV_PIP_LOC="${PROJECT_ROOT}/dev/publish-venv/bin/pip"
fi

# Do not upgrade venv pip to the newest version, it may cause critical bug.

# Install publish-purpose packages
echo -en "Installing required packages [1/1] --- "
if [[ -f "${LOG_DIR}/publish_venv_install_packages.log" ]]; then
    rm -f "${LOG_DIR}/publish_venv_install_packages.log"
fi

_FAILED=False
publish_venv_packages=('setuptools' 'wheel' 'build' 'twine')
for _package in ${publish_venv_packages[@]}; do
    ${VENV_PIP_LOC} install ${_package} >> "${LOG_DIR}/publish_venv_install_packages.log" 2>&1
    if [[ ${?} != 0 ]]; then
        _FAILED=True
        break
    fi
done

if [[ ${_FAILED} == False ]]; then
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[31mFailed\e[0m"
    echo -en "\e[90m"; cat "${LOG_DIR}/publish_venv_install_packages.log"; echo -e "\e[31mAborting the setup\e[0m"

    # deactivate venv
    deactivate

    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

# deactivate publish-venv
deactivate
if [[ ${?} != 0 ]]; then
    echo -e "\e[33mSomething went wrong - deactivating 'publish-venv' unsuccessful\e[0m"

    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

#########################################################################
# Initiate virtual environment for dnn package
echo -en "Creating 'dev/mnist-dnn-venv' --- "
if [[ -f "${LOG_DIR}/main_create_dnn_venv.log" ]]; then
    rm -f "${LOG_DIR}/main_create_dnn_venv.log"
fi
${PYTHON_LOC} -m venv dev/mnist-dnn-venv >> "${LOG_DIR}/main_create_dnn_venv.log" 2>&1
if [[ ${?} == 0 ]]; then
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[31mFailed\e[0m"
    echo -en "\e[90m"; cat "${LOG_DIR}/main_create_dnn_venv.log"; echo -e "\e[31mAborting the setup\e[0m"
    
    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

# Activate venv
echo -en "Activating 'dev/mnist-dnn-venv' --- "
if [[ -f "${LOG_DIR}/main_activate_dnn_venv.log" ]]; then
    rm -f "${LOG_DIR}/main_activate_dnn_venv.log"
fi
if [[ ${OS} == "Windows" ]]; then
    source dev/mnist-dnn-venv/Scripts/activate >> "${LOG_DIR}/main_activate_dnn_venv.log" 2>&1
else
    source dev/mnist-dnn-venv/bin/activate >> "${LOG_DIR}/main_activate_dnn_venv.log" 2>&1
fi

if [[ ${?} == 0 ]]; then
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[31mFailed\e[0m"
    echo -en "\e[90m"; cat "${LOG_DIR}/main_activate_dnn_venv.log"; echo -e "\e[31mAborting the setup\e[0m"
    
    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

# Parse python
if [[ ${OS} == "Windows" ]]; then
    VENV_PYTHON_LOC="${PROJECT_ROOT}/dev/mnist-dnn-venv/Scripts/python"
    VENV_PIP_LOC="${PROJECT_ROOT}/dev/mnist-dnn-venv/Scripts/pip"
else
    VENV_PYTHON_LOC="${PROJECT_ROOT}/dev/mnist-dnn-venv/bin/python"
    VENV_PIP_LOC="${PROJECT_ROOT}/dev/mnist-dnn-venv/bin/pip"
fi

# Do not upgrade venv pip to the newest version, it may cause critical bug.

# Install required packages for dnn
echo -en "Installing required packages [1/1] --- "
if [[ -f "${LOG_DIR}/dnn_venv_install_packages.log" ]]; then
    rm -f "${LOG_DIR}/dnn_venv_install_packages.log"
fi

_FAILED=False
if [[ ${OS} == "MacOS" ]]; then
    # zsh equivalent of readarray in bash
    dnn_venv_packages=("${(f)$(< "${PROJECT_ROOT}/packages/dnn/requirements.txt")}")
else
    readarray -t dnn_venv_packages < "${PROJECT_ROOT}/packages/dnn/requirements.txt"
fi

for _package in ${dnn_venv_packages[@]}; do
    ${VENV_PIP_LOC} install ${_package} >> "${LOG_DIR}/dnn_venv_install_packages.log" 2>&1
    if [[ ${?} != 0 ]]; then
        _FAILED=True
        break
    fi
done

if [[ ${_FAILED} == False ]]; then
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[31mFailed\e[0m"
    echo -en "\e[90m"; cat "${LOG_DIR}/dnn_venv_install_packages.log"; echo -e "\e[31mAborting the setup\e[0m"

    # deactivate venv
    deactivate

    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

# Add project to site-package
echo -en "Linking 'mnist_dnn' to site-package --- "
if [[ -f "${LOG_DIR}/dnn_venv_linking_project.log" ]]; then
    rm -f "${LOG_DIR}/dnn_venv_linking_project.log"
fi

cd "${PROJECT_ROOT}/packages/dnn"
${VENV_PYTHON_LOC} setup.py develop --no-deps >> "${LOG_DIR}/dnn_venv_linking_project.log" 2>&1
_SUCCESS=${?}
cd "${PROJECT_ROOT}"

if [[ ${_SUCCESS} == 0 ]]; then
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[31mFailed\e[0m"
    echo -en "\e[90m"; cat "${LOG_DIR}/dnn_venv_linking_project.log"; echo -e "\e[31mAborting the setup\e[0m"
    
    # deactivate venv
    deactivate

    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

# deactivate mnist-dnn-venv
deactivate
if [[ ${?} != 0 ]]; then
    echo -e "\e[33mSomething went wrong - deactivating 'mnist-dnn-venv' unsuccessful\e[0m"

    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

#########################################################################
# Initiate virtual environment for api package
echo -en "Creating 'dev/mnist-api-venv' --- "
if [[ -f "${LOG_DIR}/main_create_api_venv.log" ]]; then
    rm -f "${LOG_DIR}/main_create_api_venv.log"
fi
${PYTHON_LOC} -m venv dev/mnist-api-venv >> "${LOG_DIR}/main_create_api_venv.log" 2>&1
if [[ ${?} == 0 ]]; then
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[31mFailed\e[0m"
    echo -en "\e[90m"; cat "${LOG_DIR}/main_create_api_venv.log"; echo -e "\e[31mAborting the setup\e[0m"
    
    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

# Activate venv
echo -en "Activating 'dev/mnist-api-venv' --- "
if [[ -f "${LOG_DIR}/main_activate_api_venv.log" ]]; then
    rm -f "${LOG_DIR}/main_activate_api_venv.log"
fi
if [[ ${OS} == "Windows" ]]; then
    source dev/mnist-api-venv/Scripts/activate >> "${LOG_DIR}/main_activate_api_venv.log" 2>&1
else
    source dev/mnist-api-venv/bin/activate >> "${LOG_DIR}/main_activate_api_venv.log" 2>&1
fi

if [[ ${?} == 0 ]]; then
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[31mFailed\e[0m"
    echo -en "\e[90m"; cat "${LOG_DIR}/main_activate_api_venv.log"; echo -e "\e[31mAborting the setup\e[0m"
    
    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

# Parse python
if [[ ${OS} == "Windows" ]]; then
    VENV_PYTHON_LOC="${PROJECT_ROOT}/dev/mnist-api-venv/Scripts/python"
    VENV_PIP_LOC="${PROJECT_ROOT}/dev/mnist-api-venv/Scripts/pip"
else
    VENV_PYTHON_LOC="${PROJECT_ROOT}/dev/mnist-api-venv/bin/python"
    VENV_PIP_LOC="${PROJECT_ROOT}/dev/mnist-api-venv/bin/pip"
fi

# Do not upgrade venv pip to the newest version, it may cause critical bug.

# Install required packages for dnn
echo -en "Installing required packages [1/2] --- "
if [[ -f "${LOG_DIR}/api_venv_install_packages_dnn.log" ]]; then
    rm -f "${LOG_DIR}/api_venv_install_packages_dnn.log"
fi

_FAILED=False
if [[ ${OS} == "MacOS" ]]; then
    # zsh equivalent of readarray in bash
    dnn_venv_packages=("${(f)$(< "${PROJECT_ROOT}/packages/dnn/requirements.txt")}")
else
    readarray -t dnn_venv_packages < "${PROJECT_ROOT}/packages/dnn/requirements.txt"
fi

for _package in ${dnn_venv_packages[@]}; do
    ${VENV_PIP_LOC} install ${_package} >> "${LOG_DIR}/api_venv_install_packages_dnn.log" 2>&1
    if [[ ${?} != 0 ]]; then
        _FAILED=True
        break
    fi
done

if [[ ${_FAILED} == False ]]; then
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[31mFailed\e[0m"
    echo -en "\e[90m"; cat "${LOG_DIR}/api_venv_install_packages_dnn.log"; echo -e "\e[31mAborting the setup\e[0m"

    # deactivate venv
    deactivate

    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

# Install required packages for api
echo -en "Installing required packages [2/2] --- "
if [[ -f "${LOG_DIR}/api_venv_install_packages_api.log" ]]; then
    rm -f "${LOG_DIR}/api_venv_install_packages_api.log"
fi

_FAILED=False
if [[ ${OS} == "MacOS" ]]; then
    # zsh equivalent of readarray in bash
    api_venv_packages=("${(f)$(< "${PROJECT_ROOT}/packages/api/requirements.txt")}")
else
    readarray -t api_venv_packages < "${PROJECT_ROOT}/packages/api/requirements.txt"
fi

for _package in ${api_venv_packages[@]}; do
    ${VENV_PIP_LOC} install ${_package} >> "${LOG_DIR}/api_venv_install_packages_api.log" 2>&1
    if [[ ${?} != 0 ]]; then
        _FAILED=True
        break
    fi
done

if [[ ${_FAILED} == False ]]; then
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[31mFailed\e[0m"
    echo -en "\e[90m"; cat "${LOG_DIR}/api_venv_install_packages_api.log"; echo -e "\e[31mAborting the setup\e[0m"

    # deactivate venv
    deactivate

    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

# Add project to site-package
echo -en "Linking 'mnist_dnn' to site-package --- "

# Sleep for 10 second for previous setup.py to settle
# If error still occurs, re-try the script. (it might work after one failure)
sleep 10

if [[ -f "${LOG_DIR}/api_venv_linking_project_dnn.log" ]]; then
    rm -f "${LOG_DIR}/api_venv_linking_project_dnn.log"
fi

cd "${PROJECT_ROOT}/packages/dnn"
${VENV_PYTHON_LOC} setup.py develop --no-deps >> "${LOG_DIR}/api_venv_linking_project_dnn.log" 2>&1
_SUCCESS=${?}
cd "${PROJECT_ROOT}"

if [[ ${_SUCCESS} == 0 ]]; then
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[31mFailed\e[0m"
    echo -en "\e[90m"; cat "${LOG_DIR}/api_venv_linking_project_dnn.log"; echo -e "\e[31mAborting the setup\e[0m"
    
    # deactivate venv
    deactivate

    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

# Add project to site-package
echo -en "Linking 'mnist_dnn_api' to site-package --- "
if [[ -f "${LOG_DIR}/api_venv_linking_project.log" ]]; then
    rm -f "${LOG_DIR}/api_venv_linking_project.log"
fi

cd "${PROJECT_ROOT}/packages/api"
${VENV_PYTHON_LOC} setup.py develop --no-deps >> "${LOG_DIR}/api_venv_linking_project.log" 2>&1
_SUCCESS=${?}
cd "${PROJECT_ROOT}"

if [[ ${_SUCCESS} == 0 ]]; then
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[31mFailed\e[0m"
    echo -en "\e[90m"; cat "${LOG_DIR}/api_venv_linking_project.log"; echo -e "\e[31mAborting the setup\e[0m"
    
    # deactivate venv
    deactivate

    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

# deactivate mnist-api-venv
deactivate
if [[ ${?} != 0 ]]; then
    echo -e "\e[33mSomething went wrong - deactivating 'mnist-api-venv' unsuccessful\e[0m"

    # go back to initial directory
    cd ${INITIAL_DIR}
    
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

#########################################################################
# Configure the settings file
echo -e "version==${VERSION}" > "dev/.${SETTINGS_FILE}"

# Set useful alias
set_alias 1> /dev/null 2> /dev/null

# Print instruction
echo -e ""
instruction

# Go back to initial directory
cd ${INITIAL_DIR}
