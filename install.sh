#!/bin/sh
set -e

# --- helper functions for logs ---

fatal()
{
    echo '[ERROR] ' "$@" >&2
    exit 1
}

# --- fatal if no kubectl ---
verify_system() {
    if [ -x "$(command -v kubectl)" ]; then
        HAS_KUBECTL=true
        return
    fi
    fatal 'Could not find kubectl to use as a provisioner of Kube CMS'
}

{
    verify_system
}