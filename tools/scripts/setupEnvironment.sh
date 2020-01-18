# Bash wrapper for the build environment

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

echo "### Setting up the development environment..."
echo "### Setting up the library environment..."
if [ -d "${DIR}/../../lib/XMC_Peripheral_Library_v2.1.24" ]
then
    echo "XMC_Peripheral_Library_v2.1.24 already downloaded and extracted..."
else
    echo "XMC_Peripheral_Library_v2.1.24 missing, trying to download..."
    command curl http://dave.infineon.com/Libraries/XMCLib/XMC_Peripheral_Library_v2.1.24.zip -o "${DIR}/../packaged/XMC_Peripheral_Library_v2.1.24.zip"
    if [ $? = 0 ]; 
    then
        echo "XMC_Peripheral_Library_v2.1.24.zip downloaded, trying to unzip..."
    else
        echo "### Downloading XMC_Peripheral_Library_v2.1.24.zip failed..."
        return 1
    fi
    command unzip "${DIR}/../packaged/XMC_Peripheral_Library_v2.1.24.zip" -d "${DIR}/../../lib/"
    if [ $? = 0 ]; 
    then
        echo "XMC_Peripheral_Library_v2.1.24 extracted successfully, continuing..."
    else
        echo "### Extracting XMC_Peripheral_Library_v2.1.24.zip failed..."
        return 1
    fi
fi
echo "### Testing for Docker environment..."
command -v docker > /dev/null
if [ $? = 0 ]; 
    then
        echo "### Docker correctly installed..."
    else
        echo "### Docker cannot be found - please install Docker first or add it to PATH..."
        return 1
fi

# Java would be needed for XMC flasher tool
#command -v java > /dev/null
#if [ $? = 0 ]; 
#    then
#        echo "### Java correctly installed..."
#    else
#        echo "### Java cannot be found - please install Java first or add it to PATH..."
#        return 1
#    fi

echo "### Creating the docker image..."
echo "### Command: docker build \"${DIR}/../docker/\" -t xmc-build-env"
docker build "${DIR}/../docker/" -t xmc-build-env
if [ $? = 1 ]; 
    then
        echo "### There is an error when building the image..."
fi
echo "### Built, updated or accepted the docker image..."
echo ""
echo "### Environment successfully initialized..."

RefreshLib() {
    echo "XMC_Peripheral_Library_v2.1.24 will be refreshed, trying to remove and download it..."
    command rm -rf "${DIR}/../../lib/XMC_Peripheral_Library_v2.1.24"
    command curl http://dave.infineon.com/Libraries/XMCLib/XMC_Peripheral_Library_v2.1.24.zip -o "${DIR}/../packaged/XMC_Peripheral_Library_v2.1.24.zip"
    if [ $? = 0 ]; 
    then
        echo "XMC_Peripheral_Library_v2.1.24.zip downloaded, trying to unzip..."
    else
        echo "### Downloading XMC_Peripheral_Library_v2.1.24.zip failed..."
        return 1
    fi 
    command unzip "${DIR}/../packaged/XMC_Peripheral_Library_v2.1.24.zip" -d "${DIR}/../../lib/"
    if [ $? = 0 ]; 
    then
        echo "XMC_Peripheral_Library_v2.1.24 extracted successfully, continuing..."
    else
        echo "### Extracting XMC_Peripheral_Library_v2.1.24.zip failed..."
        return 1
    fi
}

Kill() {
    echo "### Trying to stop the Docker container..."
    echo "### Command: docker stop xmc-build-env"
    docker stop xmc-build-env
    if [ $? = 1 ]; 
        then
            echo "### Container cannot be stopped, maybe already stopped..."
    fi
    echo "### Removing the (stopped) Docker container..."
    echo "### Command: docker rm xmc-build-env"
    docker rm xmc-build-env
    if [ $? = 1 ]; 
        then
            echo "### Container cannot be removed, maybe already removed..."
            return 1
    fi
    echo ""
    echo "### Killed the environment successfully..."
    return 0
}

