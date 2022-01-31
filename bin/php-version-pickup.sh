#! /usr/bin/env bash

# PHP Version Pickup
#
# This script needs to modify the $PATH environment variable,
# and therefore needs to be »sourced« first (run `source php-version-pickup.sh`)

function php-version-pickup {
    function php-version-pickup::main {
        # Routing

        if [[ $1 == "--help" ]]; then
            php-version-pickup::command_help; return 0

        elif [[ $1 == "--version" ]]; then
            php-version-pickup::command_version; return 0

        elif [[ $1 == "use" ]]; then
            php-version-pickup::command_use; return 0

        else
            php-version-pickup::command_help; return 0
        fi
    }

    # Commands

    function php-version-pickup::command_version {
        version="1.0.0"
        echo -e "php-version-pickup (PHP Version Pickup) \033[32m$version\033[0m"
    }

    function php-version-pickup::command_help {
        php-version-pickup::command_version;
        echo "Usage:"
        echo "php-version-pickup use          Pick up version from environment variable or file"
        echo "php-version-pickup --help       Show help"
        echo "php-version-pickup --version    Show version"
    }

    function php-version-pickup::command_use {
        local PHP_VERSION_USE=$(php-version-pickup::get_version);
        if [ -z "$PHP_VERSION_USE" ]; then
            echo 'No version found'
            echo 'See `php-version-pickup --help` for more information'
            return 1;
        fi
        echo "Now using PHP version $PHP_VERSION_USE"

        # map available binary to version
        local PHP_VERSION_BINARY_PATH="/home/$USER/.php/versions/$PHP_VERSION_USE/bin"

        # populate binary to $PATH
        export PATH="$PHP_VERSION_BINARY_PATH:$PATH"
    }

    # Helper methods

    function php-version-pickup::get_version {
        # Pick up version from environment variable
        if [[ -n $PHP_VERSION ]]; then
            echo "Found environment variable \$PHP_VERSION" >&2
            echo "$PHP_VERSION"
            return;
        fi

        # Pick up version from file
        local PHP_VERSION_FILE=`cat .php-version 2>/dev/null`
        if [[ -n $PHP_VERSION_FILE ]]; then
            echo "Found $(pwd)/.php-version with version <$PHP_VERSION_FILE>" >&2
            echo "$PHP_VERSION_FILE"
        fi
    }

    php-version-pickup::main "$@"

    # clean up sourced namespaced functions
    unset -f $(compgen -A function php-version-pickup::)
}