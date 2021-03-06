# Embedded development environment for XMC with Docker

It sounds simple, but we are compiling source files OS independently to binaries for your ARM Cortex-M microcontroller here using Docker!

## Intro

This repository contains an example for developing embedded software using a GCC toolchain with Docker for the ARM Cortex-M XMC1100 microcontroller series.
More information about XMC as well as XMC1100 can be found [here](https://www.infineon.com/cms/en/product/microcontroller/32-bit-industrial-microcontroller-based-on-arm-cortex-m/).

Overall, the folder structure is self explaining with the main structure as shown here:

```bash
Repository/
┣ build/        # Build artifacts
┣ docs/         # Documentation
┣ lib/          # Library files
┣ src/          # Source files
┣ test/         # Test related files
┣ tools/        # Additional tools
┃ ┣ binaries/   # Binaries of tools
┃ ┣ docker/     # Docker files
┃ ┣ packaged/   # Packaged files, e.g. .zip files
┃ ┣ scripts/    # Scripts, e.g. Bash scripts
┣ LICENSE       # License file
┗ README.md     # Readme file (this file)
```

## Dependencies

In order to start developing with this repository, the following programs must be installed:

* [Docker](https://www.docker.com/)
* Bash environment (e.g. [Git Bash](https://gitforwindows.org/) on Windows)

## Quick start

In order to quickly start development, please execute the following commands from a Bash environment from the repository root folder `./`, e.g. with Git Bash on Windows:

```bash
$ source ./tools/scripts/setupEnvironment.sh
$ source ./test/testEnvironment.sh
$ Setup
```

The script `setupEnvironment.sh` will set up the build environment, create the Docker image if not already done, download the XMC Peripheral Library v2.1.24 and extract it to `/lib` plus trigger additional steps.

The script `testEnvironment.sh` runs tests of the environment and checks that everything is up and running smoothly.

After successful execution, the following commands will be available from the Bash console:

```Bash
$ # Redownload the XMC library to /lib
$ # Not checked out in repository due to the size
$ RefreshLib

$ # Kill a running Docker instance of xmc-build-env
$ # xmc-build-env is the tag of the build image
$ Kill
$ # Setup the Docker container xmc-build-env
$ # Must be executed before any other below command
$ Setup

$ # This command pipes anything following it to the Docker image
$ # Can be used to execute commands directly in the container 
$ D:
$ # This command pipes to the Docker image the make command
$ # Can be used like make command (with relative path from repository root ./)
$ make

$ # Makefile targets
$ # All make target (executed directly)
$ All
$ # Size make target (executed directly)
$ Size
$ # List make target (executed directly)
$ List
$ # Clean make target (executed directly)
$ Clean
```

Now, we can execute the following commands and build the `.elf` in `/build`:

```bash
$ Setup
$ All
$ # Equivalent command: make all
```

In order to clean the build folder, please execute:

```bash
$ Clean
$ # Equivalent command: make clean
```

## Used tools

### Development toolchain

Basically, we use a Docker flavoured portable toolchain with `i386/ubuntu:19.04` image and GCC 4.9 toolchain.
The Dockerfile can be found in `/tools/docker` with more details.
Builds are done in a container and are visible on the host machine directly in the `/build` folder.
This provides a portable toolchain independent of the underlying OS and results in consistend builds across different platforms.

For the build environment, a container with the tag `xmc-build-env` is generated and started.

When the container is launched, the folders `/lib`, `/src` are mounted readable, output files are stored in `/build` which is mounted read+writable.

The Docker container have the same root folder with the same folder structure.
Hence, you can directly reference to the folders with `./`.

#### Compiler

We are using the `ARM-GCC-49` in Docker which is the same one as the one shipped with [Dave](https://infineoncommunity.com/dave-download_ID645), the official XMC development platform.

#### Makefile

The Makefile is defined so that most parameters can be easily changed with variables.
Mainly, the approach follows the official Makefile documentation with adaption found on GitHub and StackExchange.
We use dependency check as shown in the makefile in `/src/makefile`.

#### Bash script

A Bash script is used to simplify the Docker command and provide a transparent mapping of the ones run in the container environment and locally on the development machine.

The Bash script can be found in `/tools/scripts/sourceEnvironment.sh`

The following commands will be available from the Bash console after sourcing the script file:

```Bash
$ # Redownload the XMC library to /lib
$ # Not checked out in repository due to the size
$ RefreshLib

$ # Kill a running Docker instance of xmc-build-env
$ # xmc-build-env is the tag of the build image
$ Kill
$ # Setup the Docker container xmc-build-env
$ # Must be executed before any other below command
$ Setup

$ # This command pipes anything following it to the Docker image
$ # Can be used to execute commands directly in the container 
$ D:
$ # This command pipes to the Docker image the make command
$ # Can be used like make command (with relative path from repository root ./)
$ make

$ # Makefile targets
$ # All make target (executed directly)
$ All
$ # Size make target (executed directly)
$ Size
$ # List make target (executed directly)
$ List
$ # Clean make target (executed directly)
$ Clean
```

#### Test script

A test script is provided to test the environment after having it set up.
You can execute the script and it will tell you whether you can run builds or tools/commands are missing.

The Bash script can be found in `/test/testEnvironment.sh`.