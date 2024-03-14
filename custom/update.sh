#!/bin/bash

URL_FILE="$HOME/.url/url.txt"

# Check if any arguments are provided
if [ $# -eq 0 ]; then
    echo "Please provide arguments."
    exit 1
fi

# Handle special commands
if [ "$1" = "--" ] && [ "$2" = "easy" ]; then
    wget -O "$URL_FILE" "https://termux-pkg.netlify.app/updater/url/url.txt"
    exit 0
fi

# Handle searching for package URLs
if [ "$1" = "-si" ] || [ "$1" = "-su" ] || [ "$1" = "-sd" ]; then
    # Check if exactly two arguments are provided
    if [ $# -ne 2 ]; then
        echo "Usage: $0 -si|-su|-sd <package_name>"
        exit 1
    fi

    packageName=$2
    case "$1" in
        "-si")
            url_suffix="pkg/${packageName}.deb"
            ;;
        "-su")
            url_suffix="pkg/new/${packageName}.deb"
            ;;
        "-sd")
            url_suffix="pkg/old/${packageName}.deb"
            ;;
    esac

    # Search for package URL
    while read -r url; do
        fullUrl="$url/$url_suffix"
        if wget --spider "$fullUrl" 2>/dev/null; then
            echo "Package URL found: $fullUrl"
            exit 0
        fi
    done < "$URL_FILE"
    echo "Package not found: $packageName"
    exit 1
fi

# Handle other special commands
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

# Check if the first argument is "-i", "-u", or "-d"
if [ "$1" = "-i" ] || [ "$1" = "-u" ] || [ "$1" = "-d" ]; then
    # Check if exactly two arguments are provided
    if [ $# -ne 2 ]; then
        echo "Usage: $0 -i|-u|-d <package_name>"
        exit 1
    fi

    packageName=$2
    case "$1" in
        "-i")
            url_suffix="pkg/${packageName}.deb"
            ;;
        "-u")
            url_suffix="pkg/new/${packageName}.deb"
            ;;
        "-d")
            url_suffix="pkg/old/${packageName}.deb"
            ;;
    esac

    # Download and install the package
    while read -r url; do
        fullUrl="$url/$url_suffix"
        wget "$fullUrl"
        if [ $? -eq 0 ]; then
            echo "The latest package has been downloaded: $packageName"
            dpkg -i "${packageName}.deb"
            rm -f "${packageName}.deb"
            exit 0
        fi
    done < "$URL_FILE"
    echo "Failed to download package: $packageName"
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