#! /usr/bin/env bash

# PHP Version Pickup Test Script
# - Install assert.sh from https://github.com/torokmark/assert.sh
# - Install multiple PHP versions and configure the binary mappings
# - Run `bash run_tests.sh`

source "./assert.sh"
source "../bin/php-version-pickup.sh"
WORKING_DIRECTORY=$(pwd)

assert_contain "$(php-version-pickup --version)" "(PHP Version Pickup)" "Test general commands"

cd $WORKING_DIRECTORY
assert_contain "$(php-version-pickup use)" "Now using PHP version 7.4" "Test version pickup"
cd $WORKING_DIRECTORY/project-foo
assert_contain "$(php-version-pickup use)" "Now using PHP version 8.1" "Test version pickup"
cd $WORKING_DIRECTORY/project-bar
assert_contain "$(php-version-pickup use)" "Now using PHP version 7.1" "Test version pickup"
cd $WORKING_DIRECTORY/project-bar/subdirectory/with/many/other/directories
assert_contain "$(php-version-pickup use)" "Now using PHP version 7.1" "Test version pickup"
cd $WORKING_DIRECTORY/project-bar/subproject
assert_contain "$(php-version-pickup use)" "Now using PHP version 7.2" "Test version pickup"

cd $WORKING_DIRECTORY/project-baz
assert_contain "$(php-version-pickup use)" "Version number is faulty" "Test version pickup"
cd $WORKING_DIRECTORY/../
assert_contain "$(php-version-pickup use)" "No version found" "Test no version file found"
