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
    echo "Script is not sourced, please run \"source upload.sh <action>\" instead."
    echo "For more information, please check \"source upload.sh -help\" for usage."
    return 1 2> /dev/null; exit 1
fi

# Check if they ran env_setup.sh beforehand
if [ ! -f "dev/.settings.txt" ]; then
    echo "you should run \"source env_setup.sh\" first"
    return 1 2> /dev/null; exit 1
fi

# Helper functions

print_help () {
    echo "To upload packages to PyPI, goto project's root directory and run \"source upload.sh <action>\"."
    echo "For any issues, please notify John Yoon <fedelejohn7008@gmail.com>."
    echo ""
    echo "Usage:"
    echo "  source upload.sh <action> <optional-arg>"
    echo ""
    echo "Actions:"
    echo "  -h, --help \t\t\t\t\tShow help"
    echo ""
    echo "  -s, --setup \t\t\t\t\tSetup uploading tokens"
    echo "   <optional-arg>: -c, --clear \t\t\tReset the toekn setting"
    echo ""
    echo "  -a, --api \t\t\t\t\tupload MNIST_DNN_API"
    echo "   <optional-arg>: -t, --test \t\t\tUpload it on the test server [default]"
    echo "                   -r, --release \t\tUpload it on the release server"
    echo "                   -b, --build \t\t\tBuild build/ and dist/"
    echo "                   -c, --clear \t\t\tRemove build/ and dist/"
    echo ""
    echo "  -d, --dnn \t\t\t\t\tupload MNIST_DNN"
    echo "   <optional-arg>: -t, --test \t\t\tUpload it on the test server [default]"
    echo "                   -r, --release \t\tUpload it on the release server"
    echo "                   -b, --build \t\t\tBuild build/ and dist/"
    echo "                   -c, --clear \t\t\tRemove build/ and dist/"
}

invalid_args () {
    echo "Invalid argument, please check \"source upload.sh -help\" for usages."
}

MODE=None
OPTION=None

