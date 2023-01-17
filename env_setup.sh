#!/usr/bin/env bash
# @ VERSION   0.1.1
# @ AUTHOR    John Yoon
# @ LICENSE   MIT
#     
#   For initial setup, run "source env_setup.sh" (Mac/Linux only) to create virtual environment for MNIST_DNN Python
#   If there's any issues, please contact John Yoon <fedelejohn7008@gmail.com>

VERSION="0.1.1"
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

                echo -n "Creating publish environment..."

                # Initiate venv for publishing packages
                ${PYTHON_LOC} -m venv dev/publish-venv

                echo "Done"

                # Activate venv
                source dev/publish-venv/bin/activate

                VENV_PIP_LOC="$(which pip)"

                echo "Installing required packages..."
                echo "=========================================="
                # Install publish-purpose packages
                ${VENV_PIP_LOC} install setuptools==65.5.0
                ${VENV_PIP_LOC} install wheel==0.38.4
                ${VENV_PIP_LOC} install build==0.10.0
                ${VENV_PIP_LOC} install twine==4.0.2
                echo "=========================================="
                echo "Done"

                echo "Installed packages:"
                ${VENV_PIP_LOC} list

                # Deactivate out from venv
                deactivate

                echo -n "Creating MNIST_DNN environment"

                # Initiate venv for MNIST_DNN packages
                ${PYTHON_LOC} -m venv dev/mnist-dnn-venv

                echo "Done"

                # Activate venv
                source dev/mnist-dnn-venv/bin/activate

                VENV_PIP_LOC="$(which pip)"

                echo "Installing required packages..."
                echo "=========================================="
                # Install required files
                ${VENV_PIP_LOC} install -r packages/dnn/requirements.txt
                echo "=========================================="
                echo "Done"

                echo "Installed packages:"
                ${VENV_PIP_LOC} list

                # Deactivate out from venv
                deactivate

                echo -n "Creating MNIST_DNN_API environment"

                # Initiate venv for MNIST_DNN_API packages
                ${PYTHON_LOC} -m venv dev/mnist-dnn-api-venv

                echo "Done"

                # Activate venv
                source dev/mnist-dnn-api-venv/bin/activate

                VENV_PIP_LOC="$(which pip)"

                echo "Installing required packages..."
                echo "=========================================="
                # Install required files
                ${VENV_PIP_LOC} install -r packages/api/requirements.txt
                ${VENV_PIP_LOC} install mnist-dnn
                ${VENV_PIP_LOC} install -U mnist-dnn
                echo "=========================================="
                echo "Done"

                echo "Installed packages:"
                ${VENV_PIP_LOC} list

                # Deactivate venv
                deactivate

                echo "Setup complete."
                echo ""
                echo "To activate the virtual environment, run:"
                echo "  source dev/<option>/bin/activate"
                echo "To deactivate the virtual environment, run:"
                echo "  deactivate"
                echo ""
                echo "options:"
                echo "  * publish-venv (use for publishing a new update)"
                echo "  * mnist-dnn-venv (use for developing MNIST_DNN)"
                echo "  * mnist-dnn-api-venv (use for developing MNIST_DNN_API)"
                echo ""
                echo "NOTE: Python project should be run while virtual environment is activated."

                touch dev/.${VERSION}
            fi
        fi
    else 
        echo "Venv setup is already completed, to refresh setup, run \"source env_setup.sh -refresh\""
        echo ""
        echo "To activate the virtual environment, run:"
        echo "  source dev/<option>/bin/activate"
        echo "To deactivate the virtual environment, run:"
        echo "  deactivate"
        echo ""
        echo "options:"
        echo "  * publish-venv (use for publishing a new update)"
        echo "  * mnist-dnn-venv (use for developing MNIST_DNN)"
        echo "  * mnist-dnn-api-venv (use for developing MNIST_DNN_API)"
        echo ""
        echo "NOTE: Python project should be run while virtual environment is activated."
    fi
fi