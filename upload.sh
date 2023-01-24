#!/usr/bin/env bash
# @ VERSION   0.1.0
# @ AUTHOR    John Yoon
# @ LICENSE   MIT
#
#   Use this to aid package upload process (Mac/Linux only).
#   To see details about usage, run "source upload.sh -help"
#   If there's any issues, please contact John Yoon <fedelejohn7008@gmail.com>
#
#   ** Request PyPI and test-PyPI access token to John Yoon before setting up **

VERSION="0.1.0"
WINDOWS="False"

if [ ${#} -gt 0 ]; then
    if [ ${1} = "-windows" ] || [ ${1} = "--windows" ]; then
        shift 1
        WINDOWS="True"
    fi
fi

# Check if command is sourced. If not, abort.
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
    echo -e "Script is not sourced, please run \"source upload.sh <action>\" instead."
    echo -e "For more information, please check \"source upload.sh -help\" for usage."
    return 1 2> /dev/null; exit 1
fi

# Check if they ran env_setup.sh beforehand
if [ ! -f "dev/.settings.txt" ]; then
    echo -e "you should run \"source env_setup.sh\" first"
    return 1 2> /dev/null; exit 1
fi

# Helper functions

print_help () {
    echo -e "To upload packages to PyPI, goto project's root directory and run \"source upload.sh <action>\"."
    echo -e "For any issues, please notify John Yoon <fedelejohn7008@gmail.com>."
    echo -e ""
    echo -e "Usage:"
    echo -e "  source upload.sh <action> <optional-arg>"
    echo -e ""
    echo -e "Actions:"
    echo -e "  -h, --help \t\t\t\t\tShow help"
    echo -e ""
    echo -e "  -s, --setup \t\t\t\t\tSetup uploading tokens"
    echo -e "   <optional-arg>: -c, --clear \t\t\tReset the toekn setting"
    echo -e ""
    echo -e "  -a, --api \t\t\t\t\tupload MNIST_DNN_API"
    echo -e "   <optional-arg>: -t, --test \t\t\tUpload it on the test server [default]"
    echo -e "                   -r, --release \t\tUpload it on the release server"
    echo -e "                   -b, --build \t\t\tBuild build/ and dist/"
    echo -e "                   -c, --clear \t\t\tRemove build/ and dist/"
    echo -e ""
    echo -e "  -d, --dnn \t\t\t\t\tupload MNIST_DNN"
    echo -e "   <optional-arg>: -t, --test \t\t\tUpload it on the test server [default]"
    echo -e "                   -r, --release \t\tUpload it on the release server"
    echo -e "                   -b, --build \t\t\tBuild build/ and dist/"
    echo -e "                   -c, --clear \t\t\tRemove build/ and dist/"
}

invalid_args () {
    echo -e "Invalid argument, please check \"source upload.sh -help\" for usages."
}

MODE=None
OPTION=None

# Detect args
if [ ${#} -eq 0 ]; then
    echo -e "No argument detected, please check \"source upload.sh -help\" for usages."
    return 1 2> /dev/null; exit 1
fi

if [ ${#} -eq 1 ]; then
    if [ ${1} = "-h" ] || [ ${1} = "--help" ] || [ ${1} = "-help" ]; then
        print_help
        return 0 2> /dev/null; exit 0
    elif [ ${1} = "-s" ] || [ ${1} = "--setup" ] || [ ${1} = "-setup" ]; then
        MODE="setup"
    elif [ ${1} = "-a" ] || [ ${1} = "--api" ] || [ ${1} = "-api" ]; then
        MODE="api"
        OPTION="test"
    elif [ ${1} = "-d" ] || [ ${1} = "--dnn" ] || [ ${1} = "-dnn" ]; then
        MODE="dnn"
        OPTION="test"
    else
        invalid_args
        return 1 2> /dev/null; exit 1
    fi
fi

if [ ${#} -eq 2 ]; then
    if [ ${1} = "-s" ] || [ ${1} = "--setup" ] || [ ${1} = "-setup" ]; then
        if [ ${2} = "-c" ] || [ ${2} = "--clear" ] || [ ${2} = "-clear" ]; then
            MODE="reset"
        else
            invalid_args
            return 1 2> /dev/null; exit 1
        fi
    elif [ ${1} = "-a" ] || [ ${1} = "--api" ] || [ ${1} = "-api" ]; then
        MODE="api"
        if [ ${2} = "-t" ] || [ ${2} = "--test" ] || [ ${2} = "-test" ]; then
            OPTION="test"
        elif [ ${2} = "-r" ] || [ ${2} = "--release" ] || [ ${2} = "-release" ]; then
            OPTION="release"
        elif [ ${2} = "-b" ] || [ ${2} = "--build" ] || [ ${2} = "-build" ]; then
            OPTION="build"
        elif [ ${2} = "-c" ] || [ ${2} = "--clear" ] || [ ${2} = "-clear" ]; then
            OPTION="clear"
        else
            invalid_args
            return 1 2> /dev/null; exit 1
        fi
    elif [ ${1} = "-d" ] || [ ${1} = "--dnn" ] || [ ${1} = "-dnn" ]; then
        MODE="dnn"
        if [ ${2} = "-t" ] || [ ${2} = "--test" ] || [ ${2} = "-test" ]; then
            OPTION="test"
        elif [ ${2} = "-r" ] || [ ${2} = "--release" ] || [ ${2} = "-release" ]; then
            OPTION="release"
        elif [ ${2} = "-b" ] || [ ${2} = "--build" ] || [ ${2} = "-build" ]; then
            OPTION="build"
        elif [ ${2} = "-c" ] || [ ${2} = "--clear" ] || [ ${2} = "-clear" ]; then
            OPTION="clear"
        else
            invalid_args
            return 1 2> /dev/null; exit 1
        fi
    else
        invalid_args
        return 1 2> /dev/null; exit 1
    fi
fi

if [ ${#} -gt 2 ]; then
    invalid_args
    return 1 2> /dev/null; exit 1
fi

# Actions
if [ ${MODE} = "setup" ]; then

    # Check if ~/.pypirc already exists
    if [ -f "${HOME}/.pypirc" ]; then
        echo -e "You already have a settings file, would you like to proceed anyway?"
        echo -e "Warning: It will overwrite the previous settings."
        echo -en "(y/n): "
        read USER_ANSWER
        if [ ${USER_ANSWER} = "y" ] || [ ${USER_ANSWER} = "Y" ]; then
            rm -f "${HOME}/.pypirc"
        else
            echo -e "Canceling setup...Done"
            return 1 2> /dev/null; exit 1
        fi
    fi

    echo -e "** If you skip registering token, you will be required to enter credentials to PyPI when uploading **"
    echo -en "Please enter PyPI Token (If you want to skip this token enter 'n'): "
    read PyPI_TOKEN
    echo -en "Please enter Test PyPI Token (If you want to skip this token enter 'n'): "
    read Test_PyPI_TOKEN

    if [ ${PyPI_TOKEN} = "n" -o ${PyPI_TOKEN} = "N" ] && [ ${Test_PyPI_TOKEN} = "n" -o ${Test_PyPI_TOKEN} = "N" ]; then
        echo -e "You should enter either one of token."
        return 1 2> /dev/null; exit 1
    fi

    # Create ~/.pypirc file in home directory
    touch "${HOME}/.pypirc"

    echo -e "[distutils]" >> "${HOME}/.pypirc"
    echo -e "index-servers =" >> "${HOME}/.pypirc"
    if [ ! ${PyPI_TOKEN} = "n" ] && [ ! ${PyPI_TOKEN} = "N" ]; then
        echo -e "    pypi" >> "${HOME}/.pypirc"
    fi
    
    if [ ! ${Test_PyPI_TOKEN} = "n" ] && [ ! ${Test_PyPI_TOKEN} = "N" ]; then
        echo -e "    testpypi" >> "${HOME}/.pypirc"
    fi

    if [ ! ${PyPI_TOKEN} = "n" ] && [ ! ${PyPI_TOKEN} = "N" ]; then
        echo -e "" >> "${HOME}/.pypirc"
        echo -e "[pypi]" >> "${HOME}/.pypirc"
        echo -e "username = __token__" >> "${HOME}/.pypirc"
        echo -e "password = ${PyPI_TOKEN}" >> "${HOME}/.pypirc"
    fi

    if [ ! ${Test_PyPI_TOKEN} = "n" ] && [ ! ${Test_PyPI_TOKEN} = "N" ]; then
        echo -e "" >> "${HOME}/.pypirc"
        echo -e "[testpypi]" >> "${HOME}/.pypirc"
        echo -e "username = __token__" >> "${HOME}/.pypirc"
        echo -e "password = ${Test_PyPI_TOKEN}" >> "${HOME}/.pypirc"
    fi

    chmod 600 "${HOME}/.pypirc"
    echo -e "Setup complete!"
elif [ ${MODE} = "reset" ]; then
    # Check if ~/.pypirc already exists
    if [ -f "${HOME}/.pypirc" ]; then
        echo -e "Warning: You will lose the previous settings."
        echo -en "(y/n): "
        read USER_ANSWER
        if [ ${USER_ANSWER} = "y" ] || [ ${USER_ANSWER} = "Y" ]; then
            echo -en "Reseting..."
            rm -f "${HOME}/.pypirc"
            echo -e "Done"
        else
            echo -e "Canceling setup...Done"
            return 1 2> /dev/null; exit 1
        fi
    else 
        echo -e "You do not have setting file."
        return 0 2> /dev/null; exit 0
    fi
elif [ ${MODE} = "api" ]; then
    # Move to api package directory
    cd packages/api
elif [ ${MODE} = "dnn" ]; then
    # Move to dnn package directory
    cd packages/dnn
fi

if [ ${OPTION} = "test" ] || [ ${OPTION} = "release" ]; then
    # Check if setup is already complete
    if [ ! -f "${HOME}/.pypirc" ]; then
        echo -e "Warning: You have not setup the upload tokens."
        echo -e "         You will be required to provide credentials to PyPI."
        echo -en "         Are you sure you want to proceed? (y/n): "
        read USER_ANSWER
        if [ ! ${USER_ANSWER} = "y" ] && [ ! ${USER_ANSWER} = "Y" ]; then
            cd ../../
            echo -e "Canceling the upload...Done"
            return 1 2> /dev/null; exit 1
        fi
    fi

    # Parse the current version
    CURRENT_VERSION=$(cat "setup.py" | egrep -o "'[0-9]+\.[0-9]+\.[0-9]+([a-z]+[0-9]*)?'" | egrep -o "[0-9]+\.[0-9]+\.[0-9]+([a-z]+[0-9]*)?")

    if [ ! ${?} -eq 0 ]; then
        echo -e "[ERROR] Current package version is not detected."
        cd ../../
        return 1 2> /dev/null; exit 1
    fi

    echo -e "Current version detected: ${CURRENT_VERSION}"
    echo -e "Please enter the new deploy version."
    echo -e "Rule: <major>.<minor>.<patch>                         release versioning style"
    echo -e "Rule: <major>.<minor>.<patch><state><change>          development versioning style"
    echo -e ""
    echo -e "      numbering:"
    echo -e "        * <major> : INT (REQUIRED): change when major change occur (e.g. reconstructing the whole model)"
    echo -e "        * <minor> : INT (REQUIRED): change when minor change occur (e.g. adding/deleting/changing features)"
    echo -e "        * <patch> : INT (REQUIRED): change when small change occur (e.g. bug fix, commenting, code styling)"
    echo -e "        * <state> : STR (OPTIONAL): 'a' - means 'alpha' version"
    echo -e "                                    'b' - means 'beta' version"
    echo -e "        * <change>: INT (OPTIONAL): optional number to indicate the change from previous version"
    echo -e ""
    echo -e "      ** VERSION MUST INCREASE ONLY (NOT ASSERTED HERE - IT WILL CAUSE ERROR WHEN UPLOADING) **"
    echo -en "Enter the new version (To keep the current version, enter 'n'): "
    read USER_INPUT

    if [ ! ${USER_INPUT} = "n" ] && [ ! ${USER_INPUT} = "N" ]; then
        echo -e "${USER_INPUT}" | egrep -o "^[0-9]+\.[0-9]+\.[0-9]+([a-z]+[0-9]*)?$" 1> /dev/null 2> /dev/null

        if [ ! ${?} -eq 0 ]; then
            echo -e "Please follow the versioning rule."
            echo -e "Aborting"
            cd ../../
            return 1 2> /dev/null; exit 1
        fi

        echo -e "Confirm the new version"
        echo -e "  (OLD): ${CURRENT_VERSION}"
        echo -e "  (NEW): ${USER_INPUT}"
        echo -en "Do you confirm the change? (y/n): "
        read AGREEMENT

        if [ ${AGREEMENT} = 'y' ] || [ ${AGREEMENT} = 'Y' ]; then
            echo -en "Updating..."
            if [ ${WINDOWS} = "False" ]; then
                sed -i "" "s/version='.*'/version='${USER_INPUT}'/g" "setup.py"
            else
                sed -i "s/version='.*'/version='${USER_INPUT}'/g" "setup.py"
            fi
            echo -e "Done"
        else
            echo -e "Canceling the change...Done"
            cd ../../
            return 1 2> /dev/null; exit 1
        fi 
    fi

    # Remove build/ and dist/ if they exist
    if [ -d "build/" ]; then
        rm -rf "build/"
    fi

    if [ -d "dist/" ]; then
        rm -rf "dist/"
    fi

    if [ ${WINDOWS} = "True" ]; then
        # Activate publish purpose venv
        source ../../dev/publish-venv/Scripts/activate

        # Locate python
        VENV_PYTHON_LOC="../../dev/publish-venv/Scripts/python"
    else
        # Activate publish purpose venv
        source ../../dev/publish-venv/bin/activate

        # Locate python
        VENV_PYTHON_LOC=$(which python)
    fi

    # Create binary distribution using wheel
    echo -e "Building binary distribution..."
    echo -e "=========================================="
    ${VENV_PYTHON_LOC} setup.py sdist bdist_wheel
    echo -e "=========================================="
    echo -e "Done"

    # Publish distribution
    echo -e "Uploading distribution..."
    echo -e "=========================================="
    if [ ${OPTION} = "test" ]; then
        ${VENV_PYTHON_LOC} -m twine upload --repository testpypi dist/*
        UPLOADED=${?}
    elif [ ${OPTION} = "release" ]; then
        ${VENV_PYTHON_LOC} -m twine upload --repository pypi dist/*
        UPLOADED=${?}
    fi
    echo -e "=========================================="
    echo -e "Done"

    deactivate
    cd ../../
    if [ ${UPLOADED} -eq 0 ]; then
        echo -e "Uploading completed successfully."
        return 0 2> /dev/null; exit 0
    else
        echo -e "Uploading completed failed."
        return 1 2> /dev/null; exit 1
    fi
elif [ ${OPTION} = "build" ]; then
    # Remove build/ and dist/ if they exist
    if [ -d "build/" ]; then
        rm -rf "build/"
    fi

    if [ -d "dist/" ]; then
        rm -rf "dist/"
    fi

    if [ ${WINDOWS} = "True" ]; then
        # Activate publish purpose venv
        source ../../dev/publish-venv/Scripts/activate

        # Locate python
        VENV_PYTHON_LOC="../../dev/publish-venv/Scripts/python"
    else
        # Activate publish purpose venv
        source ../../dev/publish-venv/bin/activate

        # Locate python
        VENV_PYTHON_LOC=$(which python)
    fi

    # Create binary distribution using wheel
    echo -e "Building binary distribution..."
    echo -e "=========================================="
    ${VENV_PYTHON_LOC} setup.py sdist bdist_wheel
    echo -e "=========================================="
    echo -e "Done"

    # Deactivate
    deactivate

    # Go back to root
    cd ../../
elif [ ${OPTION} = "clear" ]; then
    echo -en "Clearing build/ and dist/..."

    # Remove build/ and dist/ if they exist
    if [ -d "build/" ]; then
        rm -rf "build/"
    fi

    if [ -d "dist/" ]; then
        rm -rf "dist/"
    fi

    echo -e "Done."

    # Go back to root
    cd ../../
fi

