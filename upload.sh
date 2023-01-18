#!/usr/bin/env bash
# @ VERSION   0.1.0
# @ AUTHOR    John Yoon
# @ LICENSE   MIT
#
#   Use this to aid package upload process (Mac/Linux only).
#   To see details about usage, run "source upload.sh --help"
#   If there's any issues, please contact John Yoon <fedelejohn7008@gmail.com>

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
    echo "For more information, please check \"source upload.sh --help\" for usage."
    return 1 2> /dev/null; exit 1
fi

# TODO: Check if they ran env_setup.sh beforehand

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
    echo "Invalid argument, please check \"source upload.sh --help\" for usages."
}

# Detect args
if [ ${#} -eq 0 ]; then
    echo "No argument detected, please check \"source upload.sh --help\" for usages."
    return 1 2> /dev/null; exit 1
fi

if [ ${#} -eq 1 ]; then
    if [ ${1} = "-h" ] || [ ${1} = "--help" ]; then
        print_help
        return 0 2> /dev/null; exit 0
    elif [ ${1} = "-s" ] || [ ${1} = "--setup" ]; then
        MODE="setup"
    elif [ ${1} = "-a" ] || [ ${1} = "--api" ]; then
        MODE="api"
        OPTION="test"
    elif [ ${1} = "-d" ] || [ ${1} = "--dnn" ]; then
        MODE="dnn"
        OPTION="test"
    else
        invalid_args
        return 1 2> /dev/null; exit 1
    fi
fi

if [ ${#} -eq 2 ]; then
    if [ ${1} = "-s" ] || [ ${1} = "--setup" ]; then
        if [ ${2} = "-c" ] || [ ${2} = "--clear" ]; then
            MODE="reset"
        else
            invalid_args
            return 1 2> /dev/null; exit 1
        fi
    elif [ ${1} = "-a" ] || [ ${1} = "--api" ]; then
        MODE="api"
        if [ ${2} = "-t" ] || [ ${2} = "--test" ]; then
            OPTION="test"
        elif [ ${2} = "-r" ] || [ ${2} = "--release" ]; then
            OPTION="release"
        elif [ ${2} = "-b" ] || [ ${2} = "--build" ]; then
            OPTION="build"
        elif [ ${2} = "-c" ] || [ ${2} = "--clear" ]; then
            OPTION="clear"
        else
            invalid_args
            return 1 2> /dev/null; exit 1
        fi
    elif [ ${1} = "-d" ] || [ ${1} = "--dnn" ]; then
        MODE="dnn"
        if [ ${2} = "-t" ] || [ ${2} = "--test" ]; then
            OPTION="test"
        elif [ ${2} = "-r" ] || [ ${2} = "--release" ]; then
            OPTION="release"
        elif [ ${2} = "-b" ] || [ ${2} = "--build" ]; then
            OPTION="build"
        elif [ ${2} = "-c" ] || [ ${2} = "--clear" ]; then
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
    # TODO: Setup ~/.pypirc (https://www.sysnet.pe.kr/2/0/12863)
elif [ ${MODE} = "reset" ]; then
    # TODO: Remove ~/.pypirc
elif [ ${MODE} = "api" ]; then
    # TODO: Set directory to packages/api    
elif [ ${MODE} = "dnn" ]; then
    # TODO: Set directory to packages/dnn
fi

if [ ${OPTION} = "test" ]; then
    # TODO: If they haven't setup yet ask them about it
    # TODO: If they have build/ and dist/ remove them first
    # TODO: Prompt Version up
    # TODO: python setup.py bdist_wheel
    # TODO: python -m twine upload --repository testpypi dist/*
elif [ ${OPTION} = "release" ]; then
    # TODO: If they haven't setup yet ask them about it
    # TODO: If they have build/ and dist/ remove them first
    # TODO: Prompt Version up
    # TODO: python setup.py bdist_wheel
    # TODO: python -m twine upload dist/*
elif [ ${OPTION} = "build" ]; then
    # TODO: If they have build/ and dist/ remove them first
    # TODO: python setup.py bdist_wheel
elif [ ${OPTION} = "clear" ]; then
    # TODO: remove build/ and dist/
fi

# TODO: If they abort during the procedure, undo everything (e.g. move back to root)