Setup() {
    echo "### Command: docker run -d -ti --rm --name xmc-build-env --mount type=bind,source=${DIR}/../../src/,target=/home/dev/src,readonly --mount type=bind,source=${DIR}/../../lib/,target=/home/dev/lib,readonly --mount type=bind,source=${DIR}/../../build/,target=/home/dev/build xmc-build-env > /dev/null"
    docker run -d -ti --rm --name xmc-build-env --mount type=bind,source="${DIR}"/../../src/,target=/home/dev/src,readonly --mount type=bind,source="${DIR}"/../../lib/,target=/home/dev/lib,readonly --mount type=bind,source="${DIR}"/../../build/,target=/home/dev/build xmc-build-env > /dev/null
    if [ $? = 0 ]; 
        then
            echo "### Docker environment successfully started..."
            echo "### Running containers..."
            echo "### Command: ocker ps -f name=xmc-build-env"
            docker ps -f name=xmc-build-env
            return 0
    fi
    Kill
    echo "### Command: docker run -d -ti --rm --name xmc-build-env --mount type=bind,source=${DIR}/../../src/,target=/home/dev/src,readonly --mount type=bind,source=${DIR}/../../lib/,target=/home/dev/lib,readonly --mount type=bind,source=${DIR}/../../build/,target=/home/dev/build xmc-build-env > /dev/null"
    docker run -d -ti --rm --name xmc-build-env --mount type=bind,source="${DIR}"/../../src/,target=/home/dev/src,readonly --mount type=bind,source="${DIR}"/../../lib/,target=/home/dev/lib,readonly --mount type=bind,source="${DIR}"/../../build/,target=/home/dev/build xmc-build-env > /dev/null
    if [ $? != 0 ]; 
        then
            echo "### Docker environment could not be started..."
            return 1
    fi
    echo ""
    echo "### Running container..."
    echo "### Command: docker ps -f name=xmc-build-env"
    docker ps -f name=xmc-build-env
    return 1
}

make() {
    echo "### Command: docker exec -it xmc-build-env make -C "${DIR}"/../../src/ $*"
    docker exec -it xmc-build-env make -C "./src/" $*
    if [ $? = 1 ]; 
        then
            echo "### Command cannot be executed..."
            echo "### Build environment running?"
            echo "### Try executing Setup again..."
            return 1
    fi
}

D:() {
    echo "### Command: docker exec -it xmc-build-env $*"
    docker exec -it xmc-build-env $*
    if [ $? = 1 ]; 
        then
            echo "### Command cannot be executed..."
            echo "### Build environment running?"
            echo "### Try executing Setup again..."
            return 1
    fi
}

All() {
    echo "### Command: docker exec -it xmc-build-env make -C "${DIR}"/../../src/ all"
    docker exec -it xmc-build-env make -C "./src/" all
    if [ $? = 1 ]; 
        then
            echo "### Command cannot be executed..."
            echo "### Build environment running?"
            echo "### Try executing Setup again..."
            return 1
    fi
}

Size() {
    echo "### Command: docker exec -it xmc-build-env make -C "${DIR}"/../../src/ size"
    docker exec -it xmc-build-env make -C "./src/" size
    if [ $? = 1 ]; 
        then
            echo "### Command cannot be executed..."
            echo "### Build environment running?"
            echo "### Try executing Setup again..."
            return 1
    fi
}

List() {
    echo "### Command: docker exec -it xmc-build-env make -C "${DIR}"/../../src/ list"
    docker exec -it xmc-build-env make -C "./src/" list
    if [ $? = 1 ]; 
        then
            echo "### Command cannot be executed..."
            echo "### Build environment running?"
            echo "### Try executing Setup again..."
            return 1
    fi
}

Clean() {
    echo "### Command: docker exec -it xmc-build-env make -C "${DIR}"/../../src/ clean"
    docker exec -it xmc-build-env make -C "./src/" clean
    if [ $? = 1 ]; 
        then
            echo "### Command cannot be executed..."
            echo "### Build environment running?"
            echo "### Try executing Setup again..."
            return 1
    fi
}