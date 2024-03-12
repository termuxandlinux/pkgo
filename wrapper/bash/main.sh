#!/bin/bash

# Check if any arguments are provided
if [ $# -eq 0 ]; then
    echo "Please provide arguments."
    exit 1
fi

# Check if the first argument is "-i"
if [ "$1" = "-i" ]; then
    # Check if exactly two arguments are provided
    if [ $# -ne 2 ]; then
        echo "Usage: $0 -i <package_name>"
        exit 1
    fi

    # Install the package
    packageName=$2
    url="https://termux-pkg.netlify.app/$packageName/pkg/${packageName}.deb"
    pkgDir="./$packageName/pkg"
    wget "$url"
    echo "The latest package has been downloaded: $packageName"
    dpkg -i "${packageName}.deb"
    rm -r -f "${packageName}.deb"
    exit 0
fi

# Check if the first argument is "install" or "search"
if [ "$1" = "install" ] || [ "$1" = "search" ]; then
    # Check if exactly two arguments are provided
    if [ $# -ne 2 ]; then
        echo "Usage: $0 [install|search] <package_name>"
        exit 1
    fi

    # Pass the arguments to "pkg" command
    pkg "$@"
    exit 0
fi

echo "Invalid arguments provided."
exit 1
