#!/bin/sh
set -e

# --- helper functions for logs ---

info()
{
    echo '[INFO] ' "$@"
}

warn()
{
    echo '[WARN] ' "$@" >&2
}

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

{
    verify_system
}