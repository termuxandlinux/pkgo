#!/bin/bash

URL_FILE="$HOME/.url/url.txt"

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

# Check if the first argument is "-i", "-s", or "-u"
if [ "$1" = "-i" ] || [ "$1" = "-s" ] || [ "$1" = "-u" ]; then
    # Check if exactly two or three arguments are provided
    if [ "$1" = "-u" ] && [ $# -ne 4 ]; then
        echo "Usage: $0 -u <package_name> <extra_argument>"
        exit 1
    elif [ $# -lt 2 ] || [ $# -gt 3 ]; then
        echo "Usage: $0 [-i|-s] <package_name> [extra_argument]"
        exit 1
    fi

    # Search for the package URL
    packageName=$2
    while read -r url; do
        if [ "$1" = "-u" ]; then
            extraArg="$3"
            fullUrl="$url/${packageName}/pkg/${extraArg}/${packageName}.deb"
            wget "$fullUrl"
            if [ $? -eq 0 ]; then
                echo "The latest package has been downloaded: $packageName"
                dpkg -i "${packageName}.deb"
                rm -f "${packageName}.deb"
                exit 0
            else
                echo "Failed to download package: $packageName"
                exit 1
            fi
        elif [ "$1" = "-i" ]; then
            fullUrl="$url/${packageName}/pkg/${packageName}.deb"
            wget "$fullUrl"
            if [ $? -eq 0 ]; then
                echo "The latest package has been downloaded: $packageName"
                dpkg -i "${packageName}.deb"
                rm -f "${packageName}.deb"
                exit 0
            fi
        elif [ "$1" = "-s" ]; then
            fullUrl="$url/${packageName}/pkg/${packageName}.deb"
            wget -q --spider "$fullUrl"
            if [ $? -eq 0 ]; then
                echo "Package found: $packageName"
                exit 0
            fi
        fi
    done < "$URL_FILE"
    echo "Failed to find package: $packageName"
    exit 1
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