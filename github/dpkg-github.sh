#!/bin/bash

# https://github.com/kevinkhill/dpkg-github

set -e
#set -x

reset="\033[0m"
red="\033[0;31m"
purp="\033[0;35m"
cyan="\033[0;36m"
green="\033[1;32m"
yellow="\033[1;33m"
blue="\033[1;36m"

silent=false
arch="amd64"
deb_list="$HOME/.dpkg-github"
temp_dir="/tmp/dpkg-github"

(mkdir -p "$temp_dir" && cd "$temp_dir") || exit 1

function out() {
    if ! $silent; then
        echo -e "dpkg-github: $1" >&2
    fi
}

function get_latest_release_urls() {
    local url="https://api.github.com/repos/${1}/releases/latest"

    curl -s "$url" | grep browser_ | cut -d\" -f4 | grep deb
}

function get_latest_release_url() {
    out "${purp}Querying Github for latest release.${reset}"

    local release="$(get_latest_release_urls "$1" | grep ${arch} | grep -v musl)"

    local filename="${release##*/}"

    out "${green}Found ${filename}${reset}"

    echo "$release"
}

function download_latest_deb() {
    local url="$(get_latest_release_url "$1")"
    local filename="${url##*/}"
    local deb="$temp_dir/$filename"

    if ! [[ -f "$deb" ]]; then
        out "${blue}Downloading...${reset}"

        curl -sLo "$deb" "$url"

        out "${cyan}Saved to ${deb}${reset}"
    fi

    echo "$deb"
}

function install_from_github() {
    out "${yellow}Fetching .deb for ${1}${reset}"

    path_to_deb="$(download_latest_deb "$1")"
    deb_provides="$(dpkg-deb -f "$path_to_deb" Provides)"

    if [[ "$(command -v $deb_provides)" ]]; then
        out "${yellow}Package providing '$deb_provides' is installed${reset}"
    else
        sudo dpkg -i "$path_to_deb"
    fi
}

function get_latest_deb_version() {
    local url="$(get_latest_release_url "$1")"
    local filename="${url##*/}"
    local packver="${filename%_*}"

    echo "${packver#*_}"
}

function usage {
    echo ""
    echo "Usage:"
    echo "  dpkg-github [-s] [-a <arch>] (-v|-l|-u|-i) <user/repo>"
    echo ""
    echo "Flags:"
    echo "  -s  Be silent, do not output superflous messages"
    echo ""
    echo "Options:"
    echo "  -a <arch>  Set .deb arch type (default: amd64)"
    echo ""
    echo "Args:"
    echo "  <arch>       Type of arch deb file to search for, maybe i386, or armf"
    echo "  <user/repo>  Github user/repo that provides a .deb to install"
    echo ""
}

function __exit() {
    usage
    exit 1
}

while getopts ":hsa:d:i:l:u:v:" options; do
    case "${options}" in
    h) usage ;;
    s) silent=true ;;
    a) arch="${OPTARG}" ;;

    i) install_from_github "${OPTARG}" ;;
    l) get_latest_release_urls "${OPTARG}" ;;

    d)
        silent=true
        download_latest_deb "${OPTARG}"
        ;;
    u)
        silent=true
        get_latest_release_url "${OPTARG}"
        ;;
    v)
        silent=true
        get_latest_deb_version "${OPTARG}"
        ;;
    :)
        echo "Error: -${OPTARG} requires an argument."
        __exit
        ;;
    \?)
        out "Error: ${OPTARG} is not a valid argument."
        __exit
        ;;
    *) __exit ;;
    esac
done
shift $((OPTIND - 1))
