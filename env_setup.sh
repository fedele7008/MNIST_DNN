#!/usr/bin/env bash
# @ VERSION   0.1.0
# @ AUTHOR    John Yoon
# @ LICENSE   MIT
#     
#   For initial setup, run "source env_setup.sh" (Mac/Linux only) to create virtual environment for MNIST_DNN Python
#   If there's any issues, please contact John Yoon <fedelejohn7008@gmail.com>

VERSION="0.1.0"
CLEAR="False"
HELP="False"
EXIT="False"
REFRESH="False"

for arg in "${@}"; do
    if [ ${arg} = "--clear" ] || [ ${arg} = "-clear" ]; then
        CLEAR="True"
    elif [ ${arg} = "--help" ] || [ ${arg} = "-help" ]; then
        HELP="True"
    elif [ ${arg} = "--refresh" ] || [ ${arg} = "-refresh" ]; then
        REFRESH="True"
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
    echo "  -refresh, --refresh\t\tReset the initial setting."
else
    # If refresh flag in up, remove existing venv first
    if [ ${REFRESH} = "True" ]; then
        rm -r dev/
    fi

    # Create dev local directory for the virtual environment (this is not commited to git)
    if [ ! -d "dev" ]; then
        echo -n "Creating 'dev/'..."
        mkdir "dev"
        echo "Done"
    fi

    if [ ! -f dev/.${VERSION} ]; then
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
                echo "No valid PIP is found."
                EXIT="True"
            fi

            if [ ${EXIT} = "False" ]; then
                echo "Done"

                # Install virtualenv
                ${PIP_LOC} list | egrep "virtualenv" 1> /dev/null 2> /dev/null
                if [ ${?} -eq 1 ]; then
                    echo "Start installing 'virtualenv'..."
                    ${PIP_LOC} install virtualenv
                fi

                # Initiate venv
                ${PYTHON_LOC} -m venv dev/mnist-dnn-venv

                # Activate venv
                source dev/mnist-dnn-venv/bin/activate

                VENV_PIP_LOC="$(which pip)"

                echo "Installing required packages..."
                echo "=========================================="
                # Install required files
                ${VENV_PIP_LOC} install -r service/requirements.txt
                echo "=========================================="
                echo "Done"

                echo "Setup complete."
                echo ""
                echo "Installed packages:"
                ${VENV_PIP_LOC} list

                echo ""
                echo "To activate the virtual environment, run:"
                echo "  source dev/mnist-dnn-venv/bin/activate"
                echo "To deactivate the virtual environment, run:"
                echo "  deactivate"
                echo ""
                echo "NOTE: Python project should be run while virtual environment is activated."

                # Deactivate venv
                deactivate

                touch dev/.${VERSION}
            fi
        fi
    else 
        echo "Venv setup is already completed, to refresh setup, run \"source env_setup.sh -refresh\""
        echo ""
        echo "Installed packages:"
        source dev/mnist-dnn-venv/bin/activate
        VENV_PIP_LOC="$(which pip)"
        ${VENV_PIP_LOC} list
        echo ""
        echo "To activate the virtual environment, run:"
        echo "  source dev/mnist-dnn-venv/bin/activate"
        echo "To deactivate the virtual environment, run:"
        echo "  deactivate"
        echo ""
        echo "NOTE: Python project should be run while virtual environment is activated."
        deactivate
    fi
fi