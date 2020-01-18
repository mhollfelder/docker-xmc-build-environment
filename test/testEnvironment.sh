#!/bin/bash

echo "### Running tests"
echo "###"

# https://stackoverflow.com/a/246128
# Get the directory from where the script is called for further path resolution
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
#

echo "### Testing for XMC library..."
if [ -d "${DIR}/../lib/XMC_Peripheral_Library_v2.1.24" ]
then
    echo "XMC_Peripheral_Library_v2.1.24 downloaded and in /lib/ existing..."
else
    echo "ERROR: XMC_Peripheral_Library_v2.1.24 missing, redownload it please with RefreshLib..."
    return 1
fi

echo "### Testing for Docker environment..."
command -v docker > /dev/null
if [ $? = 0 ]; 
    then
        echo "### Docker correctly installed..."
    else
        echo "### ERROR: Docker cannot be found - please install Docker first or add it to PATH..."
        return 1
fi

echo "### Testing existence of Docker image with tag xmc-build-env..."
if [[ ! "$(docker images -q xmc-build-env)" == "" ]]; 
    then
        echo "### Docker image xmc-build-env found..."
    else
        echo "### ERROR: Docker image xmc-build-env cannot be found..."
        return 1
fi

echo "### Testing for Bash commands..."

type RefreshLib > /dev/null
if [ $? = 0 ]; 
    then
        echo "### Command RefreshLib existing..."
    else
        echo "### ERROR: Command RefreshLib not existing, execute setupEnvironment.sh again..."
        return 1
fi

type Kill > /dev/null
if [ $? = 0 ]; 
    then
        echo "### Command Kill existing..."
    else
        echo "### ERROR: Command Kill not existing, execute setupEnvironment.sh again..."
        return 1
fi

type Setup > /dev/null
if [ $? = 0 ]; 
    then
        echo "### Command Setup existing..."
    else
        echo "### ERROR: Command Setup not existing, execute setupEnvironment.sh again..."
        return 1
fi

type D: > /dev/null
if [ $? = 0 ]; 
    then
        echo "### Command D: existing..."
    else
        echo "### ERROR: Command D: not existing, execute setupEnvironment.sh again..."
        return 1
fi

type make > /dev/null
if [ $? = 0 ]; 
    then
        echo "### Command make (pipe function to container) existing..."
    else
        echo "### ERROR: Command make (pipe function to container) not existing, execute setupEnvironment.sh again..."
        return 1
fi

type All > /dev/null
if [ $? = 0 ]; 
    then
        echo "### Command All existing..."
    else
        echo "### ERROR: Command All not existing, execute setupEnvironment.sh again..."
        return 1
fi

type Size > /dev/null
if [ $? = 0 ]; 
    then
        echo "### Command Size existing..."
    else
        echo "### ERROR: Command Size not existing, execute setupEnvironment.sh again..."
        return 1
fi

type List > /dev/null
if [ $? = 0 ]; 
    then
        echo "### Command List existing..."
    else
        echo "### ERROR: Command List not existing, execute setupEnvironment.sh again..."
        return 1
fi

type Clean > /dev/null
if [ $? = 0 ]; 
    then
        echo "### Command Clean existing..."
    else
        echo "### ERROR: Command Clean not existing, execute setupEnvironment.sh again..."
        return 1
fi

echo "###"
echo "### Tests passed successfully"