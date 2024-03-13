#!/bin/bash

URL_FILE="$HOME/.url/url.txt"

# Function to find the latest package URL
find_latest_package_url() {
    packageName=$1
    highest_version=""
    latest_package=""
    while read -r url; do
        pkg_url="$url/${packageName}/pkg/"
        latest_pkg=$(wget -qO- "$pkg_url" | grep -oE "${packageName}_[0-9]+\.[0-9]+_[0-9]+\.deb" | sort -Vr | head -n1)
        if [ ! -z "$latest_pkg" ]; then
            latest_version=$(echo "$latest_pkg" | sed 's/.*_\([0-9]\+\.[0-9]\+\)_\([0-9]\+\)\.deb/\1/')
            if dpkg --compare-versions "$latest_version" gt "$highest_version"; then
                highest_version="$latest_version"
                latest_package="$latest_pkg"
            fi
        fi
    done < "$URL_FILE"
    echo "$latest_package"
}

# Check if any arguments are provided
if [ $# -eq 0 ]; then
    echo "Please provide arguments."
    exit 1
fi

# Handle special commands
if [ "$1" = "--" ]; then
    if [ $# -ne 2 ]; then
        echo "Usage: $0 -- [command]"
        echo "Available commands: help, setup, delete"
        exit 1
    fi

    case "$2" in
        "help")
            echo "Available commands:"
            echo "help - Show this help message"
            echo "setup - Create $HOME/.url/ directory"
            echo "delete - Delete /data/data/com.termux/files/usr/bin/pkgo"
            ;;
        "setup")
            mkdir -p "$HOME/.url/"
            ;;
        "delete")
            rm -f /data/data/com.termux/files/usr/bin/pkgo
            ;;
        *)
            echo "Unknown command. Use 'help' to see available commands."
            exit 1
            ;;
    esac
    exit 0
fi

# Check if the first argument is "-i" or "-s"
if [ "$1" = "-i" ] || [ "$1" = "-s" ]; then
    # Check if exactly two arguments are provided
    if [ $# -ne 2 ]; then
        echo "Usage: $0 [-i|-s] <package_name>"
        exit 1
    fi

    # Search for the package URL
    packageName=$2
    if [ "$1" = "-i" ]; then
        latest_pkg=$(find_latest_package_url "$packageName")
        if [ ! -z "$latest_pkg" ]; then
            wget "$latest_pkg"
            if [ $? -eq 0 ]; then
                echo "The latest package has been downloaded: $latest_pkg"
                dpkg -i "${latest_pkg}"
                rm -f "${latest_pkg}"
                exit 0
            fi
        else
            echo "Failed to find package: $packageName"
            exit 1
        fi
    elif [ "$1" = "-s" ]; then
        if find_latest_package_url "$packageName"; then
            echo "Package found: $packageName"
            exit 0
        else
            echo "Package not found: $packageName"
            exit 1
        fi
    fi
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