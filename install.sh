#!/bin/sh
set -e

GITHUB_URL=https://github.com/kubecms/kubecms
GITHUB_VERSION=master

# --- helper functions for logs ---

fatal()
{
    echo '[ERROR] ' "$@" >&2
}

# --- fatal if no kubectl ---
verify_system() 
{
    if [ -x "$(command -v kubectl)" ]; then
        HAS_KUBECTL=true
        return
    fi
    fatal 'Could not find kubectl to use as a provisioner of Kube CMS'
}

# --- verify existence of network downloader executable ---
verify_downloader() 
{
    # Return failure if it doesn't exist or is no executable
    [ -x "$(which $1)" ] || return 1

    # Set verified executable as our downloader program and return success
    DOWNLOADER=$1
    return 0
}

# --- create tempory directory and cleanup when done ---
setup_tmp() 
{
    TMP_DIR=$(mktemp -d -t kubecms-install)

    cleanup() 
    {
        code=$?
        set +e
        trap - EXIT
        rm -rf ${TMP_DIR}
        exit $code
    }

    trap cleanup INT EXIT
}

# --- download binary from github url ---
download_binary() 
{
    ZIP_URL=${GITHUB_URL}/archive/${GITHUB_VERSION}.zip
    info "Downloading zip ${ZIP_URL}"
}

# --- download and verify kubecms ---
download_and_verify() 
{
    verify_downloader curl || verify_downloader wget || fatal 'Could not find curl or wget for downloading files'
    setup_tmp
    download_binary
}

{
    verify_system
    download_and_verify
}