# Detect args
if [ ${#} -eq 0 ]; then
    echo "No argument detected, please check \"source upload.sh -help\" for usages."
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
        echo "You already have a settings file, would you like to proceed anyway?"
        echo "Warning: It will overwrite the previous settings."
        echo -n "(y/n): "
        read USER_ANSWER
        if [ ${USER_ANSWER} = "y" ] || [ ${USER_ANSWER} = "Y" ]; then
            rm -f "${HOME}/.pypirc"
        else
            echo "Canceling setup...Done"
            return 1 2> /dev/null; exit 1
        fi
    fi

    echo "** If you skip registering token, you will be required to enter credentials to PyPI when uploading **"
    echo -n "Please enter PyPI Token (If you want to skip this token enter 'n'): "
    read PyPI_TOKEN
    echo -n "Please enter Test PyPI Token (If you want to skip this token enter 'n'): "
    read Test_PyPI_TOKEN

    if [ ${PyPI_TOKEN} = "n" -o ${PyPI_TOKEN} = "N" ] && [ ${Test_PyPI_TOKEN} = "n" -o ${Test_PyPI_TOKEN} = "N" ]; then
        echo "You should enter either one of token."
        return 1 2> /dev/null; exit 1
    fi

    # Create ~/.pypirc file in home directory
    touch "${HOME}/.pypirc"

    echo "[distutils]" >> "${HOME}/.pypirc"
    echo "index-servers =" >> "${HOME}/.pypirc"
    if [ ! ${PyPI_TOKEN} = "n" ] && [ ! ${PyPI_TOKEN} = "N" ]; then
        echo "    pypi" >> "${HOME}/.pypirc"
    fi
    
    if [ ! ${Test_PyPI_TOKEN} = "n" ] && [ ! ${Test_PyPI_TOKEN} = "N" ]; then
        echo "    testpypi" >> "${HOME}/.pypirc"
    fi

    if [ ! ${PyPI_TOKEN} = "n" ] && [ ! ${PyPI_TOKEN} = "N" ]; then
        echo "" >> "${HOME}/.pypirc"
        echo "[pypi]" >> "${HOME}/.pypirc"
        echo "username = __token__" >> "${HOME}/.pypirc"
        echo "password = ${PyPI_TOKEN}" >> "${HOME}/.pypirc"
    fi

    if [ ! ${Test_PyPI_TOKEN} = "n" ] && [ ! ${Test_PyPI_TOKEN} = "N" ]; then
        echo "" >> "${HOME}/.pypirc"
        echo "[testpypi]" >> "${HOME}/.pypirc"
        echo "username = __token__" >> "${HOME}/.pypirc"
        echo "password = ${Test_PyPI_TOKEN}" >> "${HOME}/.pypirc"
    fi

    chmod 600 "${HOME}/.pypirc"
    echo "Setup complete!"
elif [ ${MODE} = "reset" ]; then
    # Check if ~/.pypirc already exists
    if [ -f "${HOME}/.pypirc" ]; then
        echo "Warning: You will lose the previous settings."
        echo -n "(y/n): "
        read USER_ANSWER
        if [ ${USER_ANSWER} = "y" ] || [ ${USER_ANSWER} = "Y" ]; then
            echo -n "Reseting..."
            rm -f "${HOME}/.pypirc"
            echo "Done"
        else
            echo "Canceling setup...Done"
            return 1 2> /dev/null; exit 1
        fi
    else 
        echo "You do not have setting file."
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
        echo "Warning: You have not setup the upload tokens."
        echo "         You will be required to provide credentials to PyPI."
        echo -n "         Are you sure you want to proceed? (y/n): "
        read USER_ANSWER
        if [ ! ${USER_ANSWER} = "y" ] && [ ! ${USER_ANSWER} = "Y" ]; then
            cd ../../
            echo "Canceling the upload...Done"
            return 1 2> /dev/null; exit 1
        fi
    fi

    # Parse the current version
    CURRENT_VERSION=$(cat "setup.py" | egrep -o "'[0-9]+\.[0-9]+\.[0-9]+([a-z]+[0-9]*)?'" | egrep -o "[0-9]+\.[0-9]+\.[0-9]+([a-z]+[0-9]*)?")

    if [ ! ${?} -eq 0 ]; then
        echo "[ERROR] Current package version is not detected."
        cd ../../
        return 1 2> /dev/null; exit 1
    fi

    echo "Current version detected: ${CURRENT_VERSION}"
    echo "Please enter the new deploy version."
    echo "Rule: <major>.<minor>.<patch>                         release versioning style"
    echo "Rule: <major>.<minor>.<patch><state><change>          development versioning style"
    echo ""
    echo "      numbering:"
    echo "        * <major> : INT (REQUIRED): change when major change occur (e.g. reconstructing the whole model)"
    echo "        * <minor> : INT (REQUIRED): change when minor change occur (e.g. adding/deleting/changing features)"
    echo "        * <patch> : INT (REQUIRED): change when small change occur (e.g. bug fix, commenting, code styling)"
    echo "        * <state> : STR (OPTIONAL): 'a' - means 'alpha' version"
    echo "                                    'b' - means 'beta' version"
    echo "        * <change>: INT (OPTIONAL): optional number to indicate the change from previous version"
    echo ""
    echo "      ** VERSION MUST INCREASE ONLY (NOT ASSERTED HERE - IT WILL CAUSE ERROR WHEN UPLOADING) **"
    echo -n "Enter the new version (To keep the current version, enter 'n'): "
    read USER_INPUT

    if [ ! ${USER_INPUT} = "n" ] && [ ! ${USER_INPUT} = "N" ]; then
        echo "${USER_INPUT}" | egrep -o "^[0-9]+\.[0-9]+\.[0-9]+([a-z]+[0-9]*)?$" 1> /dev/null 2> /dev/null

        if [ ! ${?} -eq 0 ]; then
            echo "Please follow the versioning rule."
            echo "Aborting"
            cd ../../
            return 1 2> /dev/null; exit 1
        fi

        echo "Confirm the new version"
        echo "  (OLD): ${CURRENT_VERSION}"
        echo "  (NEW): ${USER_INPUT}"
        echo -n "Do you confirm the change? (y/n): "
        read AGREEMENT

        if [ ${AGREEMENT} = 'y' ] || [ ${AGREEMENT} = 'Y' ]; then
            echo -n "Updating..."
            sed -i "" "s/version='.*'/version='${USER_INPUT}'/g" "setup.py"
            echo "Done"
        else
            echo "Canceling the change...Done"
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

    # Activate publish purpose venv
    source ../../dev/publish-venv/bin/activate

    # Locate python
    VENV_PYTHON_LOC=$(which python)

    # Create binary distribution using wheel
    echo "Building binary distribution..."
    echo "=========================================="
    ${VENV_PYTHON_LOC} setup.py sdist bdist_wheel
    echo "=========================================="
    echo "Done"

    # Publish distribution
    echo "Uploading distribution..."
    echo "=========================================="
    if [ ${OPTION} = "test" ]; then
        ${VENV_PYTHON_LOC} -m twine upload --repository testpypi dist/*
        UPLOADED=${?}
    elif [ ${OPTION} = "release" ]; then
        ${VENV_PYTHON_LOC} -m twine upload --repository pypi dist/*
        UPLOADED=${?}
    fi
    echo "=========================================="
    echo "Done"

    deactivate
    cd ../../
    if [ ${UPLOADED} -eq 0 ]; then
        echo "Uploading completed successfully."
        return 0 2> /dev/null; exit 0
    else
        echo "Uploading completed failed."
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

    # Activate publish purpose venv
    source ../../dev/publish-venv/bin/activate

    # Locate python
    VENV_PYTHON_LOC=$(which python)

    # Create binary distribution using wheel
    echo "Building binary distribution..."
    echo "=========================================="
    ${VENV_PYTHON_LOC} setup.py sdist bdist_wheel
    echo "=========================================="
    echo "Done"

    # Deactivate
    deactivate

    # Go back to root
    cd ../../
elif [ ${OPTION} = "clear" ]; then
    echo -n "Clearing build/ and dist/..."

    # Remove build/ and dist/ if they exist
    if [ -d "build/" ]; then
        rm -rf "build/"
    fi

    if [ -d "dist/" ]; then
        rm -rf "dist/"
    fi

    echo "Done."

    # Go back to root
    cd ../../
fi

