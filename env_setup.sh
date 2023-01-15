#!/usr/bin/env bash

CLEAR="False"
HELP="False"
EXIT="False"

for arg in "${@}"; do
    if [ ${arg} = "--clear" ] || [ ${arg} = "-clear" ]; then
        CLEAR="True"
    elif [ ${arg} = "--help" ] || [ ${arg} = "-help" ]; then
        HELP="True"
    fi
done

if [ ${CLEAR} = "True" ]; then
    if [ -d "dev" ]; then
        echo -n "Removing the virtual environment..."
        rm -r dev/
        echo "Done"
    fi
elif [ ${HELP} = "True" ]; then
    echo "To setup virtual environment for MNIST_DNN project, goto project's directory and run \"source env_setup.sh\""
    echo "For any issues, please notify John Yoon <fedelejohn7008@gmail.com>."
    echo ""
    echo "Usage:"
    echo "  source env_setup.sh <option>"
    echo ""
    echo "Options:"
    echo "  -help, --help\t\t\tShow help."
    echo "  -clear, --clear\t\tRemove the initial setting."
else
    # Create dev local directory for the virtual environment (this is not commited to git)
    if [ ! -d "dev" ]; then
        echo -n "Creating 'dev/'..."
        mkdir "dev"
        echo "Done"
    fi

    # Check if pip & python is installed
    echo -n "Locating Python/PIP..."
    which python3 1> /dev/null 2> /dev/null
    PYTHON3_INSTALLED=${?}
    which python 1> /dev/null 2> /dev/null
    PYTHON_INSTALLED=${?}
    which pip3 1> /dev/null 2> /dev/null
    PIP3_INSTALLED=${?}
    which pip 1> /dev/null 2> /dev/null
    PIP_INSTALLED=${?}

    if [ ${PYTHON3_INSTALLED} -eq 1 ] && [ ${PYTHON_INSTALLED} -eq 1 ]; then
        echo "Python is not found."
        EXIT="True"
    elif [ ${PIP3_INSTALLED} -eq 1 ] && [ ${PIP_INSTALLED} -eq 1 ]; then
        echo "PIP is not found."
        EXIT="True"
    fi

    if [ ${EXIT} = "False" ]; then
        echo "Done"

        # Check if pip is valid
        echo -n "Validating PIP..."
        PIP_FOUND="False"

        if [ ${PIP_FOUND} = "False" ] && [ ${PIP3_INSTALLED} -eq 0 ] && [ ${PYTHON3_INSTALLED} -eq 0 ]; then
            PIP_LOCK="$(which pip3)"
            ${PIP_LOCK} --version 1> /dev/null 2> /dev/null
            
            if [ ${?} -eq 0 ]; then
                PYTHON_LOCK="$(which python3)"
                PIP_FOUND="True"
            fi
        fi

        if [ ${PIP_FOUND} = "False" ] && [ ${PIP_INSTALLED} -eq 0 ] && [ ${PYTHON_INSTALLED} -eq 0 ]; then
            PIP_LOCK="$(which pip)"
            ${PIP_LOCK} --version 1> /dev/null 2> /dev/null

            if [ ${?} -eq 0 ]; then
                PYTHON_LOCK="$(which python)"
                PIP_FOUND="True"
            fi
        fi

        if [ ${PIP_FOUND} = "False" ]; then
            echo "No valid PIP is found."
            EXIT="True"
        fi

        if [ ${EXIT} = "False" ]; then
            echo "Done"

            # Install virtualenv
            ${PIP_LOCK} list | egrep "virtualenv" 1> /dev/null 2> /dev/null
            if [ ${?} -eq 1 ]; then
                echo "Start installing 'virtualenv'..."
                ${PIP_LOCK} install virtualenv
            fi

            # Initiate venv
            ${PYTHON_LOCK} -m venv dev/mnist-dnn-venv

            # Activate venv
            source dev/mnist-dnn-venv/bin/activate

            VENV_PIP_LOCK="$(which pip)"

            echo -n "Installing required libraries..."
            # Install required files
            ${VENV_PIP_LOCK} install -r service/requirements.txt
            echo "Done"

            # Deactivate venv
            deactivate
        fi
    fi
fi