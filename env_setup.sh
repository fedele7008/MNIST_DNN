#!/usr/bin/env bash
# @ VERSION   0.1.2
# @ AUTHOR    John Yoon
# @ LICENSE   MIT
#     
#   For initial setup, run "source env_setup.sh" (Mac/Linux only) to create virtual environment for MNIST_DNN Python
#   If there's any issues, please contact John Yoon <fedelejohn7008@gmail.com>
#
#   ** This setup will create "dev/" file, do not upload this to git **

VERSION="0.1.2"
CLEAR="False"
HELP="False"
REFRESH="False"
SETTINGS_FILE="settings.txt"
WINDOWS="False"

if [ ${#} -gt 0 ]; then
    if [ ${1} = "-windows" ] || [ ${1} = "--windows" ]; then
        shift 1
        WINDOWS="True"
    fi
fi

is_sourced() {
    if [ -n "$ZSH_VERSION" ]; then 
        case $ZSH_EVAL_CONTEXT in *:file:*) return 0;; esac
    else # Add additional POSIX-compatible shell names here, if needed.
        case ${0##*/} in dash|-dash|bash|-bash|ksh|-ksh|sh|-sh) return 0;; esac
    fi
    return 1  # NOT sourced.
}

(return 0 2>/dev/null) && sourced=1 || sourced=0
if [ ${sourced} -eq 0 ]; then
    echo -e "Script is not sourced, please run \"source env_setup.sh\" instead."
    echo -e "For more information, please check \"source env_setup.sh -help\" for usage."
    return 1 2> /dev/null; exit 1
fi

general_inst () {
    echo -e "To activate the virtual environment, run:"
    echo -e "  * source dev/publish-venv/bin/activate\t\t(use for publishing a new update)"
    echo -e "  * source dev/mnist-dnn-venv/bin/activate\t\t(use for developing MNIST_DNN)"
    echo -e "  * source dev/mnist-dnn-api-venv/bin/activate\t\t(use for developing MNIST_DNN_API)"
    echo -e "To deactivate the virtual environment, run:"
    echo -e "  * deactivate"
    echo -e ""
    echo -e "NOTE: Python project should be run while virtual environment is activated."
}

if [ ${#} -eq 1 ]; then
    if [ ${1} = "--clear" ] || [ ${1} = "-clear" ]; then
        CLEAR="True"
    elif [ ${1} = "--help" ] || [ ${1} = "-help" ]; then
        HELP="True"
    elif [ ${1} = "--refresh" ] || [ ${1} = "-refresh" ]; then
        CLEAR="True"
        REFRESH="True"
    else
        echo -e "Invalid option value, please check \"source env_setup.sh -help\" for usage."
        return 1 2> /dev/null; exit 1
    fi
elif [ ${#} -gt 1 ]; then
    echo -e "Invalid option value, please check \"source env_setup.sh -help\" for usage."
    return 1 2> /dev/null; exit 1
fi

if [ ${HELP} = "True" ]; then
    # print help
    echo -e "To setup virtual environment for MNIST_DNN project, goto project's directory and run \"source env_setup.sh\""
    echo -e "For any issues, please notify John Yoon <fedelejohn7008@gmail.com>."
    echo -e ""
    echo -e "Usage:"
    echo -e "  source env_setup.sh <option>"
    echo -e ""
    echo -e "Options:"
    echo -e "  -help, --help\t\t\tShow help."
    echo -e "  -clear, --clear\t\tRemove the initial setting."
    echo -e "  -refresh, --refresh\t\tReset the initial setting."

    # exit with code 0
    return 0 2> /dev/null; exit 0
fi

if [ ${CLEAR} = "True" ]; then
    if [ -d "dev" ]; then
        # remove 'dev/'
        echo -en "Removing the virtual environment..."
        rm -r dev/
        echo -e "Done"

        # exit when refresh flag is down
        if [ ${REFRESH} = "False" ]; then
            # exit with code 0
            return 0 2> /dev/null; exit 0
        fi
    fi
fi

# Create dev local directory for the virtual environment (this is not commited to git)
if [ ! -d "dev" ]; then
    echo -en "Creating 'dev/'..."
    mkdir "dev"
    echo -e "Done"
fi

# If setting file already exists
if [ -f dev/.${SETTINGS_FILE} ]; then
    # Check the verison
    cat "dev/.${SETTINGS_FILE}" | egrep "version==${VERSION}" 1> /dev/null 2> /dev/null
    if [ ${?} -eq 0 ]; then
        # current version is already installed, show instruction and exit
        echo -e "Venv setup is already completed, to refresh setup, run \"source env_setup.sh -refresh\""
        echo -e ""
        general_inst

        # exit with code 0
        return 0 2> /dev/null; exit 0
    else
        # new version is available clear the dev/
        echo -e "new update is found, proceeding upgrade"
        rm -r dev/
        mkdir "dev"
    fi
fi

# Check if pip & python is installed
echo -en "Locating Python/PIP..."
which python3 1> /dev/null 2> /dev/null
PYTHON3_INSTALLED=${?}
which python 1> /dev/null 2> /dev/null
PYTHON_INSTALLED=${?}
which pip3 1> /dev/null 2> /dev/null
PIP3_INSTALLED=${?}
which pip 1> /dev/null 2> /dev/null
PIP_INSTALLED=${?}

if [ ${PYTHON3_INSTALLED} -eq 1 ] && [ ${PYTHON_INSTALLED} -eq 1 ]; then
    echo -e "Failed"
    echo -e "Python is not found."
    # exit with code 1
    return 1 2> /dev/null; exit 1
elif [ ${PIP3_INSTALLED} -eq 1 ] && [ ${PIP_INSTALLED} -eq 1 ]; then
    echo -e "Failed"
    echo -e "PIP is not found."
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi
echo -e "Done"

# Check if pip is valid
echo -en "Validating PIP..."
PIP_FOUND="False"

if [ ${PIP_FOUND} = "False" ] && [ ${PIP3_INSTALLED} -eq 0 ] && [ ${PYTHON3_INSTALLED} -eq 0 ]; then
    PIP_LOC="$(which pip3)"
    ${PIP_LOC} --version 1> /dev/null 2> /dev/null
    
    if [ ${?} -eq 0 ]; then
        PYTHON_LOC="$(which python3)"
        PIP_FOUND="True"
    fi
fi

if [ ${PIP_FOUND} = "False" ] && [ ${PIP_INSTALLED} -eq 0 ] && [ ${PYTHON_INSTALLED} -eq 0 ]; then
    PIP_LOC="$(which pip)"
    ${PIP_LOC} --version 1> /dev/null 2> /dev/null

    if [ ${?} -eq 0 ]; then
        PYTHON_LOC="$(which python)"
        PIP_FOUND="True"
    fi
fi

if [ ${PIP_FOUND} = "False" ]; then
    echo -e "Failed"
    echo -e "No valid PIP is found."
    # exit with code 1
    return 1 2> /dev/null; exit 1
fi

echo -e "Done"

# Install virtualenv
${PIP_LOC} list | egrep "virtualenv" 1> /dev/null 2> /dev/null
if [ ${?} -eq 1 ]; then
    echo -e "Start installing 'virtualenv'..."
    ${PIP_LOC} install virtualenv
fi

echo -en "Creating publish environment..."

# Initiate venv for publishing packages
${PYTHON_LOC} -m venv dev/publish-venv

echo -e "Done"

# Activate venv

if [ ${WINDOWS} = "True" ]; then
    source dev/publish-venv/Scripts/activate
    VENV_PIP_LOC="./dev/publish-venv/Scripts/pip"
else
    source dev/publish-venv/bin/activate
    VENV_PIP_LOC="./dev/publish-venv/bin/pip"
fi

echo -e "Installing required packages..."
echo -e "=========================================="
# Install publish-purpose packages
${VENV_PIP_LOC} install setuptools==65.5.0
${VENV_PIP_LOC} install wheel==0.38.4
${VENV_PIP_LOC} install build==0.10.0
${VENV_PIP_LOC} install twine==4.0.2
echo -e "=========================================="
echo -e "Done"

echo -e "Installed packages:"
${VENV_PIP_LOC} list
echo -e "=========================================="

# Deactivate out from venv
deactivate

echo -en "Creating MNIST_DNN environment..."

# Initiate venv for MNIST_DNN packages
${PYTHON_LOC} -m venv dev/mnist-dnn-venv

echo -e "Done"

# Activate venv
if [ ${WINDOWS} = "True" ]; then
    source dev/mnist-dnn-venv/Scripts/activate
    VENV_PIP_LOC="./dev/mnist-dnn-venv/Scripts/pip"
    VENV_PYTHON_LOC="../../dev/mnist-dnn-venv/Scripts/python"
else
    source dev/mnist-dnn-venv/bin/activate
    VENV_PIP_LOC="./dev/mnist-dnn-venv/bin/pip"
    VENV_PYTHON_LOC="../../dev/mnist-dnn-venv/bin/python"
fi

echo -e "Installing required packages..."
echo -e "=========================================="
# Install required files
${VENV_PIP_LOC} install -r packages/dnn/requirements.txt
echo -e "=========================================="
echo -e "Done"

echo -e "Linking project to site-package..."
echo -e "=========================================="
cd packages/dnn
${VENV_PYTHON_LOC} setup.py develop
cd ../../
echo -e "=========================================="
echo -e "Done"

echo -e "Installed packages:"
${VENV_PIP_LOC} list
echo -e "=========================================="

# Deactivate out from venv
deactivate

echo -en "Creating MNIST_DNN_API environment..."

# Initiate venv for MNIST_DNN_API packages
${PYTHON_LOC} -m venv dev/mnist-dnn-api-venv

echo -e "Done"

# Activate venv
if [ ${WINDOWS} = "True" ]; then
    source dev/mnist-dnn-api-venv/Scripts/activate
    VENV_PIP_LOC="./dev/mnist-dnn-api-venv/Scripts/pip"
    VENV_PYTHON_LOC="../../dev/mnist-dnn-api-venv/Scripts/python"
else
    source dev/mnist-dnn-api-venv/bin/activate
    VENV_PIP_LOC="./dev/mnist-dnn-api-venv/bin/pip"
    VENV_PYTHON_LOC="../../dev/mnist-dnn-api-venv/bin/python"
fi

echo -e "Installing required packages..."
echo -e "=========================================="
# Install required files
${VENV_PIP_LOC} install -r packages/api/requirements.txt
${VENV_PIP_LOC} install mnist-dnn
${VENV_PIP_LOC} install -U mnist-dnn
echo -e "=========================================="
echo -e "Done"

echo -e "Linking project to site-package..."
echo -e "=========================================="
cd packages/api
${VENV_PYTHON_LOC} setup.py develop
cd ../../
echo -e "=========================================="
echo -e "Done"

echo -e "Installed packages:"
${VENV_PIP_LOC} list
echo -e "=========================================="

# Deactivate venv
deactivate

echo -e ""
echo -e "Setup complete."
echo -e ""
general_inst

echo -e "version==${VERSION}" > "dev/.${SETTINGS_FILE}"
